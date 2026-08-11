/*
 * Copyright (c) 2023-2025 Haitai FangYuan Co., Ltd.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of
 *    conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list
 *    of conditions and the following disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import account_osAccount from '@ohos.account.osAccount';
import { inject, injectable } from 'inversify';
import certManager from '@ohos.security.certManager';
import { certificateManager } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@ohos.base';
import fs, { Filter } from '@ohos.file.fs';
import certificateManagerDialog from '@ohos.security.certManagerDialog';
import { deviceInfo } from '@kit.BasicServicesKit';

import { BaseAdapter } from '../common/BaseAdapter';
import LogUtil from '../utils/LogUtil';
import LogMethod from '../common/LogDecorator';
import { ContextAdapter } from './ContextAdapter';
import { huks } from '@kit.UniversalKeystoreKit';

class ListFileOption {
  public recursion: boolean = false;
  public listNum: number = 0;
  public filter: Filter = {};
}

interface OhosCertInfo {
  cert: string;
  uri: string;
  type: number;
}

const TAG: string = 'CertManagerAdapter';

@injectable()
export class CertManagerAdapter extends BaseAdapter {
  private ctxAdapter: ContextAdapter;
  private keyUri: string;

  constructor(@inject(ContextAdapter) ctxAdapter: ContextAdapter) {
    super();
    this.ctxAdapter = ctxAdapter;
    this.keyUri = "";
  }

  get uriPath(): string {
    return `${this.ctxAdapter.getContext().filesDir}/uris`;
  }

  readFile(filePath: string) : string {
    let res = fs.accessSync(filePath);
    if (!res) {
      return '';
    }
    let fileStat = fs.lstatSync(filePath);
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY | fs.OpenMode.CREATE);
    let buf = new ArrayBuffer(fileStat.size);
    fs.readSync(file.fd, buf);
    fs.closeSync(file);
    return this.uint8ArrayToString(new Uint8Array(buf));
  }

  @LogMethod
  installPersonalCert(certData: ArrayBuffer,
    certPass: string,
    alias: string,
    callback: (ready: number) => void) {
    const keystore: Uint8Array =  new Uint8Array(certData);
    const keystorePwd: string = certPass;
    certManager.installPrivateCertificate(keystore, keystorePwd, alias)
      .then((cmResult) => {
        callback(0);
      }).catch((err: BusinessError) => {
      LogUtil.error(TAG, `installPrivateCertificate failed, code: ${err.code}`);
      callback(err.code);
    });
  }

  private uint8ArrayToString(data: Uint8Array) {
    return data.reduce((prev, current) => prev + String.fromCharCode(current), '');
  }

  private base64Encode(bytes: Uint8Array): string {
    const base64Chars : string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    let result = '';
    let i = 0;

    for (i = 0; i < bytes.length; i += 3) {
      // 获取3个字节
      const byte1 = bytes[i];
      const byte2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      const byte3 = i + 2 < bytes.length ? bytes[i + 2] : 0;

      // 组合成24位
      const combined = (byte1 << 16) | (byte2 << 8) | byte3;

      // 转换为4个Base64字符
      const char1 = base64Chars[(combined >> 18) & 0x3F];
      const char2 = base64Chars[(combined >> 12) & 0x3F];
      const char3 = i + 1 < bytes.length ? base64Chars[(combined >> 6) & 0x3F] : '=';
      const char4 = i + 2 < bytes.length ? base64Chars[combined & 0x3F] : '=';

      result += char1 + char2 + char3 + char4;
    }

    return result;
  }

  /**
   * 格式化Base64字符串（每64字符换行）
   */
  private formatBase64(base64: string, lineLength: number = 64): string {
    const lines: string[] = [];
    for (let i = 0; i < base64.length; i += lineLength) {
      lines.push(base64.substring(i, i + lineLength));
    }
    return lines.join('\n');
  }

  private derToPem(derData: Uint8Array, type: string = 'CERTIFICATE'): string {
    const base64 : string = this.base64Encode(derData);
    const formatted : string = this.formatBase64(base64);
    return `-----BEGIN ${type}-----\n${formatted}\n-----END ${type}-----`;
  }

  private getRsaSignProperties() {
    let properties: huks.HuksParam[] = [{
      tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
      value: huks.HuksKeyAlg.HUKS_ALG_RSA
    }, {
      tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
      value: huks.HuksKeySize.HUKS_RSA_KEY_SIZE_2048
    }, {
      tag: huks.HuksTag.HUKS_TAG_PURPOSE,
      value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_SIGN
    }, {
      tag: huks.HuksTag.HUKS_TAG_PADDING,
      value: huks.HuksKeyPadding.HUKS_PADDING_PKCS1_V1_5
    }, {
      tag: huks.HuksTag.HUKS_TAG_DIGEST,
      value: huks.HuksKeyDigest.HUKS_DIGEST_SHA256
    }, {
      tag: huks.HuksTag.HUKS_TAG_KEY_CLASS,
      value: huks.HuksKeyClassType.HUKS_KEY_CLASS_EXTENSION
    }];
    return properties;
  }

  @LogMethod
  async getAllPrivateCertificates(callback: Function) {
    const certInfos: OhosCertInfo[] = [];
    try {
      certificateManager.getPrivateCertificates().then(async (cmResult) => {
        if (cmResult === undefined || cmResult.credentialList === undefined) {
          LogUtil.error(TAG, `credentialList is undefined.`);
          callback(certInfos, 0);
          return;
        }

        let list = cmResult.credentialList;
        for (let i = 0; i < list.length; i++) {
          let cmResult = await certManager.getPrivateCertificate(list[i].keyUri);
          if (cmResult && cmResult.credential && cmResult.credential.keyNum > 0) {
            const certInfo: OhosCertInfo = {
              uri: list[i].keyUri,
              cert: this.uint8ArrayToString(cmResult.credential.credentialData),
              type: certificateManagerDialog.CertificateType.CREDENTIAL_USER
            };
            certInfos.push(certInfo);
          }
        }
        callback(certInfos, certInfos.length);
      }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `getPrivateCertificates failed, code: ${err.code}`);
        callback(certInfos, 0);
      })
    } catch (error) {
      LogUtil.error(TAG, `getPrivateCertificates failed, code: ${error.code}`);
      callback(certInfos, 0);
    }
  }

  @LogMethod
  removeCertByUri(uriparam: string, callback: Function) {
    certManager.uninstallPrivateCertificate(uriparam).then(() => {
      callback(0);
    }).catch((err: BusinessError) => {
      LogUtil.error(TAG, `uninstallPrivateCertificate failed, code: ${err.code}`);
      callback(err.code);
    });
  }

  @LogMethod
  signByCertUri(uri: string, inputData: ArrayBuffer, callback: Function): void {
    const input: Uint8Array =  new Uint8Array(inputData);
    const buffer_return = new ArrayBuffer(0);
    const SignReq: certManager.CMSignatureSpec = {
      purpose: certManager.CmKeyPurpose.CM_KEY_PURPOSE_SIGN,
      padding: certManager.CmKeyPadding.CM_PADDING_PKCS1_V1_5,
      digest: certManager.CmKeyDigest.CM_DIGEST_SHA256
    }
    certManager.init(uri, SignReq, (err: BusinessError, SignHandle: certManager.CMHandle) => {
      if (err) {
        LogUtil.error(TAG, `init sign failed, code: ${err.code}`);
        callback(buffer_return);
        return;
      }
      const SignHandle_const = SignHandle.handle;
      certManager.update(SignHandle_const, input, (err: BusinessError) => {
        if (err) {
          LogUtil.error(TAG, `update sign failed, code: ${err.code}`);
          callback(buffer_return);
          return;
        }
        certManager.finish(SignHandle_const).then((cmResult) => {
          callback(cmResult.outData || buffer_return);
        }).catch((err: BusinessError) => {
          LogUtil.error(TAG, `finish sign failed, code: ${err.code}`);
          callback(buffer_return);
        });
      });
    })
  }

  async getUserId(): Promise<number> {
    let accountManager = account_osAccount.getAccountManager();
    let localId: number = await accountManager.getOsAccountLocalId();
    return await Promise.resolve(localId);
  }

  @LogMethod
  async returnUserId(callback: Function) {
    let userid: number = await this.getUserId();
    callback(userid);
  }

  @LogMethod
  async getCertCrl(pathDirPrefix:string, getUserIdFlag: boolean, callback: Function) {
    let option = new ListFileOption();
    let pathDir: string;
    if (getUserIdFlag) {
      let userid: number = await this.getUserId();
      pathDir = pathDirPrefix + userid;
    } else {
      pathDir = pathDirPrefix;
    }

    let cert_crl = new Array<string>();
    let res = fs.accessSync(pathDir);
    if (!res) {
      callback(cert_crl, 0);
      return;
    }
    let filenames = fs.listFileSync(pathDir, option);

    for (let i = 0; i < filenames.length; i++) {
      let filePath: string = pathDir + '/' + filenames[i];
      let buf: string = this.readFile(filePath);
      cert_crl.push(buf);
    }
    callback(cert_crl, cert_crl.length);
  }

  @LogMethod
  showCertificateManagerDialog(certType: number) {
    enum CertType {
      OTHER_CERT,
      CA_CERT,
      USER_CERT,
      SERVER_CERT,
      NUM_CERT_TYPES
    }
    let activeContext = this.ctxAdapter.getActiveContext();
    if (!activeContext) {
      LogUtil.warn(TAG, 'Failed to get active context');
      return;
    }

    let pageType: certificateManagerDialog.CertificateDialogPageType =
       certificateManagerDialog.CertificateDialogPageType.PAGE_MAIN;
    if (certType == CertType.CA_CERT) {
      pageType = certificateManagerDialog.CertificateDialogPageType.PAGE_CA_CERTIFICATE;
    } else if (certType == CertType.USER_CERT) {
      pageType = certificateManagerDialog.CertificateDialogPageType.PAGE_INSTALL_CERTIFICATE;
    }

    try {
      certificateManagerDialog.openCertificateManagerDialog(activeContext, pageType)
        .then(() => {
        }).catch((err: BusinessError) => {
        LogUtil.error(TAG, `openCertificateManagerDialog failed, code: ${err.code}`);
      })
    } catch (error) {
      LogUtil.error(TAG, `openCertificateManagerDialog failed, code: ${error.code}`);
    }
  }

  @LogMethod
  isSdk22(callback: Function) {
    let ret: boolean = false;
    if (deviceInfo.sdkApiVersion >= 22)
      ret = true;
    callback(ret);
  }

  @LogMethod
  async enumClientCerts(callback: Function) {
    const client_certs: OhosCertInfo[] = [];
    let activeContext = this.ctxAdapter.getActiveContext();
    if (!activeContext) {
      callback(client_certs, 0);
      return;
    }
    let certTypes: Array<certificateManagerDialog.CertificateType> = [
      certificateManagerDialog.CertificateType.CREDENTIAL_USER,
      certificateManagerDialog.CertificateType.CREDENTIAL_APP,
      certificateManagerDialog.CertificateType.CREDENTIAL_UKEY
    ];
    let certPurpose: certificateManager.CertificatePurpose = certificateManager.CertificatePurpose.PURPOSE_DEFAULT;
    let authorizeRequest: certificateManagerDialog.AuthorizeRequest = { certTypes: certTypes, certPurpose: certPurpose };
    try {
      certificateManagerDialog.openAuthorizeDialog(activeContext, authorizeRequest).then((certReference: certificateManagerDialog.CertReference) => {
        this.keyUri = certReference.keyUri;

        if (certReference.certType == certificateManagerDialog.CertificateType.CREDENTIAL_USER) {
          try {
            certificateManager.getPublicCertificate(this.keyUri).then((cmResult) => {
              if (cmResult?.credential == undefined) {
                console.info('The result of getting public certificate is undefined.');
              } else {
                const certInfo: OhosCertInfo = {
                  uri: certReference.keyUri,
                  cert: this.uint8ArrayToString(cmResult.credential.credentialData),
                  type: certificateManagerDialog.CertificateType.CREDENTIAL_USER
                };

                client_certs.push(certInfo);
                console.info('Succeeded in getting Public certificate.');
                
                callback(client_certs, client_certs.length);
              }
            }).catch((err: BusinessError) => {
              console.error(`Failed to get Public certificate. Code: ${err.code}, message: ${err.message}`);
            })
          } catch (error) {
            console.error(`Failed to get Public certificate. Code: ${error.code}, message: ${error.message}`);
          }
         
        } else if (certReference.certType == certificateManagerDialog.CertificateType.CREDENTIAL_UKEY) {
          let ukeyInfo: certificateManager.UkeyInfo = {
            certPurpose: certificateManager.CertificatePurpose.PURPOSE_DEFAULT,
          }

          certificateManager.getUkeyCertificate(this.keyUri, ukeyInfo).then((cmResult) => {
            if (!cmResult.credentialDetailList) {
              callback(client_certs, 0);
              return;
            }

            for (let i = 0; i < cmResult.credentialDetailList.length; i++) {
              const certInfo: OhosCertInfo = {
                uri: certReference.keyUri,
                cert: this.derToPem(cmResult.credentialDetailList[0].credentialData),
                type: certificateManagerDialog.CertificateType.CREDENTIAL_UKEY
              };

              client_certs.push(certInfo);
            }

            callback(client_certs, client_certs.length);
          }).catch((err: BusinessError) => {
            console.error(`Failed to get detail of USB key certificate. Code: ${err.code}, message: ${err.message}`);
          })
        } else if (certReference.certType == certificateManagerDialog.CertificateType.CREDENTIAL_APP) {
          try {
            certificateManager.getPrivateCertificate(this.keyUri, (err, cmResult) => {
              if (err != null) {
                console.error(`Failed to get private certificate. Code: ${err.code}, message: ${err.message}`);
              } else {
                if (cmResult?.credential == undefined) {
                  console.info('The result of getting private certificate is undefined.');
                } else {
                  let list = cmResult.credential;
                  console.info('Succeeded in getting private certificate.');
                  const certInfo: OhosCertInfo = {
                    uri: this.keyUri,
                    cert: this.uint8ArrayToString(cmResult.credential.credentialData),
                    type: certificateManagerDialog.CertificateType.CREDENTIAL_APP
                  };
                  client_certs.push(certInfo);
                  callback(client_certs, client_certs.length);
                }
              }
            });
          } catch (error) {
            console.error(`Failed to get private certificate. Code: ${error.code}, message: ${error.message}`);
          }

        }

      }).catch((err: BusinessError) => {
        console.error(`Failed to open authorize dialog . Code: ${err.code}, message: ${err.message}`);
        callback(client_certs, 0);
        return;
      });
    } catch (err) {
      let error = err as BusinessError;
      console.error(`Failed to open authorize dialog 2. Code: ${error.code}, message: ${error.message}`);
      callback(client_certs, 0);
      return;
    }
  }

  @LogMethod
  async signByHuks(uri: string, inputData: ArrayBuffer, callback: Function) {
    let handle: number = 0;
    const input: Uint8Array =  new Uint8Array(inputData);
    const buffer_return = new ArrayBuffer(0);
    let activeContext = this.ctxAdapter.getActiveContext();
    if (!activeContext) {
      callback(buffer_return);
      return;
    }

    let ukeyAuthRequest: certificateManagerDialog.UkeyAuthRequest = { keyUri: uri }
    try {
      await certificateManagerDialog.openUkeyAuthDialog(activeContext, ukeyAuthRequest).then(() => {
        console.info(`Success to open ukey authorization dialog`)
      }).catch((err: BusinessError) => {
        console.error(`Failed to open ukey authorization dialog. Code: ${err.code}, message: ${err.message}`);
      });
      let signProperties = this.getRsaSignProperties();
      let options: huks.HuksOptions = {
        properties: signProperties,
        inData: input
      }
      await huks.initSession(uri, options)
        .then((data) => {
          handle = data.handle;
        }).catch((err: Error) => {
          console.error(`promise: init sign failed, error: ` + JSON.stringify(err));
          throw (err as Error);
        })
      await huks.finishSession(handle, options)
        .then((data) => {
          console.info(`promise: sign success`);
          callback(data.outData || buffer_return);
        }).catch((err: Error) => {
          console.error(`promise: sign failed, error: ` + JSON.stringify(err));
          throw (err as Error);
        })


    } catch (err) {
      let error = err as BusinessError;
      console.error(`Failed to sign. Code: ${error.code}, message: ${error.message}`);
    }
  }
}

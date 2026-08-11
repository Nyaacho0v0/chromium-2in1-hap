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

import JsBindingUtils from '../utils/JsBindingUtils';
import Inject from '../common/InjectModule';
import lazy { ContextPathAdapter } from '../adapter/ContextPathAdapter';

function implContextPathAdapter(): ContextPathAdapter {
  return Inject.getOrCreate(ContextPathAdapter);
}

function getCacheDir(): string {
  return implContextPathAdapter().getCacheDir();
}

function getTempDir(): string {
  return implContextPathAdapter().getTempDir();
}

function getFilesDir(): string {
  return implContextPathAdapter().getFilesDir();
}

function getBundleDir(): string {
  return implContextPathAdapter().getBundleDir();
}

function getUserDocumentDir(): string {
  return implContextPathAdapter().getUserDocumentDir();
}

function getUserDesktopDir(): string {
  return implContextPathAdapter().getUserDesktopDir();
}

function getUserDownloadDir(): string {
  return implContextPathAdapter().getUserDownloadDir();
}

function getAppDownloadDir(callback: (downloadDirPath: string) => void): void{
  return implContextPathAdapter().getAppDownloadDir(callback);
}

export class ContextPathAdapterBind {
  static bind() {
    JsBindingUtils.bindFunction('ContextPathAdapter.GetCacheDir', getCacheDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetTempDir', getTempDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetFilesDir', getFilesDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetBundleDir', getBundleDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetUserDocumentDir', getUserDocumentDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetUserDesktopDir', getUserDesktopDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetUserDownloadDir', getUserDownloadDir);
    JsBindingUtils.bindFunction('ContextPathAdapter.GetAppDownloadDir', getAppDownloadDir);
  }
}

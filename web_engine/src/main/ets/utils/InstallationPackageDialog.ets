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


export enum MenuItem {
  kOpenAppGallery = 0,
  kContinueDownload = 1,
  kCancel = 2,
}

export class InstallationParams {
  fileName: string
  fileSize: string
  onResult: (index: MenuItem) => void

  constructor(fileName: string, fileSize: string, onResult: (index: MenuItem) => void) {
    this.fileName = fileName
    this.fileSize = fileSize
    this.onResult = onResult
  }
}

@Builder
export function InstallationDialogBuilder(params: InstallationParams) {

  Column({ space: 8 }) {
    Text($r('app.string.download'))
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))

    Column({ space: 8 }) {
      Row() {
        Text($r('app.string.file_name_str'))
          .width(50)
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))

        Marquee({
          start: true,
          step: 6,
          loop: 1,
          fromStart: true,
          src: params.fileName
        })
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .width(310)
      }

      Row() {
        Text($r('app.string.file_size_str'))
          .width(50)
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))

        Text(params.fileSize)
          .width(320)
          .fontSize(16)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .flexGrow(1)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('95%')

    Text($r('app.string.installation_not_supported'))
      .width('95%')
      .fontSize(12)
      .fontColor(Color.Red)
      .textAlign(TextAlign.Start)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .margin({ bottom: 10 })

    Column({ space: 8 }) {
      Button($r('app.string.go_to_app_gallery'))
        .width('97%')
        .onClick(() => params.onResult(MenuItem.kOpenAppGallery))
        .fontColor(Color.White)
      Button($r('app.string.still_download'))
        .width('97%')
        .onClick(() => params.onResult(MenuItem.kContinueDownload))
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .fontColor($r('sys.color.status_button_text_color_focus'))
      Button($r('app.string.dialog_cancel_button'))
        .width('97%')
        .onClick(() => params.onResult(MenuItem.kCancel))
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .fontColor($r('sys.color.status_button_text_color_focus'))
    }
  }
  .padding(10)
  .borderRadius(8)
  .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
  .width(400)
}

export const WrappedInstallationBuilder = wrapBuilder(InstallationDialogBuilder)

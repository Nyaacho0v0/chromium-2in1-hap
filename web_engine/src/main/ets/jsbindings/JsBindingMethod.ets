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

import { AccessibilityAdapterBind } from '../jsbindings/AccessibilityAdapterBind';
import { AppLifecycleAdapterBind } from './AppLifecycleAdapterBind';
import { AppWindowAdapterBind } from '../jsbindings/AppWindowAdapterBind';
import { BatteryAdapterBind } from '../jsbindings/BatteryAdapterBind';
import { BluetoothAdapterBind } from '../jsbindings/BluetoothAdapterBind';
import { BluetoothLowEnergyAdapterBind } from '../jsbindings/BluetoothLowEnergyAdapterBind';
import { BrowserPolicyAdapterBind } from '../jsbindings/BrowserPolicyAdapterBind';
import { CertManagerAdapterBind } from '../jsbindings/CertManagerAdapterBind';
import { ContextAdapterBind } from './ContextAdapterBind';
import { ContextPathAdapterBind } from '../jsbindings/ContextPathAdapterBind';
import { CursorAdapterBind } from '../jsbindings/CursorAdapterBind';
import { DefaultApplicationAdapterBind } from '../jsbindings/DefaultApplicationAdapterBind';
import { DeviceAdapterBind } from '../jsbindings/DeviceAdapterBind';
import { DeviceUserAuthAdapterBind } from '../jsbindings/DeviceUserAuthAdapterBind';
import { DisplayAdapterBind } from '../jsbindings/DisplayAdapterBind';
import { DragDropAdapterBind } from '../jsbindings/DragDropAdapterBind';
import { ExternalProtocolAdapterBind } from '../jsbindings/ExternalProtocolAdapterBind';
import { FileManagerAdapterBind } from '../jsbindings/FileManagerAdapterBind';
import { FilePickerAdapterBind } from '../jsbindings/FilePickerAdapterBind';
import { FontAdapterBind } from '../jsbindings/FontAdapterBind';
import { GeolocationAdapterBind } from '../jsbindings/GeolocationAdapterBind';
import { I18nAdapterBind } from '../jsbindings/I18nAdapterBind';
import { IMFAdapterBind } from '../jsbindings/IMFAdapterBind';
import { MediaAdapterBind } from '../jsbindings/MediaAdapterBind';
import { MimeTypeAdapterBind } from '../jsbindings/MimeTypeAdapterBind';
import { NativeMessagingAdapterBind } from '../jsbindings/NativeMessagingAdapterBind';
import { NativeThemeAdapterBind } from '../jsbindings/NativeThemeAdapterBind';
import { NetConnectionAdapterBind } from '../jsbindings/NetConnectionAdapterBind';
import { NotificationAdapterBind } from '../jsbindings/NotificationAdapterBind';
import { OcrAdapterBind } from '../jsbindings/OcrAdapterBind';
import { PermissionManagerAdapterBind } from '../jsbindings/PermissionManagerAdapterBind';
import { PowerMonitorAdapterBind } from '../jsbindings/PowerMonitorAdapterBind';
import { PrintAdapterBind } from '../jsbindings/PrintAdapterBind';
import { ProcessAdapterBind } from '../jsbindings/ProcessAdapterBind';
import { RunningLockAdapterBind } from '../jsbindings/RunningLockAdapterBind';
import { ScreenlockMonitorAdapterBind } from '../jsbindings/ScreenlockMonitorAdapterBind';
import { ShapeDetectionAdapterBind } from '../jsbindings/ShapeDetectionAdapterBind';
import { SpeechAdapterBind } from '../jsbindings/SpeechAdapterBind';
import { SubWindowAdapterBind } from '../jsbindings/SubWindowAdapterBind';
import { SystemFloatingWindowAdapterBind } from './SystemFloatingWindowAdapterBind';
import { WebAppAdapterBind } from './WebAppAdapterBind';

export class JsBindingMethod {
  static bind() {
    AccessibilityAdapterBind.bind();
    AppLifecycleAdapterBind.bind();
    AppWindowAdapterBind.bind();
    BatteryAdapterBind.bind();
    BluetoothAdapterBind.bind();
    BluetoothLowEnergyAdapterBind.bind();
    BrowserPolicyAdapterBind.bind();
    CertManagerAdapterBind.bind();
    ContextAdapterBind.bind();
    ContextPathAdapterBind.bind();
    CursorAdapterBind.bind();
    DefaultApplicationAdapterBind.bind();
    DeviceAdapterBind.bind();
    DeviceUserAuthAdapterBind.bind();
    DisplayAdapterBind.bind();
    DragDropAdapterBind.bind();
    ExternalProtocolAdapterBind.bind();
    FileManagerAdapterBind.bind();
    FilePickerAdapterBind.bind();
    FontAdapterBind.bind();
    GeolocationAdapterBind.bind();
    I18nAdapterBind.bind();
    IMFAdapterBind.bind();
    MediaAdapterBind.bind();
    MimeTypeAdapterBind.bind();
    NativeMessagingAdapterBind.bind();
    NativeThemeAdapterBind.bind();
    NetConnectionAdapterBind.bind();
    NotificationAdapterBind.bind();
    OcrAdapterBind.bind();
    PermissionManagerAdapterBind.bind();
    PowerMonitorAdapterBind.bind();
    PrintAdapterBind.bind();
    ProcessAdapterBind.bind();
    RunningLockAdapterBind.bind();
    ScreenlockMonitorAdapterBind.bind();
    ShapeDetectionAdapterBind.bind();
    SpeechAdapterBind.bind();
    SubWindowAdapterBind.bind();
    SystemFloatingWindowAdapterBind.bind();
    WebAppAdapterBind.bind();
  }
}

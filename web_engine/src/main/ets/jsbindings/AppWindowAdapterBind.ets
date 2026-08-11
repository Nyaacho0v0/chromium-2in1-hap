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
import lazy { AppWindowAdapter } from '../adapter/AppWindowAdapter';
import type { NewWindowParam, PointCoordinate, WindowBound } from '../interface/CommonInterface';
import { NodeContent } from '@kit.ArkUI';

function implAppWindowAdapter(): AppWindowAdapter {
  return Inject.getOrCreate(AppWindowAdapter);
}

function createWindow(param: NewWindowParam) {
  implAppWindowAdapter().createWindow(param);
}

function closeWindow(id: number) {
  implAppWindowAdapter().closeWindow(id);
}

function showWindow(id: number) {
  implAppWindowAdapter().showWindow(id);
}

function activateWindow(id: number) {
  implAppWindowAdapter().activateWindow(id);
}

function setFullscreen(id: number) {
  implAppWindowAdapter().setFullscreen(id);
}

function setBounds(id: number, bounds: WindowBound) {
  implAppWindowAdapter().setBounds(id, bounds);
}

function setEnabled(enable: boolean, id: number) {
  implAppWindowAdapter().setEnabled(enable, id);
}

function setWindowLimits(minWidth: number,
                         minHeight: number,
                         maxWidth: number,
                         maxHeight: number,
                         id: number) {
  implAppWindowAdapter().setWindowLimits(minWidth, minHeight, maxWidth, maxHeight, id);
}

function maximize(id: number) {
  implAppWindowAdapter().maximize(id);
}

function unMaximize(id: number) {
  implAppWindowAdapter().unMaximize(id);
}

function minimize(id: number) {
  implAppWindowAdapter().minimize(id);
}

function setTitle(title:string, id: number) {
  implAppWindowAdapter().setTitle(title, id);
}

function relaunch() : boolean {
  return implAppWindowAdapter().relaunch();
}

function startWindowMoving(id: number) {
  implAppWindowAdapter().startWindowMoving(id);
}

function getWindowsByCoordinate(coordinate: PointCoordinate,
                                callback: (windowIds: Array<string>) => void) {
  implAppWindowAdapter().getWindowsByCoordinate(coordinate, callback);
}

function restore(id: number) {
  implAppWindowAdapter().restore(id);
}

function shiftWindowMouseEvent(sourceId: number, targetId: number,
                          callback: (result: boolean) => void) {
  implAppWindowAdapter().shiftWindowMouseEvent(sourceId, targetId, callback);
}

function startWindowMovingWithOffset(id: number, offsetX: number, offsetY: number) {
  implAppWindowAdapter().startWindowMovingWithOffset(id, offsetX, offsetY);
}

function getOriginWindowIds(windowIds: Array<number>): Array<number> {
  return implAppWindowAdapter().getOriginWindowIds(windowIds);
}

function shiftWindowTouchEvent(sourceId: number, targetId: number,
  fingerId: number, callback: (result: boolean) => void) {
  implAppWindowAdapter().shiftWindowTouchEvent(sourceId, targetId, fingerId, callback);
}

function bind(id: string, callback: (nodeContent: NodeContent | undefined) => void) {
  implAppWindowAdapter().bind(id, callback);
}

function unbind(id: string, callback: (nodeContent: NodeContent | undefined) => void) {
  implAppWindowAdapter().unbind(id, callback);
}

export class AppWindowAdapterBind {
  static bind() {
    JsBindingUtils.bindFunction("AppWindow.CreateWindow", createWindow);
    JsBindingUtils.bindFunction("AppWindow.CloseWindow", closeWindow);
    JsBindingUtils.bindFunction("AppWindow.SetFullscreen", setFullscreen);
    JsBindingUtils.bindFunction("AppWindow.SetBounds", setBounds);
    JsBindingUtils.bindFunction("AppWindow.SetEnabled", setEnabled);
    JsBindingUtils.bindFunction("AppWindow.SetWindowLimits", setWindowLimits);
    JsBindingUtils.bindFunction("AppWindow.Maximize", maximize);
    JsBindingUtils.bindFunction("AppWindow.UnMaximize", unMaximize);
    JsBindingUtils.bindFunction("AppWindow.Minimize", minimize);
    JsBindingUtils.bindFunction("AppWindow.SetTitle", setTitle);
    JsBindingUtils.bindFunction("AppWindow.ShowWindow", showWindow);
    JsBindingUtils.bindFunction("AppWindow.ActivateWindow", activateWindow);
    JsBindingUtils.bindFunction("AppWindow.Relaunch", relaunch);
    JsBindingUtils.bindFunction("AppWindow.StartWindowMoving", startWindowMoving);
    JsBindingUtils.bindFunction("AppWindow.GetWindowsByCoordinate", getWindowsByCoordinate);
    JsBindingUtils.bindFunction("AppWindow.Restore", restore);
    JsBindingUtils.bindFunction("AppWindow.ShiftWindowMouseEvent", shiftWindowMouseEvent);
    JsBindingUtils.bindFunction("AppWindow.StartWindowMovingWithOffset", startWindowMovingWithOffset);
    JsBindingUtils.bindFunction("AppWindow.GetOriginWindowIds", getOriginWindowIds);
    JsBindingUtils.bindFunction("AppWindow.ShiftWindowTouchEvent", shiftWindowTouchEvent);
    JsBindingUtils.bindFunction("AppWindow.Bind", bind);
    JsBindingUtils.bindFunction("AppWindow.UnBind", unbind);
  }
}

# Chromium 2in1 HAP

将 OpenHarmony Chromium `pc_chromium_132` 分支打包为 **HarmonyOS 6.1.1（API 24）** Stage 模型的 HAP，适配 **2in1 / 平板** 设备。

## 特性

- Chromium 132 内核（`pc_chromium_132` 分支）
- 桌面版 User-Agent，桌面模式网页体验
- 支持 Google 账号登录与同步（需要自备 OAuth client id / 代理环境）
- 高刷新率（支持 90Hz / 120Hz / 144Hz 平板，跟随系统显示刷新率）
- HDR 播放：10bit EGL 输出、PQ 亮度映射、HDR 色彩空间切换
- 沉浸式状态栏，可隐藏系统状态栏
- 视频硬解（OHOS 视频解码器，失败时回退软件解码）

## 目录结构

```text
AppScope/                 # 应用级配置
chromium/                 # HAP 主模块（ArkTS 壳 + 原生运行时）
web_engine/               # Web 引擎封装模块
scripts/                  # Chromium runtime 准备脚本
```

## 构建 Chromium

Chromium 本体需要在独立的 manifest 工作区中构建（不要在 HAP 目录下执行）：

```sh
mkdir -p /path/to/chromium_workspace
cd /path/to/chromium_workspace
repo init -u https://gitcode.com/openharmony-tpc/manifest.git \
  -b pc_chromium_132 -m chromium.xml --no-repo-verify
repo sync -c
repo forall -c 'git lfs pull'
./build.sh -t chrome_main_web
```

构建产物位于 `src/out/musl_64/`。macOS 无法提供上游要求的完整 Linux 工具链，请按上游文档在 Linux 构建环境执行。

## 准备 HAP 运行时

```sh
./scripts/prepare_chromium_runtime.sh /path/to/chromium_workspace
```

参数可以是 manifest 工作区根目录（包含 `src/`）或 Chromium 源码根目录。脚本会校验并拷贝原生库与运行资源，不会提交生成物。

## 在 DevEco Studio 中构建

- DevEco Studio 6.1.1 Release（HarmonyOS SDK 6.1.1 / API 24）
- 打开本目录作为 HarmonyOS 工程，配置自己的签名（仓库不包含签名配置）
- 构建默认 HAP：`build/default/outputs/default/`

> 注意：`AppScope/app.json5` 中的 bundle name 为示例值 `com.example.ohos.chromium2in1`，发布前请替换为自有 bundle name 并使用生产签名。

## 安装与启动

```sh
hdc install chromium-default-signed.hap
hdc shell aa start -a EntryAbility -b com.example.ohos.chromium2in1
```

## 说明

- 本仓库只包含工程源码与构建脚本，不包含 Chromium 二进制、签名文件、维护记录等本地敏感信息。
- Release 发布为 unsigned HAP，请自行签名后安装。
- 原生库为 arm64 架构，适配 HarmonyOS 2in1 设备。

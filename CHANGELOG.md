# 更新日志

## [1.1.0-red198f] - 2026-06-08

基于 upstream [v1.1.0](https://github.com/Achilng/floral-notepaper/releases) 的 fork 改动。

### 新增

- 快捷便签小窗「打开」标签页支持搜索已创建的笔记（按标题、预览、文件名匹配）
- Linux 安装包适配：完善 deb/rpm 运行时依赖，并提供 Arch Linux `PKGBUILD`
- 新增 `scripts/build-linux.sh` 与 `scripts/build-windows.ps1` 构建脚本

### 说明

- 搜索功能复用主窗口已有的 `filterNotes` 逻辑，以独立组件 `NotepadOpenPanel` 实现，尽量不改动原有模块
- Linux 打包验证：`scripts/verify-linux-packages.sh` 对 deb（`dpkg-deb -I`）与 rpm（`rpm -qip`）做元数据检查

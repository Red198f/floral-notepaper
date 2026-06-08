# 花笺 Floral Notepaper（Red198f 版）

> 本仓库 fork 自 [floral-notepaper](https://github.com/Achilng/floral-notepaper) ，感谢原作者 [Achilng](https://github.com/Achilng)。

轻量、优雅、现代化的本地便签工具，基于 Tauri 2 + React 构建。当前基于 upstream **v1.1.0**。

## 主要改动

详细改动见 [CHANGELOG.md](CHANGELOG.md)。

- **快捷便签搜索**：`Ctrl+Space` 呼出小窗后，在「打开」标签页可按标题、内容预览或文件名搜索已有笔记
- **Linux 打包**：提供 deb、rpm 安装包构建，以及 Arch Linux `PKGBUILD`

## 与原版的差异

| 项目             | 原版 (v1.1.0)                    | 本 fork                                                    |
| ---------------- | -------------------------------- | ---------------------------------------------------------- |
| 小窗「打开」笔记 | 仅列表浏览                       | 列表 + 搜索过滤                                            |
| Linux 依赖声明   | deb 无运行时依赖                 | deb/rpm 声明 WebKitGTK 等依赖                              |
| Arch 支持        | 无                               | 提供 `packaging/arch/PKGBUILD`                             |
| 构建脚本         | 需手动执行 `npm run tauri build` | 提供 `scripts/build-windows.ps1`、`scripts/build-linux.sh` |

其余功能（Markdown 编辑、图片粘贴、自动更新、磁贴模式、导入导出、全局快捷键等）与 upstream v1.1.0 保持一致。

## 安装与使用

### 下载安装包

前往 [GitHub Releases](https://github.com/Red198f/floral-notepaper/releases) 下载对应平台的安装包：

- **Windows**：`floral-notepaper_<version>_x64-setup.exe`（安装版）或 `floral-notepaper_<version>.exe`（便携版）
- **Linux (deb)**：Debian / Ubuntu 等
- **Linux (rpm)**：Fedora / openSUSE 等
- **Arch Linux**：使用 `packaging/arch/PKGBUILD` 构建，详见 [packaging/linux/README.md](packaging/linux/README.md)

### 从源码构建

#### 环境要求

- [Node.js](https://nodejs.org/) 20.19+ 或 22.12+
- [Rust](https://www.rust-lang.org/tools/install)
- [Tauri CLI 2](https://tauri.app/)

Linux 额外依赖见 [packaging/linux/README.md](packaging/linux/README.md) 或 [CONTRIBUTING.md](CONTRIBUTING.md)。

#### Windows

```powershell
git clone https://github.com/Red198f/floral-notepaper.git
cd floral-notepaper
npm install
npm run tauri dev          # 开发模式
.\scripts\build-windows.ps1 # 构建发布版
```

#### Linux / WSL

```bash
git clone https://github.com/Red198f/floral-notepaper.git
cd floral-notepaper
chmod +x scripts/build-linux.sh
./scripts/build-linux.sh
```

构建产物：

- Windows：`release-assets/windows/`
- Linux：`release-assets/linux/`

构建后可验证 deb/rpm 元数据（WSL/Ubuntu 可用 `rpm -qip` 检查 rpm，无需 Fedora）：

```bash
chmod +x scripts/verify-linux-packages.sh
./scripts/verify-linux-packages.sh
```

详见 [packaging/linux/README.md](packaging/linux/README.md)。

### 使用说明

1. 启动应用后，可通过系统托盘或全局快捷键（默认 **Ctrl+Space**）呼出快捷便签小窗
2. 在小窗中点击「打开」，使用顶部搜索框过滤已有笔记，点击条目即可打开
3. 主窗口提供完整的 Markdown 编辑、分类、磁贴与导入导出功能

## 许可证

[MIT](LICENSE)

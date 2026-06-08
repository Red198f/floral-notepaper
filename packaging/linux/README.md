# Linux 安装包说明

本 fork 在 Linux 上提供以下安装格式：

| 格式            | 适用发行版                      | 构建产物                                  |
| --------------- | ------------------------------- | ----------------------------------------- |
| `.deb`          | Debian / Ubuntu / Linux Mint 等 | `floral-notepaper_<version>_amd64.deb`    |
| `.rpm`          | Fedora / openSUSE / RHEL 等     | `floral-notepaper-<version>-1.x86_64.rpm` |
| Arch (PKGBUILD) | Arch Linux / Manjaro 等         | 见 `packaging/arch/PKGBUILD`              |

## 从源码构建 Linux 包

在 Linux 或 WSL 中执行：

```bash
chmod +x scripts/build-linux.sh
./scripts/build-linux.sh
```

产物输出到 `release-assets/linux/`。

## 安装

### Debian / Ubuntu

```bash
sudo dpkg -i release-assets/linux/floral-notepaper_*_amd64.deb
sudo apt-get install -f
```

### Fedora / RHEL

```bash
sudo dnf install release-assets/linux/floral-notepaper-*.rpm
```

### Arch Linux

```bash
cd packaging/arch
makepkg -si
```

或手动编辑 `PKGBUILD` 中的 `pkgver` / `source` 后执行 `makepkg -si`。

## 运行时依赖

- GTK 3
- WebKitGTK 4.1
- Ayatana AppIndicator
- librsvg

全局快捷键（默认 `Ctrl+Space`）在 X11 下需要 `libxdo`；Wayland 下行为取决于桌面环境。

## 构建后验证（deb + rpm）

在 Debian/Ubuntu/WSL 上可用 `rpm` 命令读取 `.rpm` 元数据，无需 Fedora 环境：

```bash
chmod +x scripts/verify-linux-packages.sh
./scripts/verify-linux-packages.sh
```

脚本会：

- 对 `.deb` 执行 `dpkg-deb -I`（检查版本、架构、运行时依赖）
- 若系统未安装 `rpm`，在 Ubuntu/WSL 上自动 `apt install rpm`
- 对 `.rpm` 执行 `rpm -qip`（检查 Name、Version、Requires 等）

完整 Linux 测试（含单元测试、编译、打包与上述验证）：

```bash
chmod +x scripts/test-linux.sh
./scripts/test-linux.sh
```

说明：上述验证检查**安装包元数据**，不等同于在 Fedora 上 `dnf install` 后的 GUI 安装测试；裸二进制冒烟测试见 `scripts/test-linux.sh` 末尾。

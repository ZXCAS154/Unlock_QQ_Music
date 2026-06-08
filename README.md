# Unlock Music — QQ音乐加密歌曲解锁

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](#)

解密 QQ 音乐加密歌曲，自动获取歌曲信息，统一转为 MP3 格式。支持 QQ 音乐新版 **EncV2** 加密格式。

## 功能特性

- **多格式解密** — 支持 `.mgg` `.mflac` `.qmcflac` `.mmp4` 等全部 QQ 音乐加密格式
- **自动获取歌曲信息** — 通过 QQ 音乐 API 获取歌名、歌手、专辑名称
- **专辑封面嵌入** — 自动下载专辑封面并嵌入 MP3 文件
- **批量处理** — 一次性处理目录下所有加密歌曲
- **一键启动** — 无需 Node.js 运行环境，双击即用
- **三级信息获取策略** — songID 直查 → 文件名搜索 → FFmpeg 提取

## 快速开始

1. 将 `unlock.exe`、`ffmpeg.exe` 放入加密歌曲所在目录
2. 双击 `!一键解锁.bat`
3. 选择 **[1] 一键解锁**，等待处理完成
4. 解密后的歌曲在 `decrypted` 目录

> **提示：** 也可以直接拖拽文件/文件夹到 `unlock.exe` 上。

## 菜单说明

| 选项 | 功能 |
|------|------|
| **[1] 一键解锁** | 解密 + MP3 320kbps + 获取歌曲信息 + 嵌入专辑封面 |
| **[2] 仅解密** | 只解密，保留原始格式 (ogg/flac/m4a)，获取歌曲信息 |
| **[3] 自定义** | 指定码率、跳过歌曲信息/封面等 |
| **[4] 帮助** | 查看命令行选项 |
| **[0] 退出** | 退出程序 |

## 支持的加密格式

| 格式 | 解密后 | 说明 |
|------|--------|------|
| `.mgg` `.mgg1` `.mggl` | OGG | QQ 音乐新版 OGG 加密 |
| `.mflac` `.mflac0` `.mflach` | FLAC | QQ 音乐 FLAC 加密 |
| `.qmcflac` | FLAC | 旧版 QMC FLAC 加密 |
| `.qmcogg` | OGG | 旧版 QMC OGG 加密 |
| `.qmc0` `.qmc3` | MP3 | 旧版 QMC MP3 加密 |
| `.mmp4` | M4A | QQ 音乐 M4A 加密 |

## 命令行用法

```bash
# 处理当前目录
unlock.exe

# 处理指定目录
unlock.exe --input D:\songs

# 只解密不转 MP3
unlock.exe --no-mp3

# 自定义 MP3 码率 (默认 320)
unlock.exe --bitrate 192

# 跳过歌曲信息
unlock.exe --no-meta

# 跳过专辑封面
unlock.exe --no-cover

# 指定输出目录
unlock.exe --output D:\output
```

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `--input DIR` | 加密歌曲所在目录 | 当前目录 |
| `--output DIR` | 输出目录 | `./decrypted` |
| `--bitrate N` | MP3 码率 (kbps) | `320` |
| `--no-mp3` | 只解密，不转 MP3 | 关闭 |
| `--no-meta` | 跳过获取歌曲信息 | 关闭 |
| `--no-cover` | 跳过下载专辑封面 | 关闭 |
| `--help` `-h` | 查看帮助 | — |

## 文件说明

```
├── unlock.exe              # 主程序 (Node.js SEA 打包)
├── ffmpeg.exe              # 音频转码工具
├── !一键解锁.bat            # 一键启动脚本 (推荐)
├── !一键解锁.ps1            # PowerShell 启动脚本
│── QQ音乐 V19.51.exe       # QQ 音乐客户端安装包 (旧版本)
├── 使用说明.md / .txt       # 使用说明
├── 技术说明.md              # 完整技术文档
│── README.md               # 本文件
```

## 歌曲信息获取策略

程序内置三级获取策略，确保尽可能匹配到正确的歌曲信息：

1. **songID 直查** — 从 QTag 格式文件中提取 songID，直接调用 QQ 音乐 API 获取完整信息
2. **文件名 + 搜索** — 从文件名解析 `歌手 - 歌名`，搜索 QQ 音乐 API 匹配
3. **FFmpeg 提取** — 从解密后的音频文件中提取内嵌元数据

> 歌曲信息和专辑封面会自动嵌入到输出的 MP3 文件中，需要网络连接。

## 常见问题

**Q: 处理报错 "Android 新版本暂不支持"？**

请降级 QQ 音乐客户端到旧版本（可使用仓库中的 `QQ音乐 V19.51.exe`），重新下载加密歌曲。

**Q: 歌曲信息/封面没有获取到？**

检查网络连接是否正常。如果文件名不规范（非 `歌手 - 歌名` 格式），可能导致匹配失败。

**Q: 运行后立即闪退？**

将 `unlock.exe` 和加密歌曲放同一目录，双击 `!一键解锁.bat` 启动。不要直接双击 `unlock.exe`。

**Q: 解密后其他播放器不能播放？**

解密后的文件不加密，主流播放器都能播放。OGG 格式推荐用 PotPlayer / VLC。

**Q: 转码后 MP3 没有封面？**

确保 `ffmpeg.exe` 在同目录，且有网络连接以下载封面。

## 注意事项

- 输出目录为 `decrypted`（自动创建）
- `ffmpeg.exe` 需与 `unlock.exe` 在同一目录才能自动转 MP3
- 如不转 MP3，解密后保留原始格式（ogg / flac / m4a / mp3）
- 仅供个人学习研究使用，请尊重版权

## 技术栈

- **运行时:** Node.js → SEA 单可执行文件打包
- **加密算法:** TEA + CBC 自定义模式、QMC、EncV2
- **音频处理:** FFmpeg 转码 + ID3v2.3 标签写入
- **API 对接:** QQ 音乐开放 API (songID 直查 + 关键词搜索)
- **脚本:** Windows Batch + PowerShell

详见 [技术说明.md](./技术说明.md)

## License

MIT — 仅供学习研究使用，请尊重版权。

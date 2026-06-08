<#
.SYNOPSIS
  Unlock Music — QQ音乐加密歌曲解锁
#>

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exe = Join-Path $scriptDir 'unlock.exe'

if (-not (Test-Path $exe)) {
    Write-Host '[!] unlock.exe 未找到' -ForegroundColor Red
    Pause; exit 1
}

function ShowMenu {
    Clear-Host
    Write-Host ''
    Write-Host '  Unlock Music — QQ音乐加密歌曲解锁' -ForegroundColor Magenta
    Write-Host '  ' -NoNewline
    Write-Host ('━' * 46) -ForegroundColor DarkGray
    Write-Host ''
    Write-Host '  请选择操作：' -ForegroundColor White
    Write-Host ''
    Write-Host '    [1]  ' -NoNewline -ForegroundColor Green
    Write-Host '一键解锁  ' -NoNewline -ForegroundColor White
    Write-Host '—  解密 + MP3 320k + 歌曲信息 + 专辑封面' -ForegroundColor DarkGray
    Write-Host '    [2]  ' -NoNewline -ForegroundColor Green
    Write-Host '仅解密    ' -NoNewline -ForegroundColor White
    Write-Host '—  保留原始格式，获取歌曲信息' -ForegroundColor DarkGray
    Write-Host '    [3]  ' -NoNewline -ForegroundColor Green
    Write-Host '自定义    ' -NoNewline -ForegroundColor White
    Write-Host '—  指定码率、跳过信息/封面等' -ForegroundColor DarkGray
    Write-Host '    [4]  ' -NoNewline -ForegroundColor Green
    Write-Host '帮助' -ForegroundColor White
    Write-Host '    [0]  ' -NoNewline -ForegroundColor DarkGray
    Write-Host '退出' -ForegroundColor DarkGray
    Write-Host ''
    Write-Host '  ' -NoNewline
    Write-Host ('━' * 46) -ForegroundColor DarkGray
    Write-Host ''
}

do {
    ShowMenu
    $choice = Read-Host '  请输入选项 [1]'
    if ([string]::IsNullOrEmpty($choice)) { $choice = '1' }

    $customOpts = @()
    $done = $false

    switch ($choice) {
        '1' {
            Clear-Host
            Write-Host ''
            Write-Host '  一键解锁模式' -ForegroundColor White
            Write-Host '  解密 + MP3 320kbps + 获取歌曲信息 + 嵌入专辑封面' -ForegroundColor DarkGray
            Write-Host ''
            & $exe --input "$scriptDir\..\" --output "$scriptDir\..\decrypted"
            $done = $true
        }
        '2' {
            Clear-Host
            Write-Host ''
            Write-Host '  仅解密模式 (保留原始格式)' -ForegroundColor White
            Write-Host '  解密 + 获取歌曲信息 (不转 MP3, 不下载封面)' -ForegroundColor DarkGray
            Write-Host ''
            & $exe --input "$scriptDir\..\" --output "$scriptDir\..\decrypted" --no-mp3 --no-cover
            $done = $true
        }
        '3' {
            Clear-Host
            Write-Host ''
            Write-Host '  MP3 码率选择：' -ForegroundColor White
            Write-Host ''
            Write-Host '    [1]  320kbps  (高品质, 推荐)' -ForegroundColor Yellow
            Write-Host '    [2]  256kbps' -ForegroundColor DarkGray
            Write-Host '    [3]  192kbps' -ForegroundColor DarkGray
            Write-Host '    [4]  128kbps' -ForegroundColor DarkGray
            Write-Host '    [0]  不转 MP3' -ForegroundColor DarkGray
            Write-Host ''
            $br = Read-Host '  请选择 [1]'
            switch ($br) {
                '' { $customOpts = @('--bitrate', '320') }
                '1' { $customOpts = @('--bitrate', '320') }
                '2' { $customOpts = @('--bitrate', '256') }
                '3' { $customOpts = @('--bitrate', '192') }
                '4' { $customOpts = @('--bitrate', '128') }
                '0' { $customOpts = @('--no-mp3') }
                default { $customOpts = @('--bitrate', '320') }
            }

            Clear-Host
            Write-Host ''
            Write-Host '  附加选项：' -ForegroundColor White
            Write-Host ''
            Write-Host '    [1]  获取歌曲信息 + 下载专辑封面 (默认)' -ForegroundColor Yellow
            Write-Host '    [2]  获取歌曲信息，不下载封面' -ForegroundColor DarkGray
            Write-Host '    [3]  跳过歌曲信息，不下载封面' -ForegroundColor DarkGray
            Write-Host ''
            $ex = Read-Host '  请选择 [1]'
            switch ($ex) {
                '2' { $customOpts += '--no-cover' }
                '3' { $customOpts += @('--no-meta', '--no-cover') }
            }

            Clear-Host
            Write-Host ''
            Write-Host "  自定义模式  $customOpts" -ForegroundColor White
            Write-Host ''
            & $exe --input "$scriptDir\..\" --output "$scriptDir\..\decrypted" @customOpts
            $done = $true
        }
        '4' {
            Clear-Host
            & $exe --help
            Write-Host ''
            Pause
        }
        '0' { exit 0 }
    }

    if ($done) {
        Write-Host ''
        Write-Host '  处理完成' -ForegroundColor Green
        Write-Host '  输出目录：decrypted' -ForegroundColor DarkGray
        Write-Host ''
        Pause
        break
    }
} while ($true)

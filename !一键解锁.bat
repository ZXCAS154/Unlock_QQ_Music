@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ── VT100 颜色 ──
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "X=%ESC%[0m"
set "B=%ESC%[1m"
set "D=%ESC%[2m"
set "R=%ESC%[91m"
set "G=%ESC%[92m"
set "Y=%ESC%[93m"
set "C=%ESC%[96m"
set "M=%ESC%[95m"
set "W=%ESC%[97m"

set "SD=%~dp0"
set "JSFILE=%SD%unlock.js"

if not exist "%JSFILE%" (
    echo %R%[!] unlock.js 未找到%X%
    pause >nul
    exit /b 1
)

:Menu
cls
echo.
echo  %B%%M%  Unlock Music — QQ音乐加密歌曲解锁%X%
echo  %D%%C%  ──────────────────────────────────────────%X%
echo.
echo  %B%  请选择操作：%X%
echo.
echo     %G%[1]%X%  %B%一键解锁%X%  —  解密 + MP3 320k + 歌曲信息 + 专辑封面
echo     %G%[2]%X%  仅解密     —  只解密，保留原始格式，获取歌曲信息
echo     %G%[3]%X%  自定义     —  指定码率、跳过信息/封面等
echo     %G%[4]%X%  帮助
echo     %G%[0]%X%  退出
echo.
echo  %D%%C%  ──────────────────────────────────────────%X%
echo.
set /p "ch=  请输入选项 %B%[1]%X%: "

if "%ch%"=="" goto QuickRun
if "%ch%"=="1" goto QuickRun
if "%ch%"=="2" goto DecOnly
if "%ch%"=="3" goto Custom
if "%ch%"=="4" goto Help
if "%ch%"=="0" exit /b 0
goto Menu

:QuickRun
cls
echo.
echo  %B%  一键解锁模式%X%
echo  %D%  解密 + MP3 320kbps + 获取歌曲信息 + 嵌入专辑封面%X%
echo.
node "%JSFILE%" --input "%SD%..\\" --output "%SD%..\\decrypted"
goto Done

:DecOnly
cls
echo.
echo  %B%  仅解密模式 (保留原始格式)%X%
echo  %D%  解密 + 获取歌曲信息 (不转 MP3, 不下载封面)%X%
echo.
node "%JSFILE%" --input "%SD%..\\" --output "%SD%..\\decrypted" --no-mp3 --no-cover
goto Done

:Custom
cls
echo.
echo  %B%  MP3 码率选择：%X%
echo.
echo     %G%[1]%X% 320kbps (高品质, 推荐)
echo     %G%[2]%X% 256kbps
echo     %G%[3]%X% 192kbps
echo     %G%[4]%X% 128kbps
echo     %G%[0]%X% 不转 MP3
echo.
set /p "br=  请选择 %B%[1]%X%: "
if "%br%"=="" set "br=1"
set "OPTS=--bitrate 320"
if "%br%"=="2" set "OPTS=--bitrate 256"
if "%br%"=="3" set "OPTS=--bitrate 192"
if "%br%"=="4" set "OPTS=--bitrate 128"
if "%br%"=="0" set "OPTS=--no-mp3"

cls
echo.
echo  %B%  附加选项：%X%
echo.
echo     %G%[1]%X% 获取歌曲信息 + 下载专辑封面 (默认)
echo     %G%[2]%X% 获取歌曲信息, 不下载封面
echo     %G%[3]%X% 跳过歌曲信息, 不下载封面
echo.
set /p "ex=  请选择 %B%[1]%X%: "
if "%ex%"=="" set "ex=1"
if "%ex%"=="2" set "OPTS=%OPTS% --no-cover"
if "%ex%"=="3" set "OPTS=%OPTS% --no-meta --no-cover"

cls
echo.
echo  %B%  自定义模式  %OPTS%%X%
echo.
node "%JSFILE%" --input "%SD%..\\" --output "%SD%..\\decrypted" %OPTS%
goto Done

:Help
cls
node "%JSFILE%" --help
echo.
pause
goto Menu

:Done
echo.
echo  %G%%B%  处理完成%X%
echo  %D%  输出目录：decrypted%X%
echo.
pause >nul
exit /b 0

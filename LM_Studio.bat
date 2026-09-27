@echo off
chcp 65001 >nul
title 本地大模型服务器 (请勿关闭此窗口)

echo =======================================================
echo             正在启动 LM Studio (Bionic) 并配置服务器
echo =======================================================
echo.

:: 1. 检查并启动 Bionic.exe
set "LM_PATH=C:\Users\Administrator\AppData\Local\Programs\Bionic\Bionic.exe"
echo [1/5] 正在检查 Bionic.exe 路径...
if not exist "%LM_PATH%" (
    echo ❌ 错误：没有找到 Bionic.exe！请确认路径是否正确。
    echo 当前查找的路径是：%LM_PATH%
    echo.
    pause
    exit
)
echo ✅ 找到 Bionic.exe
echo 正在打开 LM Studio...
start "" "%LM_PATH%"
echo.

:: 2. 等待 UI 初始化
echo [2/5] 等待 LM Studio 初始化 10 秒...
timeout /t 10 /nobreak >nul
echo.

:: 3. 检查 lms 命令是否存在
echo [3/5] 正在检查 lms 命令...
where lms >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误：找不到 lms 命令！环境变量可能失效了。
    echo.
    pause
    exit
)
echo ✅ lms 命令可用
echo.

:: 4. 启动服务器
echo [4/5] 正在开启局域网服务器 (端口: 9876)...
call lms server stop >nul 2>&1
call lms server start --port 9876 --bind 0.0.0.0 --cors
echo.

:: 5. 自动加载模型！
echo [5/5] 正在为你加载模型 qwen2.5-7b-instruct ...
:: 先把其他模型卸载，确保显存干净
call lms unload --all >nul 2>&1
:: 加载我们的模型，限制上下文长度为 4096，gpu 拉满，闲置 1 小时后自动卸载
call lms load qwen2.5-7b-instruct --gpu max --context-length 4096 --ttl 3600

echo.
echo =======================================================
echo 🎉 部署完成！手机 RikkaHub 现在可以连接了！
echo ⚠️ 警告：不要关闭这个黑色窗口，否则手机将断开连接！
echo =======================================================
echo.
pause
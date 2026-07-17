@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ==============================================
echo   博雅高科 - 本机一键构建并上传 (HighTechChina)
echo ==============================================
echo.

REM 选择 Hugo：优先用本机随附的 tools/hugo/hugo.exe
set "HUGO="
if exist "tools\hugo\hugo.exe" (
  set "HUGO=tools\hugo\hugo.exe"
) else (
  set "HUGO=hugo"
)
echo 使用 Hugo: %HUGO%
echo.

echo [1/5] 本地构建（校验内容是否有误）...
"%HUGO%" --cleanDestinationDir --cacheDir "%~dp0.hugocache" 2>&1
if errorlevel 1 (
  echo 构建失败，请检查上面的错误信息后重试。
  pause
  exit /b 1
)
echo 构建成功，输出在 public\ 目录。
echo.

REM 第一次运行会自动初始化 Git 仓库并绑定远程地址
if not exist ".git" (
  echo [2/5] 初始化 Git 仓库...
  git init
  git branch -M main
  git remote add origin https://github.com/HighTechChina/HighTechChina.github.io.git
  git config user.name "博雅高科"
  git config user.email "hightech@agent.qq.com"
) else (
  echo [2/5] Git 仓库已存在，跳过初始化。
)

echo.
echo [3/5] 添加所有改动...
git add -A

echo.
echo [4/5] 提交...
set /p MSG="请输入本次更新说明(直接回车用默认): "
if "%MSG%"=="" set MSG=update site
git commit -m "%MSG%"

echo.
echo [5/5] 推送到 GitHub (首次会弹出登录，请用 HighTechChina 账号 + 个人访问令牌 PAT)...
git push -u origin main

echo.
echo ==============================================
echo   完成! 稍后访问: https://hightechchina.github.io/
echo   (首次需在仓库 Settings-Pages 里把 Source 选为 GitHub Actions)
echo ==============================================
pause

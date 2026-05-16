@echo off
setlocal

set "BASE_HREF=/OASX/"
if not "%~1"=="" set "BASE_HREF=%~1"

where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter 未安装，或 flutter 没有加入 PATH。
  exit /b 1
)

cd /d "%~dp0"

echo [INFO] 开始构建 Flutter Web
echo [INFO] base-href = %BASE_HREF%

flutter pub get
if errorlevel 1 (
  echo [ERROR] flutter pub get 执行失败。
  exit /b 1
)

flutter build web --web-renderer canvaskit --base-href "%BASE_HREF%"
if errorlevel 1 (
  echo [ERROR] flutter build web 执行失败。
  exit /b 1
)

echo [OK] 构建完成，输出目录：build\web
endlocal
pause

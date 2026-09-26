@echo off
taskkill /f /im java.exe /im gradle.exe /im dart.exe /im flutter.exe 2>nul
timeout /t 3 /nobreak >nul
if exist "E:\talabtek_app\talabtek_app\.dart_tool" rd /s /q "E:\talabtek_app\talabtek_app\.dart_tool" 2>nul
if exist "E:\talabtek_app\talabtek_app\build" rd /s /q "E:\talabtek_app\talabtek_app\build" 2>nul
if exist "E:\talabtek_app\talabtek_app\.dart_tool" rd /s /q "E:\talabtek_app\talabtek_app\.dart_tool" 2>nul
if exist "E:\talabtek_app\talabtek_app\build" rd /s /q "E:\talabtek_app\talabtek_app\build" 2>nul
if exist "E:\talabtek_app\talabtek_app\android\.gradle" rd /s /q "E:\talabtek_app\talabtek_app\android\.gradle" 2>nul
if exist "E:\talabtek_app\talabtek_app\android\app\build" rd /s /q "E:\talabtek_app\talabtek_app\android\app\build" 2>nul
if exist "E:\talabtek_app\talabtek_app\android\.gradle" rd /s /q "E:\talabtek_app\talabtek_app\android\.gradle" 2>nul
if exist "E:\talabtek_app\talabtek_app\.dart_tool" rd /s /q "E:\talabtek_app\talabtek_app\.dart_tool" 2>nul
timeout /t 3 /nobreak >nul
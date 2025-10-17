@echo off
echo Starting Smart Alarm Clock App...
cd /d "%~dp0"
flutter clean
flutter pub get
flutter run
pause

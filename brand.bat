set brand=%1
cd %brand%
set from=%cd%\assets
cd ..
cd src
set to=%cd%\assets
echo %to%
xcopy %from% %to% /m /e /y
pause
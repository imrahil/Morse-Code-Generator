cls
call "%PLAYBOOK_HOME%\bin\blackberry-airpackager.bat" -package "bin-release\MorseCodeGenerator.bar" src\MorseCodeGenerator-app.xml -C bin-release bin-release\MorseCodeGenerator.swf -C src src\blackberry-tablet.xml src\morse-icon.png src\morse-splash.png -devMode -debugToken debugtoken_imrahil.bar -installApp -launchApp -password jarek -device 192.168.1.10

rem -target bar-debug -connect 192.168.1.12 
cls
call "%PLAYBOOK_HOME%\bin\blackberry-airpackager.bat" -package "bin-release\MorseCodeGenerator.bar" src\MorseCodeGenerator-app.xml -C bin-release bin-release\MorseCodeGenerator.swf -C src src\bar-descriptor.xml src\morse-icon.png src\morse-splash.png -devMode -debugToken debugtoken_imrahil.bar -installApp -launchApp -password jarek -device 192.168.127.131

rem -target bar-debug -connect 192.168.1.12 
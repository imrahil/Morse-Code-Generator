cls
c:\Dev\Flex_SDK\blackberry-tablet-sdk-2.0.0\bin\blackberry-airpackager.bat -devMode -debugToken debugtoken_imrahil.bar -package "bin-release\MorseCodeGenerator.bar" src\MorseCodeGenerator-app.xml -C bin-release bin-release\MorseCodeGenerator.swf -C src src\blackberry-tablet.xml src\morse-icon.png src\morse-splash.png -installApp -launchApp -password jarek -device 192.168.23.135

@rem -target bar-debug -connect 192.168.1.6 
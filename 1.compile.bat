cls
call "%PLAYBOOK_HOME%\bin\amxmlc.bat" -define=CONFIG::debugMode,false -define=CONFIG::device,true -library-path+=libs -external-library-path+="%PLAYBOOK_HOME%\frameworks\libs\qnx\ane\QNXDevice.ane" -output bin-release\MorseCodeGenerator.swf src\MorseCodeGenerator.as

rem -debug=true 
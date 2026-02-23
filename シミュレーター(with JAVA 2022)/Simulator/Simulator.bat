pushd %~dp0 
subst J: .
J:
Windows\jre\bin\java -jar Simulator.jar
subst J: /d
popd

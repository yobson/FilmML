# FilmML
A machine learning experiment for working out film preferences

## Enviroment Setup
### POSIX
Install [ObjFW](https://github.com/Midar/objfw)
### Windows
1. You must have windows 10 creators update
2. You must get the linux subsystem for windows. If you had it before the update, you must reinstall it (This updates the ubuntu version to 16.04)
3. Open powershell and type ```bash``` (For some reason this doesn't work in the default bash shell, the test fail, I assume this is becuase the tests for ObjFW run on windows becuase it's a cross compiler and it runs the tests.exe in the powershell enviroment?)
4. cd to the git directory and type ```sudo ./ObjcCrossCompileEnvSetup.sh``` This will install the build enviroment.

## Compiling
When I have actually built enough I will fill this bit in

## Todo
- [x] Build windows enviroment
- [ ] Build simple ML for machines
- [ ] Interface with Elasticsearch
- [ ] Build dll for and c# library for ASP.net
# FilmML
A machine learning film recomendation experiment designed for a lower power and memory enviroment than depp learning. By the end, it should be filly interfaced with C# and elasticsearch (for an ASP.net site).

## Enviroment Setup
### POSIX
Install [ObjFW](https://github.com/Midar/objfw)
### Windows
1. You must have windows 10 creators update
2. You must get the linux subsystem for windows. If you had it before the update, you must reinstall it (This updates the ubuntu version to 16.04)
3. Open powershell and type ```bash``` (For some reason this doesn't work in the default bash shell, the test fail, I assume this is becuase the tests for ObjFW run on windows becuase it's a cross compiler and it runs the tests.exe in the powershell enviroment?)
4. cd to the git directory and type ```sudo ./ObjcCrossCompileEnvSetup.sh``` This will install the build enviroment.

If you don't have the creators update, try the windows installation on the ObjFW site... I wish you luck, clang 4 is broken in msys2 but GCC seems to work fine!

## Compiling
Simply run ```./build.sh```

## Details about the project
### How it should work
The idea is each film and user shall be represented as a node. Each film is given a default genre but has a list of other genres. The default genre is set to 1 and the rest 0. This is called taste scores becuase if a lot of people who like crime watch a horor film (for example) and enjoy it, the film's crime taste score will be increased and the user's horor taste score will also be increased. People have their taste scorse for the different film types set to 0. As people watch films, it will work out if they like it or not (thumbs up / watch time) and will ajust their film prefenece based on this. When a user with a different set of preferences watches a film and enjoys it, a link is produced between the two. As the two have their preferences updated, they will affect eachother (the film will affect the user more), but the link will die after a given period. An algorythm will go though each user and cross reference their preferences with the film to produce a single figure called compatibility. This will then me multiplied by the number of views. The films shall be ordered in decending order and the first n number of films shall be stored in Elasticsearch under the user's entry for a web application to access.

### Why Objective c?
The reason for this project is to build a ML film recomendation system that works on a low budget. Not enough users for deep learning and not enough computational power either. I chose objective c becuase I am far more familier with C than C++. Not only this, but making dll files accessable from C# is harder in C++ becuase the interface between the two languages only works with C (and I hate the mess of extern c). I do however see the benifits of OOP and for that reason chose objective C. When the ObjFW framework is compiled, you get something windows woud treat as if it was written in C (I think/hope). I am not using C# becuase it is a far slower language and has a far higher memory footprint. It will make my life harder, but I'm doing it for a better final product. 

## Todo
- [x] Build windows enviroment
- [ ] Build simple ML for machines
- [ ] Interface with Elasticsearch
- [ ] Build dll and c# library for ASP.net
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
1. Make sure there is a ```bin``` folder in the root directory of the project
2. Simply run ```./build.sh```

On Windows, you will need the ObjFW dlls (which are coppied into the bin folder on environment setup) so copy the two dlls with the libfilmML.dll file to the C# project.

## Details about the project
### How it should work
#### Overview
The idea is each film and user shall be represented as a node. Each film is given a default genre but has a list of other genres. The default genre is set to 1 and the rest 0. This is called taste scores becuase if a lot of people who like crime watch a horor film (for example) and enjoy it, the film's crime taste score will be increased and the user's horor taste score will also be increased. People have their taste scorse for the different film types set to 0. As people watch films, it will work out if they like it or not (thumbs up / watch time) and will ajust their film prefenece based on this. When a user with a different set of preferences watches a film and enjoys it, a link is produced between the two. As the two have their preferences updated, they will affect eachother (the film will affect the user more), but the link will die after a given period. An algorythm will go though each user and cross reference their preferences with the film to produce a single figure called compatibility. This will then me multiplied by the number of views. The films shall be ordered in decending order and the first n number of films shall be stored in Elasticsearch under the user's entry for a web application to access.

### Why Objective c?
The reason for this project is to build a ML film recomendation system that works with flow CPU and memory usage. For this reason, being able to move pointers about and have native compilation makes a C language the best choice. However, I went for objective c becuase I can wrap C classes in OOP without the added extra work C++ requires. My tests in C# showed that it would make a far slower project

#### The Maths
Each easte preference is stored in a vector of t elements where t is the number of genres

![Vector](/images/vec1.gif)

such that

![Vector Sum](/images/VecSum.gif)

Becuase the vector sum always = 1, the values inside can be used as a ratio or percentage that indeicates %. This means that the machine learning [activation function](https://en.wikipedia.org/wiki/Activation_function) must be y=x in order to keep this proptionality.

The machine learning works by finding the difference between two vectors and appying a momentum function and learning speed constant to it in order to calculate how the film and taste vecotrs need to change.

![Delta Vector](/images/DeltaVec.gif)

The properties of the film and user vector mean that

![The summation of the Delta Vector](/images/deltaVecSum.gif)

This means that we can multiply the delta vector by any number, apply it to our film and user vector and keep the sum total of the elements of the vectors as 1.

Our ML function uses the delta vector as it's gradiant for both the user and film ML function becuase it it learning both film and user preferance simultainiously allowing for unsupervised learning.

The simple version of the two learning functions are:

![Simple Film Learning Function](/images/simpFML.gif)

![Simple User Learning Function](/images/simpUML.gif)

where Vu and Vf are constants that determin the learning speed. This affects how much change happens after each iteration. I sugest that you make both low, with Vf being far lower than Vu. This difference means that Users affect the film vector less than the film affects the user. And since the film is given a default genre, it will be far more accurate, especially in the begining.

The momentum function is a way of correcting big errors faster. If an element in a vector is being changed a lot, it will increase the change in order to get to the equilibriam faster. It works by storing the last change applied to the taste vector in another vector that acompanies the film and user vectors. a constant of momentum is then used to determin how much change will be affected by the delta vector, and how much will be determined by the last change.

This makes our full machine learning function the following:

![Full Film Learning Function](/images/compFML.gif)

![Full User Learning Function](/images/compUML.gif)

Where eta denotes the momentum and t is a unit for descrete time.

## Todo
- [x] Build windows enviroment
- [x] Build simple ML algorythm
- [ ] Interface with Elasticsearch
- [ ] Build dll and c# library for ASP.net
- [ ] Port to .net core as well


##
Maths equations made using [this](https://www.codecogs.com/eqnedit.php?]) tool.

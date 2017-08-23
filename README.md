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

#### Why Objective c?
The reason for this project is to build a ML film recomendation system that works with flow CPU and memory usage. For this reason, being able to move pointers about and have native compilation makes a C language the best choice. However, I went for objective c becuase I can wrap C classes in OOP without the added extra work C++ requires. My tests in C# showed that it would make a far slower project

#### The Maths
Each taste preference is stored in a vector of n elements where n is the number of genres.

<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{U}&space;=&space;\begin{bmatrix}&space;u_1&space;\\&space;u_2&space;\\&space;...&space;\\&space;u_n&space;\end{bmatrix}" title="\large \vec{U} = \begin{bmatrix} u_1 \\ u_2 \\ ... \\ u_n \end{bmatrix}" />

where the vector has the following property

<img src="https://latex.codecogs.com/gif.latex?\large&space;\sum_{i=1}^t&space;\vec{U}_i&space;=&space;1" title="\large \sum_{i=1}^t \vec{U}_i = 1" />

Becuase the vector sum always = 1, the values inside can be used as a ratio or percentage that indeicates a user's taste or tilm type as a set of ratios. This means that the machine learning [activation function](https://en.wikipedia.org/wiki/Activation_function) must be y=x in order to keep this proptionality.

The machine learning works by finding the difference between two vectors and appying a momentum function and learning speed constant to it in order to calculate how the film and taste vecotrs need to change.

<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{\Delta}&space;=&space;\begin{bmatrix}&space;u_1&space;\\&space;u_2&space;\\&space;...&space;\\&space;u_n&space;\end{bmatrix}&space;-&space;\begin{bmatrix}&space;f_1&space;\\&space;f_2&space;\\&space;...&space;\\&space;f_n&space;\end{bmatrix}" title="\large \vec{\Delta} = \begin{bmatrix} u_1 \\ u_2 \\ ... \\ u_t \end{bmatrix} - \begin{bmatrix} f_1 \\ f_2 \\ ... \\ f_t \end{bmatrix}" />

The properties of the film and user vector mean that

<img src="https://latex.codecogs.com/gif.latex?\large&space;\sum_{i=1}^n&space;\vec{\Delta}_i&space;=&space;0" title="\large \sum_{i=1}^n \vec{\Delta}_i = 0" />

This means that we can multiply the delta vector by any number, apply it to our film and user vector and keep the sum total of the elements of the vectors as 1.

Our ML function uses the delta vector as it's gradiant for both the user and film ML function becuase it it learning both film and user preferance simultainiously allowing for unsupervised learning.

The simple version of the two learning functions are:

<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{F}_{(t&plus;1)}&space;=&space;\vec{F}_t&space;&plus;&space;\vec{\Delta}_t&space;\cdot&space;V_f" title="\large \vec{F}_{(t+1)} = \vec{F}_t + \vec{\Delta}_t \cdot V_f" />
<br />
<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{U}_{(t&plus;1)}&space;=&space;\vec{U}_t&space;-&space;\vec{\Delta}_t&space;\cdot&space;V_u" title="\large \vec{U}_{(t+1)} = \vec{U}_t - \vec{\Delta}_t \cdot V_u" />

where Vu and Vf are constants that determin the learning speed. This affects how much change happens after each iteration. I sugest that you make both low, with Vf being far lower than Vu. This difference means that Users affect the film vector less than the film affects the user. And since the film is given a default genre, it will be far more accurate, especially in the begining.

The momentum function is a way of correcting big errors faster. If an element in a vector is being changed a lot, it will increase the change in order to get to the equilibriam faster. It works by storing the last change applied to the taste vector in another vector that acompanies the film and user vectors. a constant of momentum is then used to determin how much change will be affected by the delta vector, and how much will be determined by the last change.

This makes our full machine learning function the following:

<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{F}_{(t&plus;1)}&space;=&space;\vec{F}_t&space;&plus;&space;\vec{\Delta}_t&space;\cdot&space;V_f&space;\cdot&space;(1&space;-&space;\eta_f)&space;&plus;&space;[\vec{F}_t&space;-&space;\vec{F}_{(t-1)}]&space;\cdot&space;\eta_f" title="\large \vec{F}_{(t+1)} = \vec{F}_t + \vec{\Delta}_t \cdot V_f \cdot (1 - \eta_f) + [\vec{F}_t - \vec{F}_{(t-1)}] \cdot \eta_f" />
<br />
<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{U}_{(t&plus;1)}&space;=&space;\vec{U}_t&space;-&space;\vec{\Delta}_t&space;\cdot&space;V_u&space;\cdot&space;(1&space;-&space;\eta_u)&space;&plus;&space;[\vec{U}_t&space;-&space;\vec{U}_{(t-1)}]&space;\cdot&space;\eta_u" title="\large \vec{U}_{(t+1)} = \vec{U}_t - \vec{\Delta}_t \cdot V_u \cdot (1 - \eta_u) + [\vec{U}_t - \vec{U}_{(t-1)}] \cdot \eta_u" />

Where eta denotes the momentum and t is a unit for descrete time or iteration.

In order to get the list of suggested films, first a list of films a user has not seen must be built. Then the compatability function is applied:

<img src="https://latex.codecogs.com/gif.latex?\large&space;\vec{C}&space;:=&space;\vec{F}&space;\odot&space;\vec{U}&space;\cdot&space;kN&space;\therefore&space;C&space;=&space;\sum_{i&space;=&space;1}^{n}&space;\vec{C}_i" title="\large \vec{C} := \vec{F} \odot \vec{U} \cdot kN \therefore C = \sum_{i = 1}^{n} \vec{C}_i"/>

where n is number of film views, k is a constant that affects how influential this is. The circle dot operator is the [Hadamard Product](https://en.wikipedia.org/wiki/Hadamard_product_(matrices)). C can then be used as a ranking that rates films on both popularity and compatability.

## Todo
- [x] Build windows enviroment
- [x] Build simple ML algorythm
- [ ] Interface with Elasticsearch
- [ ] Build dll and c# library for ASP.net
- [ ] Port to .net core as well


##
Maths equations made using [this](https://www.codecogs.com/eqnedit.php?]) tool.

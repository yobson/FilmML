objfw-compile --lib 0.1 -o filmML main.m C/Common.m Classes/Film.m Classes/User.m
mv *.dll bin/.
rm -r *.o *.a
cd Classes
rm -r *.o
cd ../C
rm -r *.o
objfw-compile --lib 0.1 -o filmML main.m Classes/Film.m
if [ -f bin ]
then
mkdir bin
fi
mv *.dll bin/.
cp objfw/src/runtime/libobjfw-rt.dll bin/.
cp objfw/src/libobjfw.dll bin/.
rm -r *.o *.a
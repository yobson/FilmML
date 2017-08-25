objfw-compile -Ofast --lib 0.1 -o filmML main.m C/*.m Classes/*.m
mv *.dll bin/.
# rm -r *.o *.a
# cd Classes
# rm -r *.o
# cd ../C
# rm -r *.o
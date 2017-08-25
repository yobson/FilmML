using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace FilmML
{
    public class DLL
    {
        public const string DllName = "libfilmML.dll";

/*
EXPORT int __stdcall initFilmML();
EXPORT void __stdcall onExit();
EXPORT int __stdcall addFilm(const char *filmName, FilmType defaultFilmType);
EXPORT int __stdcall addUser();
EXPORT void __stdcall cleanUpUsers();
EXPORT int __stdcall dllTest();
EXPORT int __stdcall setFilmLearningMomentum(float f);
EXPORT int __stdcall setUserLearningMomentum(float f);
EXPORT int __stdcall setFilmLearningRate(float f);
EXPORT int __stdcall setUserLearningRate(float f);
EXPORT void __stdcall setNumberOfFilmSuggestions(unsigned int s);
EXPORT void __stdcall registerFilmView(unsigned int userID, unsigned int filmID);
EXPORT void __stdcall triggerfullSystemML();
EXPORT int __stdcall elasticSearchUpdate();
EXPORT int __stdcall elasticSearchClean();
EXPORT int __stdcall elasticSearchSetup(char *esURL, char *esIndex);
*/

#pragma warning disable IDE1006 // Naming Styles
        [DllImport(DllName)]
        public static extern int initFilmML();
        [DllImport(DllName)]
        public static extern void onExit();
        [DllImport(DllName)]
        public static extern int addFilm(string filmName, int defaultFilmType);
        [DllImport(DllName)]
        public static extern int addUser();
        [DllImport(DllName)]
        public static extern void cleanUpUsers();
        [DllImport(DllName)]
        public static extern int dllTest();
        [DllImport(DllName)]
        public static extern int setFilmLearningMomentum(float f);
        [DllImport(DllName)]
        public static extern int setUserLearningMomentum(float f);
        [DllImport(DllName)]
        public static extern int setFilmLearningRate(float f);
        [DllImport(DllName)]
        public static extern int setUserLearningRate(float f);
        [DllImport(DllName)]
        public static extern void setNumberOfFilmSuggestions(uint s);
        [DllImport(DllName)]
        public static extern void registerFilmView(uint userID, uint filmID);
        [DllImport(DllName)]
        public static extern void triggerfullSystemML();
        [DllImport(DllName)]
        public static extern int elasticSearchUpdate();
        [DllImport(DllName)]
        public static extern int elasticSearchClean();
        [DllImport(DllName)]
        public static extern int elasticSearchSetup([MarshalAs(UnmanagedType.LPStr)]string esURL, [MarshalAs(UnmanagedType.LPStr)]string esIndex);
#pragma warning restore IDE1006

    }

    public class FilmML
    {
    }
}

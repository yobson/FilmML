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
        [DllImport(DllName)]
        public static extern int initFilmML();
        [DllImport(DllName)]
        public static extern int addFilm(string filmName, int defaultFilmType);
        [DllImport(DllName)]
        public static extern int addUser();
        [DllImport(DllName)]
        public static extern void cleanUpUsers();
        [DllImport(DllName)]
        public static extern int dllTest();

    }

    public class FilmML
    {
    }
}

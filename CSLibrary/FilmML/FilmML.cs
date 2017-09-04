using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Collections;
using System.Timers;

namespace FilmML
{
    internal class DLL
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
        EXPORT void __stdcall setUserLife(unsigned int l);
        EXPORT void __stdcall setNumberOfFilmSuggestions(unsigned int s);
        EXPORT void __stdcall registerFilmView(unsigned int userID, unsigned int filmID);
        EXPORT void __stdcall triggerfullSystemML();
        EXPORT int __stdcall elasticSearchUpdate();
        EXPORT int __stdcall elasticSearchClean();
        EXPORT int __stdcall elasticSearchSetup(char *esURL, char *esIndex);
        EXPORT int __stdcall addFilmsToElasticSearch();
        */

#pragma warning disable IDE1006 // Naming Styles
        [DllImport(DllName)]
        public static extern int initFilmML();
        [DllImport(DllName)]
        public static extern void onExit();
        [DllImport(DllName)]
        public static extern int addFilm(string filmName, uint defaultFilmType, int alreadyInES);
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
        public static extern void setUserLife(uint l);
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
        [DllImport(DllName)]
        public static extern int addFilmsToElasticSearch();
        [DllImport(DllName)]
        public static extern int addUsersToElasticSearch();
#pragma warning restore IDE1006

    }

    public struct ViewData {
        public uint FilmID;
        public uint UserID;
    };

    public class FilmML
    {

        Queue<ViewData> Watches = new Queue<ViewData>();
        Timer t = new Timer();


        public void SetupFilmML(
                uint UserLife = 5,
                float UserLearningMomentum = 0.2f,
                float FilmLearningMomentum = 0.2f,
                float UserLearningRate = 0.3f,
                float FilmLearningRate = 0.1f,
                uint NumberOfFilmSugestions = 10,
                string ElasticSearchURL = "127.0.0.1:9200",
                string ElasticSearchIndex = "filmml",
                double UpdateInterval = 10000
            )
        {
            DLL.initFilmML();
            DLL.setUserLife(UserLife);
            DLL.setUserLearningMomentum(UserLearningMomentum);
            DLL.setFilmLearningMomentum(FilmLearningMomentum);
            DLL.setUserLearningRate(UserLearningRate);
            DLL.setFilmLearningRate(FilmLearningRate);
            DLL.setNumberOfFilmSuggestions(NumberOfFilmSugestions);
            if (DLL.elasticSearchSetup(ElasticSearchURL, ElasticSearchIndex) != 0)
            {
                Console.WriteLine("Something went wrong connecting to elastic search!");
            }
            t.AutoReset = true;
            t.Interval = UpdateInterval;
            t.Elapsed += SyncViews;
            t.Start();
        }

        public void AddFilm(Film f, bool sync = true, bool inEs = true)
        {
            f.ID = DLL.addFilm(f.Name, (uint)f.DefaultType, inEs ? 1 : 0);
            if (sync) { DLL.addFilmsToElasticSearch(); }
        }

        public int AddFilms(List<Film> f, bool alreadyInEs = true)
        {
            f.ForEach(a => AddFilm(a, false, alreadyInEs));
            return DLL.addFilmsToElasticSearch();
        }

        public void AddUser(User u, bool sync = true)
        {
            u.ID = DLL.addUser();
            if (sync) { DLL.addUsersToElasticSearch(); }
        }

        public int AddUsers(List<User> u)
        {
            u.ForEach(a => AddUser(a, false));
            return DLL.addUsersToElasticSearch();
        }

        public void AddView(ViewData viewData)
        {
            Watches.Enqueue(viewData);
        }

        private void SyncViews(object sender, System.Timers.ElapsedEventArgs e)
        {
            Console.WriteLine("Adding " + Watches.Count + " views to ML database");
            while (Watches.Count > 0)
            {
                ViewData d = Watches.Dequeue();
                DLL.registerFilmView(d.UserID, d.FilmID);
            }
            DLL.triggerfullSystemML();
            DLL.elasticSearchUpdate();
        }

        public void RefreshUserDb()
        {
            DLL.cleanUpUsers();
            DLL.elasticSearchClean();
        }

        public int Test()
        {
            Console.WriteLine("Hello From FilmMLCS");
            return DLL.dllTest();
        }

    }
}

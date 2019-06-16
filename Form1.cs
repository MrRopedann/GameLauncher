using System;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Windows.Forms;
using System.Xml.Linq;
using Ionic.Zip;

namespace Launcher_v2
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();

            //Download progress
            backgroundWorker1.RunWorkerAsync();

            strtGameBtn.Enabled = false;

        }

        //Makes the form dragable
        private void Form1_MouseDown(object sender,
        System.Windows.Forms.MouseEventArgs e)
        {
           
        }

        //Close Button
        private void closeBtn_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void closeBtn_MouseEnter(object sender, EventArgs e)
        {
            closeBtn.BackgroundImage = Properties.Resources.close2;
        }

        private void closeBtn_MouseLeave(object sender, EventArgs e)
        {
            closeBtn.BackgroundImage = Properties.Resources.close1;
        }

        //Minimize Button
        private void minimizeBtn_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void minimizeBtn_MouseEnter(object sender, EventArgs e)
        {
            minimizeBtn.BackgroundImage = Properties.Resources.minimize2;
        }

        private void minimizeBtn_MouseLeave(object sender, EventArgs e)
        {
            minimizeBtn.BackgroundImage = Properties.Resources.minimize1;
        }

        //Delete File
        static bool deleteFile(string f)
        {
            try
            {
                File.Delete(f);
                return true;
            }
            catch (IOException)
            {
                return false;
            }
        }
        

        //background Worker: Handles downloading the updates
        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            //Defines the server's update directory
            string Server = "http://pko-darkside.ru/patches/";

            //Defines application root
            string Root = AppDomain.CurrentDomain.BaseDirectory;

            //Make sure version file exists
            FileStream fs = null;
            if(!File.Exists("version"))
            {
                using (fs = File.Create("version"))
                {

                }

                using (StreamWriter sw = new StreamWriter("version"))
                {
                    sw.Write("1,0");
                }
            }
            //checks client version
            string lclVersion;
            using (StreamReader reader = new StreamReader("version"))
            {
                lclVersion = reader.ReadLine();
            }
            decimal localVersion = decimal.Parse(lclVersion);


            //server's list of updates
            XDocument serverXml = XDocument.Load(@Server+"Updates.xml");

            //The Update Process
            foreach (XElement update in serverXml.Descendants("update"))
            {
                string version = update.Element("version").Value;
                string file = update.Element("file").Value;

                decimal serverVersion = decimal.Parse(version);


                string sUrlToReadFileFrom = Server + file;

                string sFilePathToWriteFileTo = Root + file;

                if (serverVersion > localVersion)
                {
                    Uri url = new Uri(sUrlToReadFileFrom);
                    System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);
                    System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();
                    response.Close();

                    Int64 iSize = response.ContentLength;

                    Int64 iRunningByteTotal = 0;

                    using (System.Net.WebClient client = new System.Net.WebClient())
                    {
                        using (System.IO.Stream streamRemote = client.OpenRead(new Uri(sUrlToReadFileFrom)))
                        {
                            using (Stream streamLocal = new FileStream(sFilePathToWriteFileTo, FileMode.Create, FileAccess.Write, FileShare.None))
                            {
                                int iByteSize = 0;
                                byte[] byteBuffer = new byte[iSize];
                                while ((iByteSize = streamRemote.Read(byteBuffer, 0, byteBuffer.Length)) > 0)
                                {
                                    streamLocal.Write(byteBuffer, 0, iByteSize);
                                    iRunningByteTotal += iByteSize;

                                    double dIndex = (double)(iRunningByteTotal);
                                    double dTotal = (double)byteBuffer.Length;
                                    double dProgressPercentage = (dIndex / dTotal);
                                    int iProgressPercentage = (int)(dProgressPercentage * 100);

                                    backgroundWorker1.ReportProgress(iProgressPercentage);
                                }

                                streamLocal.Close();
                            }

                            streamRemote.Close();
                        }
                    }

                    //unzip
                    using (ZipFile zip = ZipFile.Read(file))
                    {
                        foreach (ZipEntry zipFiles in zip)
                        {
                            zipFiles.Extract(Root + "\\", true);
                        }
                    }

                    //download new version file
                    WebClient webClient = new WebClient();
                    webClient.DownloadFile(Server+"version.txt", @Root+"version");

                    //Delete Zip File
                    deleteFile(file);
                }
            }
        }

        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            progressBar1.Value = e.ProgressPercentage;
            downloadLbl.ForeColor = System.Drawing.Color.Silver;
            downloadLbl.Text = "Скачиваем обновление";
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            strtGameBtn.Enabled = true;
            this.downloadLbl.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(121)))), ((int)(((byte)(203)))));
            downloadLbl.Text = "Клиент обновлен";
        }

        public bool IsProcessOpen(string name)
        {
            foreach (Process clsProcess in Process.GetProcesses())
            {
                if (clsProcess.ProcessName.Contains(name))
                {

                    return true;
                }

            }
            return false;
        }
        //Starts the game
        private void strtGameBtn_Click(object sender, EventArgs e)
        {
            if (IsProcessOpen("Game"))
            {
                MessageBox.Show("Клиент уже запущен!");
                this.Close();
            }
            else { 
            //Кнопка "Запуск игры"
            byte[] buffer = File.ReadAllBytes("system//Game.exe");
            File.WriteAllBytes("key.txt", buffer);
            string[] str = File.ReadAllLines("key.txt");
            char[] chr = str[14861].ToCharArray(138, 9);
            string skey = "";
            for (int i = 0; i < chr.Length; i++)
            {
                skey += chr[i];
            }
            File.Delete("key.txt");

            Process.Start("system\\Game.exe", skey);
            this.Close();
            }
        }

        private void patchNotes_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://pko-darkside.ru/DataBase/reg.php");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://pko-darkside.ru/");
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void SendEmail (string clientEmail)
    {
        string CompanyName = "БЮРО МОНТАЖНИКА";
        int PORT = 587;
        string HOST = "smtp.gmail.com";
        string email = "@gmail.com";
        string password = "";

        try {
            using (MailMessage letter = new MailMessage(CompanyName + "<" + email + ">", clientEmail))
            {
                letter.Subject = "Обновлены данные в таблице";
                letter.Body = "обновлены.";
                letter.IsBodyHtml = true;
                using (SmtpClient sc = new SmtpClient(HOST, PORT))
                {
                    sc.EnableSsl = true;
                    sc.DeliveryMethod = SmtpDeliveryMethod.Network;
                    sc.UseDefaultCredentials = false;
                    sc.Credentials = new NetworkCredential(email, password);
                    sc.Send(letter);
                }
            }
        } 
       catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
            throw ex;
        }
    }
}

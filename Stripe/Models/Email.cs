using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace Stripe.Models
{
    public class Email
    {
        public Boolean SendEmail(string receiver, string subject, string message)
        {
            var messageFrom = new MailAddress("avarghe@ilstu.edu", "STRIPE Systems");
            var emailMessage = new MailMessage { From = messageFrom };

            var messageTo = new MailAddress(receiver);
            emailMessage.To.Add(messageTo.Address);

            var messageSubject = subject;
            var messageBody = message;
            emailMessage.Subject = messageSubject;
            emailMessage.Body = messageBody;
            emailMessage.IsBodyHtml = true;
            var mailClient = new SmtpClient("smtp.ilstu.edu");
            // Credentials are necessary if the server requires the client 
            // to authenticate before it will send e-mail on the client's behalf.
            // Do this in the web.config file
            try
            {
                mailClient.UseDefaultCredentials = true; // false;
                //mailClient.Send(emailMessage);
            }
            catch (Exception e)
            {
                Console.Write(e);
                return false;
            }
            return true;
        }

        public String MailBody(String link)
        {
            string mailBody = "<h3>Stripe Verification</h3>"
                        + "<p>Please <a href='" + link
                        + "'>Click here</a> to verify your email id and gain access to the system</p>"
                        + "<p>Thank you</p>"
                        + "<br/>"
                        + "<p>Thank you</p>"
                        + "<p>STRIPE Team</p>";
            return mailBody;
        }
    }
}
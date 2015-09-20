using Stripe.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Controllers
{
    public class RefereeController : Controller
    {
        //
        // GET: /Referee/
        public ActionResult Home(int id)
        {
            using (var context = new StripeEntities())
            {
                var RefereeProfile = context.User_Profile.Where(loginid => loginid.Login_login_ID == id).SingleOrDefault();
                 return View("Home", RefereeProfile);
            }
           
        }
	}
}
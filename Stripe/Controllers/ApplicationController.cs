using Stripe.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Controllers
{
    public class ApplicationController : Controller
    {
        //
        // GET: /Application/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult UpdateStatus(int refereeId, int eventId, string status)
        {
            using (var context = new StripeEntities())
            {
                context.SP_UPDATE_REFEREE_STATUS_BY_EVENTID(eventId, refereeId, status);
                context.SaveChanges();
                return RedirectToAction("ViewApplications", "Director", new { eventid = eventId });
            }
        }
    }
}
using Stripe.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Controllers
{
    public class EventController : Controller
    {
        //
        // GET: /Event/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult List()
        {
            using (var context = new StripeEntities())
            {
                var eventList = context.Sport_Event.ToList();
                return View(eventList);
            }
        }

        
	}
}
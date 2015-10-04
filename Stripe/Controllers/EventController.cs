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

        public ActionResult EditEvent(int eventId)
        {
            using (var context = new StripeEntities())
            {
                Event getEventDetails = new Event(context);
                var eventDetails = getEventDetails.GetEventByEventId(eventId)
                    .SingleOrDefault();

                ViewBag.SchoolList = SchoolClass.getSchoolList(context);
                GetGameList getGameList = new GetGameList(context);
                ViewBag.GameList = getGameList.getGameTypeList();

                return View(eventDetails);
            }
        }

        [HttpPost]
        public ActionResult EditEvent(Sport_Event sportDetails)
        {
            using (var context = new StripeEntities())
            {
                context.SP_EVENT_DETAILS_UPDATE(sportDetails.event_Date,
                    sportDetails.event_Time,
                    sportDetails.event_School_Field_Name,
                    sportDetails.Sport_Name_spt_Sport_Name_ID,
                    sportDetails.event_ID);
                context.SaveChanges();

                return RedirectToAction("ViewEvents", "Director");
            }
        }

        public ActionResult UpdateScores(int eventId)
        {
            using (var context = new StripeEntities())
            {
                Event getEventDetails = new Event(context);
                var eventDetails = getEventDetails.GetEventByEventId(eventId)
                    .SingleOrDefault();

                return View(eventDetails);
            }
        }

        [HttpPost]
        public ActionResult UpdateScores(SP_GET_EVENT_BY_EVENTID_Result eventScores)
        {
            using (var context = new StripeEntities())
            {
                Event updateEventScores = new Event(context);
                if (updateEventScores.UpdateEventScores(eventScores))
                {
                    return RedirectToAction("ViewEvents", "Director");
                }
                else
                {
                    return View("Error");
                }
            }
        }
    }
}
using Stripe.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Controllers
{
    public class DirectorController : Controller
    {
        //
        // GET: /Director/
        public ActionResult Home()
        {
            return View();
        }

        public ActionResult Profile()
        {
            using (var context = new StripeEntities())
            {
                try
                {
                    int id = Convert.ToInt32(Session["loginid"]);
                    var refereeProfile = context.User_Profile.Where(userid => userid.userProfile_ID == id).SingleOrDefault();
                    return View(refereeProfile);
                }
                catch (Exception exception)
                {
                    Console.Write(exception.Message);
                    ViewBag.ErrorMessage = "There is something wrong with the account. Please contact admin";
                    return View("Error");
                }
            }
        }

        [HttpPost]
        public ActionResult Profile(User_Profile refProfile)
        {
            using (var context = new StripeEntities())
            {
                UserProfileExistCheck profileCheck = new UserProfileExistCheck();
                UserProfile userProfile = new UserProfile();
                if (profileCheck.UserProfileExistence(refProfile.userProfile_ID, context))
                {
                    userProfile.UserProfileUpdate(context, refProfile);
                }
                else
                {
                    //Inserting Profile
                    userProfile.UserProfileInsert(context, refProfile);
                }

                return RedirectToAction("Profile");
            }
        }



        public ActionResult SchoolDetails()
        {
            using (var context = new StripeEntities())
            {
                int id = Convert.ToInt32(Session["loginid"]);

                SchoolClass schoolClass = new SchoolClass(context);
                var schoolDetails = schoolClass.getSchoolDetailsFromDirector(id);

                return View("SchoolDetails", schoolDetails);
            }
        }

        [HttpPost]
        public ActionResult SchoolDetails(SP_SCHOOL_DETAILS_FROM_DIRECTOR_Result schoolDetails)
        {
            using (var context = new StripeEntities())
            {
                SchoolClass schoolClass = new SchoolClass(context);
                var schoolRecord = schoolClass.getSchoolDetailsFromDirector(schoolDetails.User_Profile_Director_Profile_ID);
                
                if (schoolRecord == null)
                {
                    schoolClass.InsertUpdateSchoolRecords(true, context, schoolDetails);
                }
                else
                {
                    schoolClass.InsertUpdateSchoolRecords(false, context, schoolDetails);
                }
                return RedirectToAction("SchoolDetails");
            }
        }

        public ActionResult CreateEvent()
        {
            using (var context = new StripeEntities())
            {

                ViewBag.SchoolList = SchoolClass.getSchoolList(context);
                GetGameList getGameList = new GetGameList(context);
                ViewBag.GameList = getGameList.getGameTypeList();
            }
            return View();
        }

        [HttpPost]
        public ActionResult CreateEvent(Sport_Event sportEventDetails)
        {
            if (ModelState.IsValid)
            {
                using (var context = new StripeEntities())
                {
                    int id = Convert.ToInt32(Session["loginid"]);

                    SchoolClass schoolRecord = new SchoolClass(context);
                    sportEventDetails.School_Home_sch_ID = schoolRecord.getSchoolDetailsFromDirector(id).sch_ID;

                    if (sportEventDetails.School_Away_sch_ID == sportEventDetails.School_Home_sch_ID)
                    {
                        ModelState.AddModelError("", "Cannot select same away and home team");
                        return View();
                    }
                    else
                    {
                        sportEventDetails.event_Completion = "N";
                        context.Sport_Event.Add(sportEventDetails);
                        context.SaveChanges();
                        return RedirectToAction("Home");
                    }
                }
            }
            else
            {
                return View("Error");
            }
        }

        public ActionResult ViewEvents()
        {
            using (var context = new StripeEntities())
            {
                int id = Convert.ToInt32(Session["loginid"]);

                SchoolClass schoolRecord = new SchoolClass(context);
                var schoolDetails = schoolRecord.getSchoolDetailsFromDirector(id);

                var eventList = context.SP_GET_EVENT_BY_SCHOOLID(schoolDetails.sch_ID).ToList();
                return View(eventList);
            }
        }


        public ActionResult MoreDetails(int eventId)
        {
            using (var context = new StripeEntities())
            {
                Event getEventDetails = new Event(context);
                var eventDetails = getEventDetails.GetEventByEventId(eventId)
                    .SingleOrDefault();

                return View(eventDetails);
            }
        }

        public ActionResult ViewApplications(int eventId)
        {
            using (var context = new StripeEntities())
            {
                var eventDetails = context.SP_GET_APPLICATION_STATUS_BY_EVENTID(eventId).ToList();

                return View(eventDetails);
            }
        }

    }
}
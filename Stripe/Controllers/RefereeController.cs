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
                    UserProfile userProfile = new UserProfile();
                    int id = Convert.ToInt32(Session["loginid"]);
                    var refereeProfile = userProfile.getUserProfile(id, context);
                    GetGameList getGameList = new GetGameList(context);
                    ViewBag.GameList = getGameList.getGameTypeList();
                    if (refereeProfile != null)
                        ViewBag.RefList = getGameList.getRefTypeList(refereeProfile.Sport_Name_spt_Sport_Name_ID);
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

                    context.SP_USER_PROFILE_REFEREE_UPDATE(refProfile.ref_Game_Specialization_Type,
                        refProfile.userProfile_ID,
                        refProfile.Sport_Name_spt_Sport_Name_ID);
                    context.SaveChanges();

                }
                else
                {
                    //Inserting Profile
                    userProfile.UserProfileInsert(context, refProfile);

                    context.SP_USER_PROFILE_REFEREE_INSERT(refProfile.ref_Game_Specialization_Type,
                        refProfile.userProfile_ID,
                        refProfile.Sport_Name_spt_Sport_Name_ID);
                    context.SaveChanges();
                }

                return RedirectToAction("Profile");
            }
        }


        public PartialViewResult GetRefList(int GameCode)
        {
            using (var context = new StripeEntities())
            {
                GetGameList getRefList = new GetGameList(context);
                ViewBag.RefList = getRefList.getRefTypeList(GameCode);
                return PartialView("_RefList");
            }
        }

        public ActionResult AllEvents()
        {
            using (var context = new StripeEntities())
            {
                UserProfile userProfile = new UserProfile();
                int id = Convert.ToInt32(Session["loginid"]);
                var refereeProfile = userProfile.getUserProfile(id, context);
                Event allEvents = new Event(context);
                var allEventsList = allEvents.GetAllEvents("N")
                    .Where(sptId => sptId.Sport_Name_spt_Sport_Name_ID == refereeProfile.Sport_Name_spt_Sport_Name_ID)
                    .ToList();
                return View(allEventsList);
            }
        }



        public ActionResult Apply(int eventId)
        {
            using (var context = new StripeEntities())
            {
                int refereeId = Convert.ToInt32(Session["loginid"]);
                EventReferee eventReferee = new EventReferee(context);
                if (eventReferee.CheckRefereeEligibilityForApplication(eventId, refereeId))
                {
                    Event allEvents = new Event(context);
                    var eventDetails = allEvents.GetEventByEventId(eventId).SingleOrDefault();
                    GetGameList getRefList = new GetGameList(context);
                    ViewBag.RefereeList = getRefList.getRefTypeList(eventDetails.Sport_Name_spt_Sport_Name_ID);
                    return View(eventDetails);
                }
                else
                {
                    ViewBag.ErrorMessage = "You've already applied for this event. Please wait for any further notification.";
                    return View("Error");
                }
            }
        }

        [HttpPost]
        public ActionResult Apply(FormCollection formCollection)
        {
            using (var context = new StripeEntities())
            {
                int eventId = Convert.ToInt32(formCollection["event_ID"]);
                int refereeType = Convert.ToInt32(formCollection["ref_Game_Specialization_Type"]);
                int homeSchoolId = Convert.ToInt32(formCollection["School_Home_sch_ID"]);
                int refereeId = Convert.ToInt32(Session["loginid"]);

                SchoolClass schoolRecord = new SchoolClass(context);
                var schoolDetails = schoolRecord.GetDirectorIdFromSchoolId(homeSchoolId);

                context.SP_EVENT_REFEREE_APPLY(eventId, refereeId, schoolDetails.User_Profile_Director_Profile_ID, "P", refereeType);
                context.SaveChanges();

                return RedirectToAction("AllEvents");
            }
        }

        public ActionResult RequestStatus()
        {
            using (var context = new StripeEntities())
            {
                int refereeId = Convert.ToInt32(Session["loginid"]);

                var requestStatus = context.SP_GET_APPLICATION_STATUS_BY_REFEREEID(refereeId).ToList();

                return View(requestStatus);
            }
        }
    }
}
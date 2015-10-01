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
                var schoolDetails = SchoolClass.getSchoolDetailsFromDirector(id, context);
                return View("SchoolDetails", schoolDetails);
            }
        }

        [HttpPost]
        public ActionResult SchoolDetails(SP_GET_SCHOOL_DETAILS_FROM_DIRECTOR_Result schoolDetails)
        {
            using (var context = new StripeEntities())
            {
                SchoolClass schoolClass = new SchoolClass();
                var schoolRecord = SchoolClass.getSchoolDetailsFromDirector(schoolDetails.User_Profile_Director_Profile_ID, context);
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

        public ActionResult Create()
        {
            using (var context = new StripeEntities())
            {
                
                ViewBag.SchoolList = SchoolClass.getSchoolList(context);
                ViewBag.GameList = GetGameList.getGameTypeList(context);
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
                    sportEventDetails.School_Home_sch_ID = SchoolClass.getSchoolDetailsFromDirector(id, context).sch_ID;
                    if (sportEventDetails.School_Away_sch_ID == sportEventDetails.School_Home_sch_ID)
                    {
                        ModelState.AddModelError("", "Cannot select same away and home team");
                        return View();
                    }
                    else
                    {
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
    }
}
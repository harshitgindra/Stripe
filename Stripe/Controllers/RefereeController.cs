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
                    ViewBag.GameList = GetGameList.getGameTypeList(context);
                    if (refereeProfile != null)
                        ViewBag.RefList = GetGameList.getRefTypeList(context, refereeProfile.Sport_Name_spt_Sport_Name_ID);
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
                ViewBag.RefList = GetGameList.getRefTypeList(context, GameCode);
                return PartialView("_RefList");
            }
        }
    }
}
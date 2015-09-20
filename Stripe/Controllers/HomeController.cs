using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Stripe.Models;

namespace Stripe.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            using (var context = new StripeEntities())
            {
                ViewBag.UserTypeList = getUserTypeList(context);
            }
            return View();
        }

        public List<SelectListItem> getUserTypeList(StripeEntities context)
        {
            List<SelectListItem> userTypeList = new List<SelectListItem>();
            userTypeList.Add(new SelectListItem() { Text = "Please select User Type", Value = "default" });
            var result = context.User_Type.ToList();
            foreach (var item in result)
            {
                userTypeList.Add(new SelectListItem() { Text = item.userType_Name, Value = item.userType_ID });
            }
            return userTypeList;
        }

        [HttpPost]
        public ActionResult Login(Login login)
        {
            using (var context = new StripeEntities())
            {
                var loginCheck = context.Logins.Where(check => check.login_username == login.login_username && check.login_password == login.login_password).Single();
                if (loginCheck == null)
                {
                    return View("Error");
                }
                else
                {
                    switch (loginCheck.User_Type_userType_ID)
                    {
                        case "R":
                            return RedirectToAction("Home", "Refree", new { id = loginCheck.login_ID });
                            break;
                        case "S":
                            return RedirectToAction("Home", "School", new { id = loginCheck.login_ID });
                            break;
                        case "A":
                            return RedirectToAction("Home", "Admin", new { id = loginCheck.login_ID });
                            break;
                        default:
                            return RedirectToAction("Index", "Home");
                            break;
                    }
                }
            }
        }

        [HttpPost]
        public ActionResult SignUp(Login login)
        {
            using (var context = new StripeEntities())
            {
                context.Logins.Add(login);
                context.SaveChanges();
                return View();
            }
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}
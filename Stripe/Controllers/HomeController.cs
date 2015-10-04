using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Stripe.Models;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Web.Security;

namespace Stripe.Controllers
{
    public class HomeController : Controller
    {


        public ActionResult Index()
        {
            using (var context = new StripeEntities())
            {
                Session["loginid"] = null;
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
                var loginCheck = context.SP_LOGIN(login.login_username, login.login_password).SingleOrDefault();
                if (loginCheck == null)
                {
                    ModelState.AddModelError("", "Log in credentials invalid");
                    return View(login);
                }
                else
                {
                    FormsAuthentication.SetAuthCookie(loginCheck.login_username, false);
                    Session["loginid"] = loginCheck.login_ID;
                    switch (loginCheck.User_Type_userType_ID)
                    {
                        case "R":
                            return RedirectToAction("Home", "Referee");
                            break;
                        case "S":
                            return RedirectToAction("Home", "Director");
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
                EncryptDecrypt encrypt = new EncryptDecrypt();
                login.login_random_string = encrypt.Encrypt(login.login_username, "r0b1nr0y");

                context.Logins.Add(login);
                context.SaveChanges();

                return View("SignUpConfirmation");
            }
        }

        public ActionResult SignOut()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Home");
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
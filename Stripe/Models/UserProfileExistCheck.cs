using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Stripe.Models
{
    public class UserProfileExistCheck
    {

        public bool UserProfileExistence(int id, StripeEntities context)
        {
            var profile = context.User_Profile.Where(loginid => loginid.userProfile_ID == id).SingleOrDefault();
            if (profile == null)
                return false;
            else
                return true;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Stripe.Models
{
    public class UserProfile
    {

        public SP_USER_PROFILE_GET_Result getUserProfile(int id, StripeEntities context)
        {
            return context.SP_USER_PROFILE_GET(id).SingleOrDefault();
        }

        public bool UserProfileUpdate(StripeEntities context, User_Profile refProfile)
        {
            try
            {
                context.SP_USER_PROFILE_UPDATE(refProfile.userProfile_ID,
                       refProfile.userProfile_First_Name,
                       refProfile.userProfile_Last_Name,
                       refProfile.userProfile_Email,
                       refProfile.userProfile_Phone,
                       refProfile.userProfile_Street,
                       refProfile.userProfile_City,
                       refProfile.userProfile_State,
                       refProfile.userProfile_Zip,
                       refProfile.userProfile_Photo,
                       refProfile.userProfile_Background_Description);
                context.SaveChanges();
                return true;
            }
            catch (Exception exception)
            {
                return false;
            }
        }

        public bool UserProfileInsert(StripeEntities context, User_Profile refProfile)
        {
            try
            {
                context.SP_USER_PROFILE_INSERT(refProfile.userProfile_ID,
                        refProfile.userProfile_First_Name,
                        refProfile.userProfile_Last_Name,
                        refProfile.userProfile_Email,
                        refProfile.userProfile_Phone,
                        refProfile.userProfile_Street,
                        refProfile.userProfile_City,
                        refProfile.userProfile_State,
                        refProfile.userProfile_Zip,
                        refProfile.userProfile_Photo,
                        refProfile.userProfile_Background_Description,
                        refProfile.userProfile_ID);

                context.SaveChanges();
                return true;
            }
            catch (Exception exception)
            {
                return false;
            }

        }
    }
}
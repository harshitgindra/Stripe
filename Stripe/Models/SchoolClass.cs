using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Models
{
    public class SchoolClass
    {
        public static SP_GET_SCHOOL_DETAILS_FROM_DIRECTOR_Result getSchoolDetailsFromDirector(int id, StripeEntities context)
        {
            return context.SP_GET_SCHOOL_DETAILS_FROM_DIRECTOR(id).SingleOrDefault();
        }

        public bool InsertUpdateSchoolRecords(bool insertUpdate, StripeEntities context, SP_GET_SCHOOL_DETAILS_FROM_DIRECTOR_Result schoolDetails)
        {
            try
            {
                if (insertUpdate)
                {
                    context.SP_SCHOOL_DETAILS_INSERT(schoolDetails.sch_Name,
                        schoolDetails.sch_Street,
                        schoolDetails.sch_City,
                        schoolDetails.sch_State,
                        schoolDetails.sch_Zip,
                        schoolDetails.sch_Logo,
                        schoolDetails.User_Profile_Director_Profile_ID);
                }
                else
                {
                    //update queries
                    context.SP_SCHOOL_DETAILS_UPDATE(schoolDetails.sch_Name, 
                        schoolDetails.sch_Street, 
                        schoolDetails.sch_City, 
                        schoolDetails.sch_State, 
                        schoolDetails.sch_Zip, 
                        schoolDetails.sch_Logo, 
                        schoolDetails.User_Profile_Director_Profile_ID);
                }
                context.SaveChanges();
                return true;
            }
            catch (Exception exception)
            {
                Console.Write(exception.Message);
                return false;
            }
           
        }

        public static List<SelectListItem> getSchoolList(StripeEntities context)
        {
            List<SelectListItem> RefList = new List<SelectListItem>();
            var schoolList = context.Schools.ToList();
            foreach (var schoolDetails in schoolList)
            {
                RefList.Add(new SelectListItem() { Text = schoolDetails.sch_Name, Value = schoolDetails.sch_ID.ToString() });
            }
            return RefList;
        }

        
    }
}
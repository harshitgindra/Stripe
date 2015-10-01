using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Stripe.Models
{
    public class GetGameList
    {
        public static List<SelectListItem> getGameTypeList(StripeEntities context)
        {
            List<SelectListItem> GameNameList = new List<SelectListItem>();
            GameNameList.Add(new SelectListItem() { Text = "Please select Game", Value = "default" });
            var result = context.Sport_Name.ToList();
            foreach (var item in result)
            {
                GameNameList.Add(new SelectListItem() { Text = item.spt_Name, Value = item.spt_Sport_Name_ID.ToString() });
            }
            return GameNameList;
        }

        public static List<SelectListItem> getRefTypeList(StripeEntities context, int GameID)
        {
            List<SelectListItem> RefList = new List<SelectListItem>();            
            var result = context.Sport_Type_Referees.Where(sportID=>sportID.Sport_Name_spt_Sport_Name_ID==GameID).ToList();
            foreach (var item in result)
            {
                RefList.Add(new SelectListItem() { Text = item.sptTypeRef_Referee_Title, Value = item.sptTypeRef_ID.ToString() });
            }
            return RefList;
        }
    }
}
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Stripe.Models
{
    using System;
    
    public partial class SP_GET_ALL_EVENTS_Result
    {
        public int event_ID { get; set; }
        public System.DateTime event_Date { get; set; }
        public System.TimeSpan event_Time { get; set; }
        public string event_School_Field_Name { get; set; }
        public Nullable<int> event_Home_Team_Score { get; set; }
        public Nullable<int> event_Away_Team_Score { get; set; }
        public string event_Completion { get; set; }
        public string spt_Name { get; set; }
        public int Sport_Name_spt_Sport_Name_ID { get; set; }
        public int School_Away_sch_ID { get; set; }
        public int School_Home_sch_ID { get; set; }
        public string HomeTeamName { get; set; }
        public string AwayTeamName { get; set; }
    }
}

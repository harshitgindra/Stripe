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
    using System.Collections.Generic;
    
    public partial class Referee_Status
    {
        public Referee_Status()
        {
            this.Referee_Event_History = new HashSet<Referee_Event_History>();
        }
    
        public string refStatus_ID { get; set; }
        public string refStatus_Description { get; set; }
    
        public virtual ICollection<Referee_Event_History> Referee_Event_History { get; set; }
    }
}
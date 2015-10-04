using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Stripe.Models
{
    public class EventReferee
    {
        private StripeEntities context { get; set; }

        public EventReferee(StripeEntities context)
        {
            this.context = context;
        }

        public bool CheckRefereeEligibilityForApplication(int eventId, int refereeId)
        {
            var refereeRecord = context.SP_EVENT_REFEREE_VERIFY_ELIGIBILITY(eventId, refereeId).ToList();
            if (refereeRecord.Count == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
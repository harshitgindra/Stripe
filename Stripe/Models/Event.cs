using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Stripe.Models
{
    public class Event
    {
        public Event(StripeEntities context)
        {
            this.context = context;
        }

        public IQueryable<SP_GET_ALL_EVENTS_Result> GetAllEvents(string eventCompletion)
        {
            return context.SP_GET_ALL_EVENTS(eventCompletion).AsQueryable();
        }

        public IQueryable<SP_GET_EVENT_BY_EVENTID_Result> GetEventByEventId(int eventId)
        {
            return context.SP_GET_EVENT_BY_EVENTID(eventId).AsQueryable();
        }

        public bool UpdateEventScores(SP_GET_EVENT_BY_EVENTID_Result eventScores)
        {
            try
            {
                context.SP_EVENT_SCORES_UPDATE(eventScores.event_Home_Team_Score,
                    eventScores.event_Away_Team_Score,
                    "Y",
                    eventScores.event_ID);
                context.SaveChanges();
                return true;
            }
            catch (Exception exception)
            {
                Console.Write(exception.Message);
                return false;
            }

        }

        private StripeEntities context { get; set; }
    }
}
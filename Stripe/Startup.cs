using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Stripe.Startup))]
namespace Stripe
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}

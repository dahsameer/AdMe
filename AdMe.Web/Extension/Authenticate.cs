using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Routing;

namespace AdMe.Web.Extension
{
    public class Authenticate : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            string user = filterContext.HttpContext.Session.GetString("User");
            if (string.IsNullOrEmpty(user))
            {
                filterContext.Result = new RedirectToRouteResult(
                    new RouteValueDictionary {
                                { "Controller", "Account" },
                                { "Action", "Login" }
                    });
            }
        }
    }
}

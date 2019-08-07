using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model.User;
using AdMe.Repository.Account;
using AdMe.Model.StaticModel;
using Microsoft.AspNetCore.Mvc;
using AdMe.Shared.Helpers.StaticSecurity;
using Microsoft.AspNetCore.Http;
using AdMe.Shared.Helpers.StaticData;
using AdMe.Web.Extension;

namespace AdMe.Web.Controllers
{
    public class AccountController : Controller
    {
        private readonly IAccountService _accountService;
        public AccountController(IAccountService accountService)
        {
            _accountService = accountService;
        }

        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Register(UserRegisterViewModel model)
        {
            model.Password = SHA512Hash.GenerateSHA512String(model.Password);
            DbResponse response = _accountService.AddUser(model);
            if(response == null)
            {
                ViewBag.Response = "Unknown Error";
            }
            else if(response.ResponseCode == 100)
            {
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.Response = response.ResponseMessage;
            }
            return View(model);
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Login(UserLoginViewModel model)
        {
            model.Password = SHA512Hash.GenerateSHA512String(model.Password);
            DbResponse response = _accountService.CheckUser(model);
            if(response == null)
            {
                ViewBag.Response = "Unknown Error";
            }
            else if(response.ResponseCode == 100)
            {
                HttpContext.Session.SetString("User", model.Username);
                HttpContext.Session.SetString("SessionId", RandomStringGenerator.GenerateString());
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.Response = response.ResponseMessage;
            }
            return View(model);
        }

        [Authenticate]
        public IActionResult Logout(string id)
        {
            string sessionId = HttpContext.Session.GetString("SessionId");
            if(sessionId == id)
            {
                HttpContext.Session.Remove("User");
                HttpContext.Session.Remove("SessionId");
                return Redirect("Login");
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }
    }
}
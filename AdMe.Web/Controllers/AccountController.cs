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
        public async Task<IActionResult> Register(UserRegisterViewModel model)
        {
            model.Password = SHA512Hash.GenerateSHA512String(model.Password);
            DbResponse response = await _accountService.AddUser(model);
            if(response == null)
            {
                ViewBag.Response = "Unknown Error";
            }
            else if(response.Code == 100)
            {
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.Response = response.Message;
            }
            return View(model);
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(UserLoginViewModel model)
        {
            DbResponse response = await _accountService.CheckUser(model);
            if(response == null)
            {
                ViewBag.Response = "Unknown Error";
            }
            else if(response.Code == 100)
            {
                HttpContext.Session.SetString("User", model.Username);
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.Response = response.Message;
            }
            return View(model);
        }
    }
}
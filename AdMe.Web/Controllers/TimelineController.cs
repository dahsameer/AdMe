using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using AdMe.Repository.Account;
using AdMe.Web.Extension;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AdMe.Web.Controllers
{
    public class TimelineController : Controller
    {
        private readonly IAccountService _accountService;

        public TimelineController(IAccountService accountService)
        {
            _accountService = accountService;
        }

        [Authenticate]
        [Route("/user/{username}")]
        public IActionResult Index(string username)
        {
            HttpContext.Session.Remove("PostList");
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Authenticate]
        [Route("/user/{username}/about")]
        public IActionResult About(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Authenticate]
        [Route("/user/{username}/followers")]
        public IActionResult Followers(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Authenticate]
        [Route("/user/{username}/following")]
        public IActionResult Following(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Authenticate]
        [HttpGet]
        public IActionResult GetFollowButtonText(int userId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _accountService.GetFollowButtonText(userId, username);
            return Ok(response);
        }

        [Authenticate]
        [HttpPost]
        public IActionResult ToggleButton(int userId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _accountService.ToggleFollow(userId, username);
            return Ok(response);
        }

        [Authenticate]
        [HttpGet]
        public IActionResult GetFollowers(int UserId)
        {
            List<UserProfile> users = _accountService.GetFollowers(UserId);
            return Ok(users);
        }

        [Authenticate]
        [HttpGet]
        public IActionResult GetFollowings(int UserId)
        {
            List<UserProfile> users = _accountService.GetFollowings(UserId);
            return Ok(users);
        }

        [Authenticate]
        public IActionResult Edit()
        {
            string username = HttpContext.Session.GetString("User");
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Authenticate]
        [HttpPost]
        public IActionResult Edit(UserProfile model)
        {
            string username = HttpContext.Session.GetString("User");
            if(model.Photofile != null)
            {
                long size = model.Photofile.Length;

                var filePath = "A:\\codes\\AdMe\\AdMe.Web\\wwwroot\\AppData\\" + username + ".jpg";
                if (model.Photofile.Length > 0)
                {
                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        model.Photofile.CopyTo(stream);
                    }
                }
                model.Photo = "/AppData/" + username + ".jpg";
            }
            model.Username = username;
            DbResponse response = _accountService.UpdateUser(model);
            if(response.ResponseCode != 100)
            {
                ViewBag.Error = response.ResponseMessage;
            }
            return View(model);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using AdMe.Repository.Account;
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

        [Route("/user/{username}")]
        public IActionResult Index(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Route("/user/{username}/about")]
        public IActionResult About(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Route("/user/{username}/followers")]
        public IActionResult Followers(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [Route("/user/{username}/following")]
        public IActionResult Following(string username)
        {
            UserProfile user = _accountService.GetUserProfile(username);
            return View(user);
        }

        [HttpGet]
        public IActionResult GetFollowButtonText(int userId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _accountService.GetFollowButtonText(userId, username);
            return Ok(response);
        }

        [HttpPost]
        public IActionResult ToggleButton(int userId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _accountService.ToggleFollow(userId, username);
            return Ok(response);
        }

        [HttpGet]
        public IActionResult GetFollowers(int UserId)
        {
            List<UserProfile> users = _accountService.GetFollowers(UserId);
            return Ok(users);
        }

        [HttpGet]
        public IActionResult GetFollowings(int UserId)
        {
            List<UserProfile> users = _accountService.GetFollowings(UserId);
            return Ok(users);
        }
    }
}
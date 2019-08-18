using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AdMe.Web.Models;
using AdMe.Web.Extension;
using AdMe.Repository.Post;
using AdMe.Repository.Account;
using Microsoft.AspNetCore.Http;
using AdMe.Model.Others;
using AdMe.Model.Post;
using AdMe.Model.User;

namespace AdMe.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly IAccountService _accountService;
        private readonly IPostService _postService;
        public HomeController(IPostService postService, IAccountService accountService)
        {
            _accountService = accountService;
            _postService = postService;
        }

        [Authenticate]
        public IActionResult Index()
        {
            HttpContext.Session.Remove("PostList");
            return View();
        }

        [Authenticate]
        public IActionResult Search(string content)
        {
            string username = HttpContext.Session.GetString("User");
            var searchPostsid = _postService.SearchPost(content, username);
            var searchPeopleid = _accountService.SearchPeople(content, username);
            List<PostModel> posts = new List<PostModel>();
            List<UserProfile> users = new List<UserProfile>();
            foreach(var post in searchPostsid)
            {
                posts.Add(_postService.GetPostById(post, false, username));
            }
            foreach (var user in searchPeopleid)
            {
                users.Add(_accountService.GetUserProfile(user));
            }
            Search search = new Search
            {
                users = users,
                posts = posts
            };
            return View(search);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

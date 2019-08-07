using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model.Post;
using AdMe.Model.StaticModel;
using AdMe.Repository.Post;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace AdMe.Web.Controllers
{
    public class PostController : Controller
    {
        private readonly IPostService _postService;

        public PostController(IPostService postService)
        {
            _postService = postService;
        }

        [HttpGet]
        public IActionResult Read(string id)
        {
            return View();
        }

        [HttpPost]
        public IActionResult AddPost(string postContent)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _postService.AddPost(postContent, username);
            if(response == null)
            {
                return StatusCode(500, response.ResponseMessage);
            }
            else
            {
                return Ok(response.ResponseId);
            }
        }

        [HttpGet]
        public JsonResult GetNewsfeedPost(string previousPost)
        {
            if(previousPost == null)
            {
                List<string> postList = _postService.GetPosts(HttpContext.Session.GetString("User"));
                string postIdSerialized = JsonConvert.SerializeObject(postList);
                HttpContext.Session.SetString("PostList", postIdSerialized);
                return Json(postList.GetRange(0, 5 > postList.Count ? postList.Count : 5));
            }
            else
            {
                List<string> postList = JsonConvert.DeserializeObject<List<string>>(HttpContext.Session.GetString("PostList"));
                return Json(postList.GetRange(postList.IndexOf(previousPost), postList.IndexOf(previousPost)+5 > postList.Count ? postList.Count-1 - postList.IndexOf(previousPost) : 5));
            }
        }

        [HttpGet]
        public IActionResult GetPostById(string postId, bool allReply = false)
        {
            PostModel post = _postService.GetPostById(postId, allReply);
            if (post != null || post.ResponseCode==100)
            {
                return Ok(post);
            }
            return NotFound(post);
        }

        [HttpPost]
        public IActionResult AddReply(string ReplyData, string parentId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _postService.AddPost(ReplyData, username);
            if (response == null)
            {
                return StatusCode(500, response.ResponseMessage);
            }
            else
            {
                return Ok(response.ResponseId);
            }
        }
    }
}
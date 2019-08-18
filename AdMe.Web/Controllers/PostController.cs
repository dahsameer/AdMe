using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model.Post;
using AdMe.Model.StaticModel;
using AdMe.Repository.Post;
using AdMe.Web.Extension;
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

        [Authenticate]
        [Route("/post/{id}")]
        [HttpGet]
        public IActionResult Index(string id)
        {
            if (id == null)
            {
                return RedirectToAction("Index", "Home");
            }
            string username = HttpContext.Session.GetString("User");
            var post = _postService.GetPostById(id, true, username);
            if(post == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View(post);
        }

        [Authenticate]
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

        [Authenticate]
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
                return Json(postList.GetRange(postList.IndexOf(previousPost)+1, postList.IndexOf(previousPost)+6 > postList.Count ? postList.Count-1 - postList.IndexOf(previousPost) : 5));
            }
        }

        [Authenticate]
        [HttpGet]
        public IActionResult GetPostById(string postId, bool allReply = false)
        {
            string username = HttpContext.Session.GetString("User");
            PostModel post = _postService.GetPostById(postId, allReply, username);
            List<PostAlgorithmModel> postList = _postService.GetPostsApi(HttpContext.Session.GetString("User"));
            var fullp = postList.Where(x => x.PostId == post.PostId).FirstOrDefault();
            if(fullp!= null)
            {
                post.AffinityScore = fullp.AffinityScore;
                post.Epsilon = fullp.Epsilon;
                post.Gamma = fullp.Gamma;
                post.Interacted = fullp.Interacted;
                post.PostWeight = fullp.PostWeight;
                post.TimeDecay = fullp.TimeDecay;
            }
            if (post != null || post.ResponseCode==100)
            {
                return Ok(post);
            }
            return NotFound(post);
        }

        [Authenticate]
        [HttpPost]
        public IActionResult AddReply(string ReplyData, string parentId)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _postService.AddReply (ReplyData, username, parentId);
            if (response == null)
            {
                return StatusCode(500, response.ResponseMessage);
            }
            else
            {
                return Ok(response.ResponseId);
            }
        }

        [Authenticate]
        [HttpGet]
        public JsonResult GetTimelinePosts(int user, string previousPost)
        {
            string username = HttpContext.Session.GetString("User");
            if (previousPost == null)
            {
                List<string> postList = _postService.GetTimelinePosts(user, username);
                string postIdSerialized = JsonConvert.SerializeObject(postList);
                HttpContext.Session.SetString("PostList", postIdSerialized);
                return Json(postList.GetRange(0, 5 > postList.Count ? postList.Count : 5));
            }
            else
            {
                List<string> postList = JsonConvert.DeserializeObject<List<string>>(HttpContext.Session.GetString("PostList"));
                return Json(postList.GetRange(postList.IndexOf(previousPost), postList.IndexOf(previousPost) + 5 > postList.Count ? postList.Count - 1 - postList.IndexOf(previousPost) : 5));
            }
        }

        [Authenticate]
        [HttpPost]
        public IActionResult ToggleLike(string postid)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _postService.ToggleLike(postid, username);
            return Ok(response);
        }

        [Authenticate]
        public IActionResult PostApi()
        {
            List<PostAlgorithmModel> postList = _postService.GetPostsApi(HttpContext.Session.GetString("User"));
            return View(postList);
        }

        [Authenticate]
        public IActionResult Delete(string id)
        {
            string username = HttpContext.Session.GetString("User");
            DbResponse response = _postService.DeletePost(id, username);
            if(response.ResponseCode == 100)
            {
                ViewBag.Message = "Successfully deleted post";
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.Message = "Couldn't delete post";
                var post = _postService.GetPostById(id, true, username);
                if (post == null)
                {
                    return RedirectToAction("Index", "Home");
                }
                return View(post);
            }
        }
    }
}
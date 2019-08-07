using AdMe.Model.Post;
using AdMe.Model.StaticModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace AdMe.Repository.Post
{
    public interface IPostService
    {
        DbResponse AddPost(string postContent, string username);
        List<string> GetPosts(string username);
        PostModel GetPostById(string postId, bool allReplies);
    }
}

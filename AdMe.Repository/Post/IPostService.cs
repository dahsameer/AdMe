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
        DbResponse AddReply(string postContent, string username, string parentId);
        List<string> GetPosts(string username);
        PostModel GetPostById(string postId, bool allReplies, string username);
        List<string> GetTimelinePosts(int userid, string username);
        DbResponse ToggleLike(string postid, string username);
        List<PostAlgorithmModel> GetPostsApi(string username);
        List<string> SearchPost(string content, string username);
        DbResponse DeletePost(string id, string username);
    }
}

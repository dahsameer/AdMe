using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using AdMe.Model.Post;
using AdMe.Model.StaticModel;
using AdMe.Shared.Helpers.Algorithm;
using AdMe.Shared.Helpers.StaticData;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace AdMe.Repository.Post
{
    public class PostService : IPostService
    {
        private readonly IConfiguration _config;
        private readonly string _connectionString;
        private readonly IDbConnection _connection;

        public PostService(IConfiguration config)
        {
            _config = config;
            _connectionString = _config.GetConnectionString("DefaultConnection");
            _connection = new SqlConnection(_connectionString);
        }

        public DbResponse AddPost(string postContent, string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "AddPost",
                Username = username,
                PostContent = postContent,
                PostId = GetNewPostId(),
                PostKeywords = string.Join(',',EdgerankImplementation.keywordsExtraction(postContent))
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }

        public DbResponse AddReply(string postContent, string username, string parentId)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "AddReply",
                Username = username,
                PostContent = postContent,
                PostId = GetNewPostId(),
                ParentPostId = parentId,
                PostKeywords = string.Join(',', EdgerankImplementation.keywordsExtraction(postContent.ToLower()))
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }

        public List<string> GetPosts(string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "GetPost",
                Username = username
            };
            List<PostAlgorithmModel> posts = _connection.Query<PostAlgorithmModel>(procedure, param, commandType: CommandType.StoredProcedure).AsList<PostAlgorithmModel>();
            var param2 = new
            {
                Flag = "GetKeywords",
                Username = username
            };
            List<string> allKeywords = _connection.Query<string>(procedure, param2, commandType: CommandType.StoredProcedure).AsList<string>();
            List<PostAlgorithmModel> sorted = EdgerankImplementation.SortPost(posts, allKeywords);
            return sorted.Select(x => x.PostId).ToList();
        }

        public List<string> GetTimelinePosts(int userid, string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "GetTimelinePost",
                UserId = userid,
                Username = username
            };
            List<string> posts = _connection.Query<string>(procedure, param, commandType: CommandType.StoredProcedure).AsList<string>();
            return posts;
        }

        private string GetNewPostId()
        {
            string procedure = "PostProcedure";
            string PostId;
            do
            {
                PostId = RandomStringGenerator.GenerateString(20, RandomStringGenerator.RandomStringType.NUMERIC);
                var param = new
                {
                    Flag = "CheckPostId",
                    PostId = PostId
                };
                DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
                if (response.ResponseCode == 100)
                {
                    break;
                }
            } while (true);
            return PostId;
        }

        public PostModel GetPostById(string postId, bool allReplies, string username)
        {
            string procedure = "PostProcedure";
            var param1 = new
            {
                Flag = "GetPostById",
                PostId = postId,
                Username = username
            };
            PostModel post = _connection.QueryFirstOrDefault<PostModel>(procedure, param1, commandType: CommandType.StoredProcedure);

            var param2 = new
            {
                Flag = "GetRepliesForPost",
                PostId = post.PostId,
                AllReplies = allReplies
            };
            List<PostModel> replies = _connection.Query<PostModel>(procedure, param2, commandType: CommandType.StoredProcedure).AsList<PostModel>();
            foreach (var reply in replies)
            {
                post.Replies.Add(reply);
            }
            return post;
        }

        public DbResponse ToggleLike(string postid, string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "ToggleLike",
                Username = username,
                PostId = postid
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }

        public List<PostAlgorithmModel> GetPostsApi(string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "GetPost",
                Username = username
            };
            List<PostAlgorithmModel> posts = _connection.Query<PostAlgorithmModel>(procedure, param, commandType: CommandType.StoredProcedure).AsList<PostAlgorithmModel>();
            var param2 = new
            {
                Flag = "GetKeywords",
                Username = username
            };
            List<string> allKeywords = _connection.Query<string>(procedure, param2, commandType: CommandType.StoredProcedure).AsList<string>();
            List<PostAlgorithmModel> sorted = EdgerankImplementation.SortPost(posts, allKeywords);
            return sorted;
        }

        public List<string> SearchPost(string content, string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "Search",
                Search = content.ToLower(),
                Username = username
            };
            var sp = _connection.Query<string>(procedure, param, commandType: CommandType.StoredProcedure).ToList();
            return sp;
        }

        public DbResponse DeletePost(string id, string username)
        {
            string procedure = "PostProcedure";
            var param = new
            {
                Flag = "Delete",
                PostId = id,
                Username = username
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using AdMe.Model.Post;
using AdMe.Model.StaticModel;
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
                PostId = GetNewPostId()
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
                ParentPostId = parentId
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

        public PostModel GetPostById(string postId, bool allReplies)
        {
            string procedure = "PostProcedure";
            var param1 = new
            {
                Flag = "GetPostById",
                PostId = postId
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
    }
}

using AdMe.Model.StaticModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace AdMe.Model.Post
{
    public class PostModel : DbResponse
    {
        public PostModel()
        {
            Replies = new List<PostModel>();
        }
        public string PostId { get; set; }
        public string PostContent { get; set; }
        public string Username { get; set; }
        public string Fullname { get; set; }
        public DateTime PostedTime { get; set; }
        public List<PostModel> Replies{ get ;set; }
    }
}

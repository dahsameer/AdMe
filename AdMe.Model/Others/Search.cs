using AdMe.Model.Post;
using AdMe.Model.User;
using System;
using System.Collections.Generic;
using System.Text;

namespace AdMe.Model.Others
{
    public class Search
    {
        public List<PostModel> posts { get; set; }
        public List<UserProfile> users { get; set; }
    }
}

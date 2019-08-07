using System;
using System.Collections.Generic;
using System.Text;

namespace AdMe.Model.User
{
    public class UserProfile
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Fullname { get; set; }
        public string Email { get; set; }
        public DateTime DateOfBirth { get; set; }
        public DateTime JoinedDate { get; set; }
        public string About { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Gender { get; set; }
        public string Photo { get; set; }
    }
}

using AdMe.Model;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace AdMe.Repository.Account
{
    public interface IAccountService
    {
        DbResponse AddUser(UserRegisterViewModel model);
        DbResponse CheckUser(UserLoginViewModel model);
        UserProfile GetUserProfile(string username);
        DbResponse GetFollowButtonText(int userId, string username);
        DbResponse ToggleFollow(int userId, string username);
        List<UserProfile> GetFollowers(int UserId);
        List<UserProfile> GetFollowings(int UserId);
        DbResponse UpdateUser(UserProfile model);
        List<string> SearchPeople(string content, string username);
    }
}

using AdMe.Model;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using System.Threading.Tasks;

namespace AdMe.Repository.Account
{
    public interface IAccountService
    {
        DbResponse AddUser(UserRegisterViewModel model);
        DbResponse CheckUser(UserLoginViewModel model);
    }
}

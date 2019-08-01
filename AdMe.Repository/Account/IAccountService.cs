using AdMe.Model;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using System.Threading.Tasks;

namespace AdMe.Repository.Account
{
    public interface IAccountService
    {
        Task<DbResponse> AddUser(UserRegisterViewModel model);
        Task<DbResponse> CheckUser(UserLoginViewModel model);
    }
}

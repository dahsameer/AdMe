using System.Linq;
using System.Threading.Tasks;
using AdMe.Model;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using AdMe.Repository.Dapper;

namespace AdMe.Repository.Account
{
    public class AccountService : IAccountService
    {
        private IDapperService _dapperService;

        public AccountService(IDapperService dapperService)
        {
            _dapperService = dapperService;
        }

        public DbResponse AddUser(UserRegisterViewModel model)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "AddUser",
                Username = model.Username,
                Fullname = model.Fullname,
                Password = model.Password,
                DateOfBirth = model.DateOfBirth,
                Email = model.Email
            };
            var response = _dapperService.ExecuteQuery<DbResponse>(procedure, param);
            return response.FirstOrDefault();
        }

        public DbResponse CheckUser(UserLoginViewModel model)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "CheckUser",
                Username = model.Username,
                Password = model.Password
            };
            DbResponse response = _dapperService.ExecuteQuery<DbResponse>(procedure, param);
            return response;
        }
    }
}

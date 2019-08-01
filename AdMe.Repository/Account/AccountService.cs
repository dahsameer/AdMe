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

        public async Task<DbResponse> AddUser(UserRegisterViewModel model)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "AddUser",
                Username = model.Username,
                Fullname = model.Fullname,
                PasswordHash = model.Password,
                DateOfBirth = model.DateOfBirth,
                Email = model.Email
            };
            DbResponse response = await _dapperService.ExecuteNonListAsync<DbResponse>(procedure, param);
            return response;
        }

        public async Task<DbResponse> CheckUser(UserLoginViewModel model)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "CheckUser",
                Username = model.Username,
                Password = model.Password
            };
            DbResponse response = await _dapperService.ExecuteNonListAsync<DbResponse>(procedure, param);
            return response;
        }
    }
}

using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using AdMe.Model;
using AdMe.Model.StaticModel;
using AdMe.Model.User;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace AdMe.Repository.Account
{
    public class AccountService : IAccountService
    {
        private readonly IConfiguration _config;
        private readonly string _connectionString;
        private readonly IDbConnection _connection;

        public AccountService(IConfiguration config)
        {
            _config = config;
            _connectionString = _config.GetConnectionString("DefaultConnection");
            _connection = new SqlConnection(_connectionString);
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
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
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
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }
    }
}

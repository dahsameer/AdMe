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

        public UserProfile GetUserProfile(string username)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "GetUserProfile",
                Username = username
            };
            UserProfile user = _connection.QueryFirstOrDefault<UserProfile>(procedure, param, commandType: CommandType.StoredProcedure);
            return user;
        }

        public DbResponse GetFollowButtonText(int userId, string username)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "GetFollowButtonText",
                Username = username,
                UserId2 = userId
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }
        public DbResponse ToggleFollow(int userId, string username)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "ToggleFollow",
                Username = username,
                UserId2 = userId
            };
            DbResponse response = _connection.QueryFirstOrDefault<DbResponse>(procedure, param, commandType: CommandType.StoredProcedure);
            return response;
        }
        public List<UserProfile> GetFollowers(int UserId)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "GetFollowers",
                UserId1 = UserId
            };
            List<UserProfile> users = _connection.Query<UserProfile>(procedure, param, commandType: CommandType.StoredProcedure).AsList<UserProfile>();
            return users;
        }
        public List<UserProfile> GetFollowings(int UserId)
        {
            string procedure = "AccountProcedure";
            var param = new
            {
                Flag = "GetFollowings",
                UserId1 = UserId
            };
            List<UserProfile> users = _connection.Query<UserProfile>(procedure, param, commandType: CommandType.StoredProcedure).AsList<UserProfile>();
            return users;
        }
    }
}

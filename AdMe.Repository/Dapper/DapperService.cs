using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace AdMe.Repository.Dapper
{
    public class DapperService : IDapperService
    {
        private IConfiguration _config;
        private string _connectionString;

        public DapperService(IConfiguration config)
        {
            _config = config;
            _connectionString = _config.GetConnectionString("DefaultConnection");
        }

        private string GetConnectionString()
        {
            return _connectionString ?? "";
        }

        public List<T0> ExecuteQuery<T0>(string sqlQuery, object sqlParam, System.Data.CommandType queryType = System.Data.CommandType.StoredProcedure)
        {
            using (var sqlConnection = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    sqlConnection.Open();
                    var result = sqlConnection.QueryMultiple(sqlQuery, sqlParam, commandTimeout: 30000, commandType: queryType);
                    var res = result.Read<T0>().ToList();
                    return res;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    sqlConnection.Close();
                }
            }
        }

        public List<object> ExecuteQuery<T0, T1>(string sqlQuery, object sqlParam, System.Data.CommandType queryType = System.Data.CommandType.StoredProcedure)
        {
            using (var sqlConnection = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    sqlConnection.Open();
                    var result = sqlConnection.QueryMultiple(sqlQuery, sqlParam, commandTimeout: 30000, commandType: queryType);
                    var res = new List<object>();
                    res.Add(result.Read<T0>().ToList());
                    if (result.IsConsumed) return res;
                    res.Add(result.Read<T1>().ToList());
                    return res;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    sqlConnection.Close();
                }
            }
        }

        public List<object> ExecuteQuery<T0, T1, T2>(string sqlQuery, object sqlParam, System.Data.CommandType queryType = System.Data.CommandType.StoredProcedure)
        {
            using (var sqlConnection = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    sqlConnection.Open();
                    var result = sqlConnection.QueryMultiple(sqlQuery, sqlParam, commandTimeout: 30000, commandType: queryType);
                    var res = new List<object>();
                    res.Add(result.Read<T0>().ToList());
                    if (result.IsConsumed) return res;
                    res.Add(result.Read<T1>().ToList());
                    if (result.IsConsumed) return res;
                    res.Add(result.Read<T2>().ToList());
                    return res;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    sqlConnection.Close();
                }
            }
        }
    }
}

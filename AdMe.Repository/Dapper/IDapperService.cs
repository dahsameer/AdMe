using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace AdMe.Repository.Dapper
{
    public interface IDapperService
    {
        Task<T0> ExecuteNonListAsync<T0>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        T0 ExecuteNonList<T0>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        Task<List<T0>> ExecuteQueryAsync<T0>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        List<T0> ExecuteQuery<T0>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        Task<List<object>> ExecuteQueryAsync<T0, T1>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        List<object> ExecuteQuery<T0, T1>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        Task<List<object>> ExecuteQueryAsync<T0, T1, T2>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
        List<object> ExecuteQuery<T0, T1, T2>(string sqlQuery, object sqlParam, CommandType queryType = CommandType.StoredProcedure);
    }
}

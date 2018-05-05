using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace RMS_API.Data
{
    public class TrainRepository : BaseRepository<TrainRepository>, ITrainRepository
    {
        public TrainRepository(IConfiguration config, ILogger<TrainRepository> logger) : base(config, logger)
        {}

        public (IEnumerable<Object>, int) GetAll()
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM Show_Trains", sqlConnection))
                {
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return (null, 0);

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new
                {
                    Id = Convert.ToInt32(row[0]),
                    Name = row[1] as string,
                    Model = row[2] as string
                });

                return (result, count);
            }
            catch(Exception ex)
            {   
                if(ex is InvalidCastException)
                    logger.LogError($"ID is not an integer: {ex}");
                else
                    logger.LogError($"DB Connection Error: {ex}");
                throw;
            }
        }
    }
}

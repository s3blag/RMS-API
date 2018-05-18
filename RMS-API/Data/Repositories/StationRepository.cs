using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using RMS_API.Data.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace RMS_API.Data.Repositories
{
    public class StationRepository : BaseRepository<StationRepository>, IStationRepository
    {
        public StationRepository(IConfiguration config, ILogger<StationRepository> logger) : base(config, logger)
        { }

        public IEnumerable<StationDto> GetAll()
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM stations", sqlConnection))
                {
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new StationDto
                {
                    Id = Convert.ToInt32(row[0]),
                    Name = row[1] as string
                }).ToList();

                return result;
            }
            catch (Exception ex)
            {
                if (ex is InvalidCastException)
                    logger.LogError($"ID is not an integer: {ex}");
                else
                    logger.LogError($"DB Connection Error: {ex}");
                throw;
            }
        }
    }
}

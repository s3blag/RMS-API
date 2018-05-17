using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using RMS_API.Data.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace RMS_API.Data
{
    public class ReservationRepository : BaseRepository<ReservationRepository>, IReservationRepository
    {
        public ReservationRepository(IConfiguration configuration, ILogger<ReservationRepository> logger) : base(configuration, logger)
        {}

        public IEnumerable<ReservationDto> GetByCustomerId(int customerId)
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"EXEC SHOW_CUSTOMER_RESERVATION @customerID", sqlConnection))
                {
                    sqlDataAdapter.SelectCommand.Parameters.AddWithValue("@customerID", customerId);
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new ReservationDto
                {
                    Id = Convert.ToInt32(row[0]),
                    SeatNumber = Convert.ToInt32(row[1]),
                    CustomerId = customerId,
                    CourseId = Convert.ToInt32(row[2]),
                    StationA = row[3] as string,
                    StationB = row[4] as string,     
                });

                return result;
            }
            catch(Exception ex)
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

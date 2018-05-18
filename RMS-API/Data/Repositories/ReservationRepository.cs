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
                    FirstStation = row[3] as string,
                    LastStation = row[4] as string,     
                }).ToList();

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

        public (int, int) Add(ReservationForCreationDto reservation, int customerId)
        {
            try
            {
                int newId = -1;
                int seatNumber = -1;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlCommand = new SqlCommand($"EXEC ADD_RESERVATION @customerId, @price, @courseId," +
                                                       $" @firstStation, @lastStation, @seatNumber OUTPUT, @reservationId OUTPUT", sqlConnection))
                {
                    var seatNumberParameter = sqlCommand.Parameters.Add("@seatNumber", SqlDbType.Int);
                    var reservationIdParameter = sqlCommand.Parameters.Add("@reservationId", SqlDbType.Int);
                    seatNumberParameter.Direction = ParameterDirection.Output;
                    reservationIdParameter.Direction = ParameterDirection.Output;

                    sqlCommand.Parameters.AddWithValue("@customerId", customerId);
                    sqlCommand.Parameters.AddWithValue("@price", reservation.Price);
                    sqlCommand.Parameters.AddWithValue("@courseId", reservation.CourseId);
                    sqlCommand.Parameters.AddWithValue("@firstStation", reservation.FirstStation);
                    sqlCommand.Parameters.AddWithValue("@lastStation", reservation.LastStation);

                    sqlConnection.Open();

                    sqlCommand.ExecuteNonQuery();

                    newId = Convert.ToInt32(sqlCommand.Parameters["@reservationId"].Value);
                    seatNumber = Convert.ToInt32(sqlCommand.Parameters["@seatNumber"].Value);

                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }

                return (newId, seatNumber);

            }
            catch (Exception ex)
            {
                logger.LogInformation($"AddReservation DB Connection Error: {ex}");
                return (-1, -1);
            }
        }

    }
}

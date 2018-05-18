using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using RMS_API.Data.Models;

namespace RMS_API.Data.Repositories
{
    public class VisitRepository : BaseRepository<VisitRepository>, IVisitRepository
    {
        public VisitRepository(IConfiguration config, ILogger<VisitRepository> logger) : base(config, logger)
        { }

        public IEnumerable<VisitDto> GetAll(int courseId)
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"EXEC SHOW_COURSE_VISITS @courseId", sqlConnection))
                {
                    sqlDataAdapter.SelectCommand.Parameters.AddWithValue("@courseId", courseId);
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new VisitDto
                {
                    Id = Convert.ToInt32(row[0]),
                    CourseId = Convert.ToInt32(row[1]),
                    StationId = Convert.ToInt32(row[2]),
                    StationName = row[3] as string,
                    VisitOrder = Convert.ToInt32(row[4]),
                    Date = Convert.ToDateTime(row[5])
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

        public int Add(VisitForCreationDto visit)
        {
            try
            {
                int newId = -1;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlCommand = new SqlCommand($"EXEC ADD_VISIT @stationId, @courseId, @visitOrder, @available_seats, @date", sqlConnection))
                {
                    var returnParameter = sqlCommand.Parameters.Add("@result", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.Output;

                    sqlCommand.Parameters.AddWithValue("@stationId", visit.StationId);
                    sqlCommand.Parameters.AddWithValue("@courseId", visit.CourseId);
                    sqlCommand.Parameters.AddWithValue("@visitOrder", visit.VisitOrder);
                    //TODO
                    sqlCommand.Parameters.AddWithValue("@availableSeats", 50);
                    sqlCommand.Parameters.AddWithValue("@date", visit.Date);

                    sqlConnection.Open();
                    var result = sqlCommand.ExecuteScalar();

                    newId = Convert.ToInt32(result);

                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }

                return newId;

            }
            catch (Exception ex)
            {
                logger.LogInformation($"AddVisit DB Connection Error: {ex}");
                return -1;
            }
        }
    }
    
}

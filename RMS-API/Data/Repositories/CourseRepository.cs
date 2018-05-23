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
    public class CourseRepository : BaseRepository<CourseRepository>, ICourseRepository
    {
        public CourseRepository(IConfiguration config, ILogger<CourseRepository> logger) : base(config, logger)
        { }

        public IEnumerable<CourseDto> GetAll()
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM Show_Courses", sqlConnection))
                {
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new CourseDto
                {
                    Id = Convert.ToInt32(row[0]),
                    TrainName = row[1] as string,
                    FirstStation = row[2] as string,
                    FinalStation = row[3] as string
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

        /// <summary>
        /// Gets all the courses containing path from @firstStation to @finalStation
        /// </summary>
        /// <param name="firstStation"></param>
        /// <param name="finalStation"></param>
        /// <returns></returns>
        public IEnumerable<SubCourseDto> GetFromTo(string firstStation, string finalStation)
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"EXEC SHOW_AVAILABLE_COURSES @station_a, @station_b", sqlConnection))
                {
                    sqlDataAdapter.SelectCommand.Parameters.AddWithValue("@station_a", firstStation);
                    sqlDataAdapter.SelectCommand.Parameters.AddWithValue("@station_b", finalStation);
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new SubCourseDto
                {
                    Id = Convert.ToInt32(row[0]),
                    TrainName = row[1] as string,
                    FirstStation = row[2] as string,
                    FinalStation = row[3] as string,
                    DepartureDate = Convert.ToDateTime(row[4]),
                    ArrivalDate = Convert.ToDateTime(row[5])
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

        public int Add(CourseForCreationDto course)
        {
            try
            {
                int newId = -1;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlCommand = new SqlCommand($"EXEC ADD_COURSE @trainId", sqlConnection))
                {
                    var returnParameter = sqlCommand.Parameters.Add("@result", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.Output;

                    sqlCommand.Parameters.AddWithValue("@trainId", course.TrainId);
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
                logger.LogInformation($"AddCourse DB Connection Error: {ex}");
                return -1;
            }
        }
    }
}

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
    public class CourseRepository : BaseRepository<CourseRepository>, ICourseRepository
    {
        public CourseRepository(IConfiguration config, ILogger<CourseRepository> logger) : base(config, logger)
        {}

        public (IEnumerable<CourseDto>, int) GetAll()
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
                    return (null, 0);

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new CourseDto
                {
                    Id = Convert.ToInt32(row[0]),
                    TrainName = row[1] as string,
                    StationA = row[2] as string,
                    StationB = row[3] as string
                });

                return (result, count);
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

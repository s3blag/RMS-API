using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace RMS_API.Data
{
    public class StationRepository : BaseRepository<StationRepository>, IStationRepository
    {
        public StationRepository(IConfiguration config, ILogger<StationRepository> logger) : base(config, logger)
        {
            logger.LogWarning("Halo");
            logger.LogWarning($"ConnectionString: {sqlConnectionString}");
        }

        public DataSet GetAll()
        {
            /*using(var sqlConnection = new SqlConnection(sqlConnectionString))
            using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM Show_Trains", sqlConnection))
            {
                var dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet);
            }*/
            return null;
        }
    }
}

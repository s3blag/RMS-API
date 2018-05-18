using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Data;
using System.Data.SqlClient;

namespace RMS_API.Data.Repositories
{
    public abstract class BaseRepository<T>
    {
        protected readonly ILogger<T> logger;
        protected readonly string sqlConnectionString;
        private readonly IConfiguration _config;
         
        public BaseRepository(IConfiguration config, ILogger<T> logger)
        {
            _config = config;
            this.logger = logger;
            sqlConnectionString = _config.GetConnectionString("RMSConnectionString");
        }

        
    }
}

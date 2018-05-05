using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace RMS_API.Data
{
    public abstract class BaseRepository<T>
    {
        protected ILogger<T> logger;
        protected string sqlConnectionString;
        private readonly IConfiguration _config;

        public BaseRepository(IConfiguration config, ILogger<T> logger)
        {
            _config = config;
            this.logger = logger;
            sqlConnectionString = _config.GetConnectionString("RMSConnectionString");
        }
    }
}

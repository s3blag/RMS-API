using RMS_API.Data.Models;
using System.Collections.Generic;

namespace RMS_API.Data
{
    public interface IStationRepository
    {
        IEnumerable<StationDto> GetAll();
    }
}

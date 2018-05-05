using System.Data;

namespace RMS_API.Data
{
    public interface IStationRepository
    {
        DataSet GetAll();
    }
}
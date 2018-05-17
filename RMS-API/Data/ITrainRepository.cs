using RMS_API.Data.Models;
using System.Collections.Generic;

namespace RMS_API.Data
{
    public interface ITrainRepository
    {
        IEnumerable<TrainDto> GetAll();
        TrainDto GetById(int id);
        int Add(TrainForCreationDto train);
    }
}
using RMS_API.Data.Models;
using System;
using System.Collections.Generic;
using System.Data;

namespace RMS_API.Data
{
    public interface ITrainRepository
    {
        (IEnumerable<TrainDto>, int) GetAll();
        TrainDto GetById(int id);
    }
}
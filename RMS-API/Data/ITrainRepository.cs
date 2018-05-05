using System;
using System.Collections.Generic;
using System.Data;

namespace RMS_API.Data
{
    public interface ITrainRepository
    {
        (IEnumerable<Object>, int) GetAll();
    }
}
using System.Collections.Generic;
using RMS_API.Data.Models;

namespace RMS_API.Data
{
    public interface IVisitRepository
    {
        int Add(VisitForCreationDto visit);
        IEnumerable<VisitDto> GetAll(int courseId);
    }
}
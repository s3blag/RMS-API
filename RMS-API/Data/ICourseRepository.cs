using System.Collections.Generic;

namespace RMS_API.Data
{
    public interface ICourseRepository
    {
        (IEnumerable<object>, int) GetAll();
    }
}
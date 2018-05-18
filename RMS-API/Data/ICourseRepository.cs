using RMS_API.Data.Models;
using System.Collections.Generic;

namespace RMS_API.Data
{
    public interface ICourseRepository
    {
        IEnumerable<CourseDto> GetAll();
        IEnumerable<SubCourseDto> GetFromTo(string firstStation, string finalStation);

        int Add(CourseForCreationDto course);
    }
}
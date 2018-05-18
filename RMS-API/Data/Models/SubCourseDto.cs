using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data.Models
{
    public class SubCourseDto
    {
        public int Id { get; set; }

        public string TrainName { get; set; }

        public string FirstStation { get; set; }

        public string FinalStation { get; set; }

        public DateTime ArrivalDate { get; set; }

        public DateTime DepartureDate { get; set; }

    }
}

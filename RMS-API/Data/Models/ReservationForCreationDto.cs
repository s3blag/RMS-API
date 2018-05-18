using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data.Models
{
    public class ReservationForCreationDto
    {
        public int CourseId { get; set; }

        public float Price { get; set; }

        public string FirstStation { get; set; }

        public string LastStation { get; set; }
    }
}

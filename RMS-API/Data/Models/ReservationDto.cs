using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data.Models
{
    public class ReservationDto
    {
        public int Id { get; set; }

        public int SeatNumber { get; set; }

        public int CustomerId { get; set; }

        public int CourseId { get; set; }

        public string StationA { get; set; }

        public string StationB { get; set; }

    }
}

﻿using System;
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

        public string FirstStation { get; set; }

        public string LastStation { get; set; }

    }
}

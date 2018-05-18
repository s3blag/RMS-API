using System;

namespace RMS_API.Data.Models
{
    public class VisitForCreationDto
    {
        public int StationId { get; set; }

        public int CourseId { get; set; }

        public int VisitOrder { get; set; }

        public DateTime Date { get; set; }
    }
}


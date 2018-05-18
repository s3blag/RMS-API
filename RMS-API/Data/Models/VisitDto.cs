using System;

namespace RMS_API.Data.Models
{
    public class VisitDto
    {
        public int Id { get; set; }

        public int StationId { get; set; }

        public int CourseId { get; set; }

        public string StationName { get; set; }

        public int VisitOrder { get; set; }

        public DateTime Date { get; set; }
    }
}
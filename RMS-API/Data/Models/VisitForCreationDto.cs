using System;
using System.ComponentModel.DataAnnotations;

namespace RMS_API.Data.Models
{
    public class VisitForCreationDto
    {
        [Required]
        [Range(0, Int32.MaxValue)]
        public int StationId { get; set; }

        [Required]
        [Range(0, Int32.MaxValue)]
        public int CourseId { get; set; }

        [Required]
        [Range(0,Int32.MaxValue)]
        public int VisitOrder { get; set; }

        [Required]
        public DateTime Date { get; set; }
    }
}


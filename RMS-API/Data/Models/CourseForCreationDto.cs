using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data.Models
{
    public class CourseForCreationDto
    {
        [Required]
        [Range(0, Int32.MaxValue)]
        public int TrainId { get; set; }
    }
}

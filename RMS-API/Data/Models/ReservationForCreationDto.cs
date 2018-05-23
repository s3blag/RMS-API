using System.ComponentModel.DataAnnotations;

namespace RMS_API.Data.Models
{
    public class ReservationForCreationDto
    {
        [Required]
        public int CourseId { get; set; }

        [Required]
        public double Price { get; set; }

        [Required]
        [MinLength(3)]
        [MaxLength(50)]
        public string FirstStation { get; set; }

        [Required]
        [MinLength(3)]
        [MaxLength(50)]
        public string LastStation { get; set; }
    }
}

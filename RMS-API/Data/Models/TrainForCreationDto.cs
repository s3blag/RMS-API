using System.ComponentModel.DataAnnotations;

namespace RMS_API.Data.Models
{
    public class TrainForCreationDto
    { 
        [Required]
        [MinLength(3)]
        [MaxLength(50)]
        public string Name { get; set; }

        [Required]
        [MinLength(2)]
        [MaxLength(50)]
        public string Model { get; set; }

    }
}

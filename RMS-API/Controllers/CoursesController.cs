using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

namespace RMS_API.Controllers
{
    [Route("api/courses")]
    public class CoursesController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly ILogger<CoursesController> _logger;

        public CoursesController(IUnitOfWork unitOfWork, ILogger<CoursesController> logger)
        {
            _unitOfWork = unitOfWork;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _unitOfWork.CourseRepository.GetAll();

            if (result == null)
                return NotFound();

            return Ok(result);
        }


    }
}
using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

namespace RMS_API.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
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
            var (result, count) = _unitOfWork.CourseRepository.GetAll();

            if (count == 0)
                return NotFound();

            return Ok( new { Results = result, Count = count } );
        }
    }
}
using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

namespace RMS_API.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    public class TrainsController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly ILogger<TrainsController> _logger;

        public TrainsController(IUnitOfWork unitOfWork, ILogger<TrainsController> logger)
        {
            _unitOfWork = unitOfWork;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            try
            {
                var (result, count) = _unitOfWork.TrainRepository.GetAll();

                if (count == 0)
                    return NotFound();

                return Ok(new { Results = result, Count = count });
            }
            catch(Exception ex)
            {
                _logger.LogError($"Failed to get trains: {ex}");
                return BadRequest("Failed to get trains");
            }
            
        }
    }
}
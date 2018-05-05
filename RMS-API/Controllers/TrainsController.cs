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
        private readonly ITrainRepository _trainRepository;
        private readonly ILogger<TrainsController> _logger;

        public TrainsController(ITrainRepository trainRepository, ILogger<TrainsController> logger)
        {
            _trainRepository = trainRepository;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            try
            {
                var (result, count) = _trainRepository.GetAll();

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
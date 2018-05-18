using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

namespace RMS_API.Controllers
{
    [Route("/api/stations")]
    public class StationsController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly ILogger<StationsController> _logger;

        public StationsController(IUnitOfWork unitOfWork, ILogger<StationsController> logger)
        {
            _unitOfWork = unitOfWork;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult GetStations()
        {
            var stations = _unitOfWork.StationRepository.GetAll();

            if (stations == null)
                return NotFound();

            return Ok(stations);
        }
    }
}
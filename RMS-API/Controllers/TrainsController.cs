using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

namespace RMS_API.Controllers
{
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
            var (result, count) = _unitOfWork.TrainRepository.GetAll();

            if (count == 0)
                return NotFound();

            return Ok(new { Results = result, Count = count });
        }


        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            var result = _unitOfWork.TrainRepository.GetById(id);

            if (result == null)
                return NotFound();

            return Ok(result);
        }
    }
}
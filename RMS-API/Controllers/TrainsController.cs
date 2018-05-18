using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;
using RMS_API.Data.Models;
using System;

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
        public IActionResult GetTrains()
        {
            var result = _unitOfWork.TrainRepository.GetAll();

            if (result == null)
                return NotFound();

            return Ok(result);
        }

        [HttpGet("{id}", Name = "GetTrain")]
        public IActionResult GetTrain(int id)
        {
            var result = _unitOfWork.TrainRepository.GetById(id);

            if (result == null)
                return NotFound();

            return Ok(result);
        }

        [HttpPost]
        public IActionResult CreateTrain([FromBody] TrainForCreationDto train)
        {
            if (train == null)
            {
                return BadRequest();
            }

            var newId = _unitOfWork.TrainRepository.Add(train);

            if(newId < 0)
            {
                throw new Exception("Creating a train failed on save.");
            }

            //TODO: Add AutoMapper
            var trainToReturn = new TrainDto
            {
                Model = train.Model,
                Name = train.Name,
                Id = newId
            };

            return CreatedAtRoute("GetTrain", new { id = trainToReturn.Id }, trainToReturn);
        }
    }
}
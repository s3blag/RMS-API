using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RMS_API.Data;

namespace RMS_API.Controllers
{
    [Produces("application/json")]
    [Route("api/Stations")]
    public class StationsController : Controller
    {
        private readonly IStationRepository _stationRepository;

        public StationsController(IStationRepository stationRepository)
        {
            _stationRepository = stationRepository;
        }
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_stationRepository.GetAll());
        }
    }
}
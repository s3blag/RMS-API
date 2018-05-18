using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;
using RMS_API.Data.Models;
using System;

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
        public IActionResult GetCourses()
        {
            var result = _unitOfWork.CourseRepository.GetAll();

            if (result == null)
                return NotFound();

            return Ok(result);
        }

        [HttpGet("{id}/visits", Name = "GetVisitsForCourse")]
        public IActionResult GetVisitsForCourse(int id)
        {
            var result = _unitOfWork.VisitRepository.GetAll(id);

            if (result == null)
                return NotFound();

            return Ok(result);
        }

        [HttpGet("stations")]
        public IActionResult GetAvailableCourses([FromQuery(Name = "firstStation")] string firstStation, [FromQuery(Name = "finalStation")] string finalStation)
        {
            var result = _unitOfWork.CourseRepository.GetFromTo(firstStation, finalStation);

            if (result == null)
                return NotFound();

            return Ok(result);
        }

        [HttpPost("{id}/visits")]
        public IActionResult CreateVisit([FromBody] VisitForCreationDto visit, int id)
        {

            if (visit == null)
            {
                return BadRequest();
            }

            //TODO: not the cleanest solution
            visit.CourseId = id;

            var newId = _unitOfWork.VisitRepository.Add(visit);

            if (newId < 0)
            {
                throw new Exception("Creating a visit failed on save.");
            }

            var visitToReturn = new VisitDto
            {
                Id = newId,
                StationId = visit.StationId,
                CourseId = visit.CourseId,
                StationName = "maybeToDo",
                VisitOrder = visit.VisitOrder,
                Date = visit.Date
            };

            return CreatedAtRoute("GetVisitsForCourse", new { id = visitToReturn.Id }, visitToReturn);
        }

        [HttpPost()]
        public IActionResult CreateCourse([FromBody] CourseForCreationDto course)
        {

            if (course == null)
            {
                return BadRequest();
            }

            var newId = _unitOfWork.CourseRepository.Add(course);

            if (newId < 0)
            {
                throw new Exception("Creating a course failed on save.");
            }

            var courseToReturn = new
            {
                Id = newId,
                TrainId = course.TrainId
            };

            return CreatedAtRoute("GetVisitsForCourse", new { id = courseToReturn.Id }, courseToReturn);
        }
    }
}
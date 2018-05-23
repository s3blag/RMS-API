using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;
using RMS_API.Data.Models;
using System;

namespace RMS_API.Controllers
{
    [Route("api/customers/{customerId}/reservations")]
    public class ReservationsController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly ILogger<ReservationsController> _logger;

        public ReservationsController(IUnitOfWork unitOfWork, ILogger<ReservationsController> logger)
        {
            _unitOfWork = unitOfWork;
            _logger = logger;
        }

        [HttpGet(Name = "GetReservationForCustomer")]
        public IActionResult GetReservationsForCustomer(int customerId)
        {
            if (customerId >= 0)
            {
                var result = _unitOfWork.ReservationRepository.GetByCustomerId(customerId);

                if (result == null)
                    return NotFound();

                return Ok(result);
            }
            else
                return BadRequest();
        }

        [HttpPost]
        public IActionResult AddReservation([FromBody]ReservationForCreationDto reservation)
        {
            var customerId = Convert.ToInt32(RouteData.Values["customerId"]);

            if (ModelState.IsValid && customerId >= 0)
            {
                var result = _unitOfWork.ReservationRepository.Add(reservation, customerId);

                if (result.Item1 < 0 || result.Item2 < 0)
                {
                    throw new Exception("Creating a reservation failed on save.");
                }

                var reservationToReturn = new ReservationDto
                {
                    Id = result.Item1,
                    SeatNumber = result.Item2,
                    CustomerId = customerId,
                    CourseId = reservation.CourseId,
                    FirstStation = reservation.FirstStation,
                    LastStation = reservation.LastStation
                };

                return CreatedAtRoute("GetReservationForCustomer", new { id = reservationToReturn.CustomerId }, reservationToReturn);
            }
            else
                return BadRequest();
            
        }
    }
}

using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RMS_API.Data;

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

        [HttpGet()]
        public IActionResult GetReservationsForCustomer(int customerId)
        {
            var result = _unitOfWork.ReservationRepository.GetByCustomerId(customerId);

            if (result == null)
                return NotFound();

            return Ok(result);
        }
    }
}

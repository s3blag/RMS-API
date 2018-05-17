using System.Collections.Generic;
using RMS_API.Data.Models;

namespace RMS_API.Data
{
    public interface IReservationRepository
    {
        IEnumerable<ReservationDto> GetByCustomerId(int customerId);
    }
}
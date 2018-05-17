using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        //  Unit Of Work is here mainly for fun

        public ICourseRepository CourseRepository { get; }
        public ITrainRepository TrainRepository { get; }
        public IReservationRepository ReservationRepository { get; }

        public UnitOfWork(ICourseRepository courseRepository, 
                          ITrainRepository trainRepository,
                          IReservationRepository reservationRepository)
        {
            CourseRepository = courseRepository;
            TrainRepository = trainRepository;
            ReservationRepository = reservationRepository;
        }

    }
}

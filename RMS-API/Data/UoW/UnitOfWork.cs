namespace RMS_API.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        public ICourseRepository CourseRepository { get; }
        public ITrainRepository TrainRepository { get; }
        public IReservationRepository ReservationRepository { get; }
        public IVisitRepository VisitRepository { get; }
        public IStationRepository StationRepository { get; }

        public UnitOfWork(ICourseRepository courseRepository, 
                          ITrainRepository trainRepository,
                          IReservationRepository reservationRepository,
                          IVisitRepository visitRepository,
                          IStationRepository stationRepository)
        {
            CourseRepository = courseRepository;
            TrainRepository = trainRepository;
            ReservationRepository = reservationRepository;
            VisitRepository = visitRepository;
            StationRepository = stationRepository;
        }

    }
}

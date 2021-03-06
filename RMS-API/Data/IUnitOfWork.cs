﻿namespace RMS_API.Data
{
    public interface IUnitOfWork
    {
        ICourseRepository CourseRepository { get; }
        ITrainRepository TrainRepository { get; }
        IReservationRepository ReservationRepository { get; }
        IVisitRepository VisitRepository { get; }
        IStationRepository StationRepository { get; }
    }
}
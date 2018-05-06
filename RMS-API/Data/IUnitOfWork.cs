namespace RMS_API.Data
{
    public interface IUnitOfWork
    {
        ICourseRepository CourseRepository { get; }
        ITrainRepository TrainRepository { get; }
    }
}
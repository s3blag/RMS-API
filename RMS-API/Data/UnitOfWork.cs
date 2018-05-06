using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RMS_API.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        //  Unit Of Work is here mainly for fun - A controller will use only one repository, so I'm not convinced
        //  about benefits of using it in this project.

        public ICourseRepository CourseRepository { get; }
        public ITrainRepository TrainRepository { get; }

        public UnitOfWork(ICourseRepository courseRepository, 
                          ITrainRepository trainRepository)
        {
            CourseRepository = courseRepository;
            TrainRepository = trainRepository;
        }

    }
}

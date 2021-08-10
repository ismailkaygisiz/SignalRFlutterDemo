using Core.Business;
using Core.Utilities.Results.Abstract;
using Entities.Concrete;
using System.Collections.Generic;

namespace Business.Abstract
{
    public interface IMessageService : IServiceRepository<Message>
    {
        IDataResult<List<Message>> GetByUserId(int userId);
        IDataResult<List<Message>> GetByUserAndReceiver(int userId, int receiverId);
    }
}

using Business.Abstract;
using Business.Extensions;
using Business.Hubs;
using Core.Utilities.Results.Abstract;
using Core.Utilities.Results.Concrete;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Text;

namespace Business.Concrete
{
    public class MessageManager : BusinessService<SystemHub>, IMessageService
    {
        private readonly IMessageDal _messageDal;

        public MessageManager(IMessageDal messageDal)
        {
            _messageDal = messageDal;
        }

        public IResult Add(Message entity)
        {
            _messageDal.Add(entity);
            return new SuccessResult();
        }

        public IResult Delete(Message entity)
        {
            var entityToDelete = GetById(entity.Id).Data;
            _messageDal.Delete(entityToDelete);
            return new SuccessResult();
        }

        public IDataResult<List<Message>> GetAll()
        {
            return new SuccessDataResult<List<Message>>(_messageDal.GetAll());
        }

        public IDataResult<Message> GetById(int id)
        {
            return new SuccessDataResult<Message>(_messageDal.Get(m => m.Id == id));
        }

        public IDataResult<List<Message>> GetByUserAndReceiver(int userId, int receiverId)
        {
            return new SuccessDataResult<List<Message>>(_messageDal.GetAll(m => (m.ThunderUserId == userId && m.ReceiverId == receiverId) || (m.ThunderUserId == receiverId && m.ReceiverId == userId)));
        }

        public IDataResult<List<Message>> GetByUserId(int userId)
        {
            return new SuccessDataResult<List<Message>>(_messageDal.GetAll(m => m.ThunderUserId == userId));
        }

        public IResult Update(Message entity)
        {
            _messageDal.Update(entity);
            return new SuccessResult();
        }
    }
}
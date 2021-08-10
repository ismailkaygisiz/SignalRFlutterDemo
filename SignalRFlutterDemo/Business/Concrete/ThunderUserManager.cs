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
    public class ThunderUserManager : BusinessService<SystemHub>, IThunderUserService
    {
        private readonly IThunderUserDal _thunderUserDal;

        public ThunderUserManager(IThunderUserDal thunderUserDal)
        {
            _thunderUserDal = thunderUserDal;
        }

        public IResult Add(ThunderUser entity)
        {
            _thunderUserDal.Add(entity);
            return new SuccessResult("");
        }

        public IResult Delete(ThunderUser entity)
        {
            var entityToDelete = GetById(entity.UserId).Data;

            _thunderUserDal.Delete(entityToDelete);
            return new SuccessResult("");
        }

        public IDataResult<List<ThunderUser>> GetAll()
        {
            return new SuccessDataResult<List<ThunderUser>>(_thunderUserDal.GetAll());
        }

        public IDataResult<ThunderUser> GetByConnectionId(string connectionId)
        {
            return new SuccessDataResult<ThunderUser>(_thunderUserDal.Get(t => t.ConnectionId == connectionId));
        }

        public IDataResult<ThunderUser> GetById(int id)
        {
            return new SuccessDataResult<ThunderUser>(_thunderUserDal.Get(t => t.UserId == id));
        }

        public IResult Update(ThunderUser entity)
        {
            _thunderUserDal.Update(entity);
            return new SuccessResult("");
        }
    }
}

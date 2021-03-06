using Core.Business;
using Core.Utilities.Results.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Text;

namespace Business.Abstract
{
    public interface IThunderUserService : IServiceRepository<ThunderUser>
    {
        IDataResult<ThunderUser> GetByConnectionId(string connectionId);
    }
}

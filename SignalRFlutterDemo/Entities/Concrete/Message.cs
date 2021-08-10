using Core.Entities.Abstract;
using System;
using System.Collections.Generic;
using System.Text;

namespace Entities.Concrete
{
    public class Message : IEntity
    {
        public int Id { get; set; }
        public int ThunderUserId { get; set; }
        public int ReceiverId { get; set; }
        public string MessageValue { get; set; }
        public DateTime MessageDate { get; set; }

        public virtual ThunderUser ThunderUser { get; set; }
    }
}

using Core.Entities.Abstract;
using Core.Entities.Concrete;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Entities.Concrete
{
    public class ThunderUser : IEntity
    {
        [Key]
        public int UserId { get; set; }
        public string ConnectionId { get; set; }
        public bool Status { get; set; }
    }
}

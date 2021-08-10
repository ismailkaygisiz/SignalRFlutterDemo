using Business.Abstract;
using Core.API;
using Entities.Concrete;
using Microsoft.AspNetCore.Mvc;
using System;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessagesController : Controller, IControllerRepository<Message, IActionResult>
    {
        private readonly IMessageService _messageService;

        public MessagesController(IMessageService messageService)
        {
            _messageService = messageService;
        }

        [HttpPost("[action]")]
        public IActionResult Add(Message entity)
        {
            var result = _messageService.Add(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpPost("[action]")]
        public IActionResult Delete(Message entity)
        {
            var result = _messageService.Delete(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);

        }

        [HttpGet("[action]")]
        public IActionResult GetAll()
        {
            var result = _messageService.GetAll();
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);

        }


        [HttpGet("[action]")]
        public IActionResult GetByUserId(int userId)
        {
            var result = _messageService.GetByUserId(userId);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);

        }

        [HttpGet("[action]")]
        public IActionResult GetByUserAndReceiver(int userId, int receiverId)
        {
            var result = _messageService.GetByUserAndReceiver(userId, receiverId);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }



        [HttpGet("[action]")]
        public IActionResult GetById(int id)
        {
            var result = _messageService.GetById(id);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);

        }

        [HttpPost("[action]")]
        public IActionResult Update(Message entity)
        {
            var result = _messageService.Update(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);

        }
    }
}
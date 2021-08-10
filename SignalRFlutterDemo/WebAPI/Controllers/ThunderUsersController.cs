using Business.Abstract;
using Core.API;
using Entities.Concrete;
using Microsoft.AspNetCore.Mvc;
using System;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ThunderUsersController : Controller, IControllerRepository<ThunderUser, IActionResult>
    {
        private readonly IThunderUserService _thunderUserService;

        public ThunderUsersController(IThunderUserService thunderUserService)
        {
            _thunderUserService = thunderUserService;
        }

        [HttpPost("[action]")]
        public IActionResult Add(ThunderUser entity)
        {
            var result = _thunderUserService.Add(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpPost("[action]")]
        public IActionResult Delete(ThunderUser entity)
        {
            var result = _thunderUserService.Delete(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpGet("[action]")]
        public IActionResult GetAll()
        {
            var result = _thunderUserService.GetAll();
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpGet("[action]")]
        public IActionResult GetById(int id)
        {
            var result = _thunderUserService.GetById(id);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpPost("[action]")]
        public IActionResult Update(ThunderUser entity)
        {
            var result = _thunderUserService.Update(entity);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result);
        }
    }
}
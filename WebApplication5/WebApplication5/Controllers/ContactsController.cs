using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using WebApplication5.Helpers;
using WebApplication5.Models.Users;
using WebApplication5.Services;

namespace WebApplication5.Controllers
{
    [Route("users/{id}/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private IContactService _service;
        private IMapper _mapper;
        public ContactsController(IContactService service, IMapper mapper)
        {
            _service = service;
            _mapper = mapper;
        }

        [HttpPost]
        public IActionResult AddToContactList(int id, [FromBody] string username)
        {
            _service.AddToContactList(id, username);
            return Ok();
        }

        [HttpGet]
        public IActionResult GetContactList(int id)
        {
            var contacts = _service.GetContactList(id);
            var model = _mapper.Map<IList<ContactModel>>(contacts);
            
            return Ok(model);
        }
        //dorobic usuwanie z kontaktow
    }
}

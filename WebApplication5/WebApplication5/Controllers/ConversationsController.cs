using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApplication5.Services;

namespace WebApplication5.Controllers
{
    [Route("users/{id}/contacts/{username}")]
    [ApiController]
    public class ConversationsController : ControllerBase
    {
        private IConversationService _service;
        private IMapper _mapper;
        public ConversationsController(IConversationService service, IMapper mapper)
        {
            _service = service;
            _mapper = mapper;
        }
        public void getConversation(int id, string username)
        {
            
        }
    }
}

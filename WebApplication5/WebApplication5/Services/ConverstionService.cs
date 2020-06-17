using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApplication5.Entities;
using WebApplication5.Helpers;

namespace WebApplication5.Services
{
    public interface IConversationService
    {
        public void SaveMessage(Message message);
    }
    public class ConversationService :  IConversationService
    {
        private DataContext _context;
        public ConversationService(DataContext context)
        {
            _context = context;
        }
        public void SaveMessage(Message message)
        {
            var conversation = _context.Conversations.Include(conv => conv.Messages).SingleOrDefault(x => x.ID == message.ConversationID);
            if (conversation == null)
                throw new AppException("Conversation not found");
            conversation.Messages.Add(message);
            _context.SaveChanges();
        }
        public void getLatestMessages() //get 15 
        {

        }
    }
}

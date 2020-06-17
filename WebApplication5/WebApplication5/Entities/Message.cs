using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication5.Entities
{
    public class Message
    {
        public int ID { get; set; }
        public int ConversationID { get; set; }
        public string SenderUsername { get; set; }
        public string ReceiverUsername { get; set; }
        public string Content { get; set; }
        public virtual Conversation Conversation { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication5.Entities
{
    public class Contact
    {
        
        public int ID { get; set; }
        public int UserID { get; set; }
        public int ConversationID { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public virtual User User { get; set; }
        public virtual Conversation Conversation { get; set; }

    }
}

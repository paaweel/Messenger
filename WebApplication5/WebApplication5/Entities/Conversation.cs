using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace WebApplication5.Entities
{
    public class Conversation
    {
        public int ID { get; set; }
        public virtual ICollection<Contact> Contacts { get; set; }
        public virtual ICollection<Message> Messages { get; set; }
    }
}

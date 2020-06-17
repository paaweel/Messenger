using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication5.Helpers
{
    public class ConnectionConstants
    {
        public const string HostName = "localhost";
        public const string MainQueue = "chat-app-messages";
        public const string OutgoingConvExchange = "conversation.outgoing";
        public const string IncomingConvExchange = "conversation.incoming";
        public const string User = "admin";
        public const string Password = "admin";
        public const string VirtualHostName = "v_host";
    }
}

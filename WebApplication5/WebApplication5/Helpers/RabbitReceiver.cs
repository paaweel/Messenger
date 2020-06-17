using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using WebApplication5.Entities;
using WebApplication5.Helpers;

namespace WebApplication5.Services
{
    public class RabbitReceiver : BackgroundService
    {
        private IConnection _connection;
        private IModel _channel;
        private readonly IConversationService _service;
        public RabbitReceiver(IConversationService service) {

            _service = service;
            InitializeConnection(); 

        }

        private void InitializeConnection()
        {
            ConnectionFactory factory = new ConnectionFactory
            {
                UserName = ConnectionConstants.User,
                Password = ConnectionConstants.Password,
                VirtualHost = ConnectionConstants.VirtualHostName,
                HostName = ConnectionConstants.HostName
            };
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.ExchangeDeclare(ConnectionConstants.OutgoingConvExchange, ExchangeType.Fanout, true, false, null);
            _channel.ExchangeDeclare(ConnectionConstants.IncomingConvExchange, ExchangeType.Topic, true, false, null);
            _channel.QueueDeclare(ConnectionConstants.MainQueue, true, false, false, null);
            _channel.QueueBind(ConnectionConstants.MainQueue, ConnectionConstants.OutgoingConvExchange, "", null);
            //deklaracja exchangy, glowna kolejke laczymy z outgoingezchange
        }
        protected override Task ExecuteAsync(CancellationToken stoppingToken)
        {
            stoppingToken.ThrowIfCancellationRequested();

            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += (model, ea) =>
            {
                //odbieramy wiadomosc, przekazujemy do serwisu odpowiedniego w celu obslugi
                var body = ea.Body;
                String jsonified = Encoding.UTF8.GetString(body.ToArray());
                Message message = JsonConvert.DeserializeObject<Message>(jsonified);
                //dostaje wiadomosc, zapisuje ja sobie w bazie w konwersacjach, przekierowuje wiadomosc na kolejke konwersacji 
                Console.WriteLine("received {0}", message.Content); //potem to usunac
                _service.SaveMessage(message);
                _channel.BasicPublish(ConnectionConstants.IncomingConvExchange, message.ConversationID.ToString(), null, body); //przekazujemy wiadomosc na kolejki klientow
                //basicpublish gdzie dalej ma ta wiadomosc poleciec??
            };
            _channel.BasicConsume(queue: ConnectionConstants.MainQueue, autoAck: true, consumer: consumer);
            return Task.CompletedTask;
        }
    }
}

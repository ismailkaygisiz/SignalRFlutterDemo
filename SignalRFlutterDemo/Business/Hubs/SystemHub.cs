using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Threading.Tasks;

namespace Business.Hubs
{
    public class SystemHub : Hub
    {
        private readonly IThunderUserService _thunderUserService;
        private readonly IMessageService _messageService;

        public SystemHub(IThunderUserService thunderUserService, IMessageService messageService)
        {
            _thunderUserService = thunderUserService;
            _messageService = messageService;
        }

        public override async Task OnConnectedAsync()
        {

        }

        public override async Task OnDisconnectedAsync(Exception exception)
        {
            var user = _thunderUserService.GetByConnectionId(Context.ConnectionId).Data;
            if (user != null)
            {
                user.Status = false;
                _thunderUserService.Update(user);
            }
        }

        public async Task SendMessage(int userId, int receiverId, string message)
        {
            if (!ControlUser(userId))
                return;

            var user = _thunderUserService.GetById(receiverId).Data;

            if (user.Status)
            {
                await Clients.Client(user.ConnectionId).SendAsync("receiveMessage", message);
                _messageService.Add(new Message() { ThunderUserId = userId, ReceiverId = receiverId, MessageValue = message, MessageDate = DateTime.Now });
            }
            else
            {
                _messageService.Add(new Message() { ThunderUserId = userId, ReceiverId = receiverId, MessageValue = message, MessageDate = DateTime.Now });
            }
        }

        public async Task Connect(int userId)
        {
            if (ControlUser(userId))
            {
                await Clients.Caller.SendAsync("connectedMessage", $"Bağlantı Oluşturuldu  :  {userId}");
            }
            else
            {
                await Clients.Caller.SendAsync("connectedMessage", $"Bağlantı Oluşturulamadı  :  {userId}");
            }
        }
        public async Task Disconnect(string connectionId)
        {
            var user = _thunderUserService.GetByConnectionId(connectionId).Data;
            if (user != null)
            {
                user.Status = false;
                _thunderUserService.Update(user);

                await Clients.Caller.SendAsync("disconnectedMessage", $"Bağlantı Kapatıldı  :  {connectionId}");
            }
        }

        private bool ControlUser(int userId)
        {
            var user = _thunderUserService.GetById(userId).Data;

            var operation = user != null ?
                _thunderUserService.Update(new ThunderUser() { UserId = userId, ConnectionId = Context.ConnectionId, Status = true }) :
                _thunderUserService.Add(new ThunderUser() { UserId = userId, ConnectionId = Context.ConnectionId, Status = true });

            return operation.Success;
        }


    }
}
import json
from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
from . models import Discussion, Publication, CustomUser
from .serializers.chatSerializer import ChatSerializer

class ProtocalType:
    ID  = "ID"
    CHAT = "CHAT"

class MessageHistory:
    def __init__(self, data:str) -> None:
        self.data = json.loads(data)
        self.message = self.data["message"]
        self.pub_id = self.data["pub_id"]
        self.user_id = self.data["user_id"]


class MessageChatProcess:
    @classmethod
    def create(cls, mgs_hist : MessageHistory ) -> Discussion:
        return Discussion.objects.create(
            user_id = CustomUser.objects.get(pk=mgs_hist.user_id),
            pub_id = Publication.objects.get(pk=mgs_hist.pub_id),
            message=mgs_hist.message,
        )
        
    @classmethod
    def parsed(cls, discussion:Discussion):
        serializer = ChatSerializer(discussion)
        return json.dumps(serializer.data)


class SocketIOConsumer(WebsocketConsumer):
    def get_room_chat(self) -> str:
        r = self.scope['url_route']['kwargs']['pubID']
        return  f"chat_room_{r}"
    
    def connect(self):
        room = self.get_room_chat()
        async_to_sync(self.channel_layer.group_add)(room, self.channel_name)
        self.accept()
        print("Connect To Chat", room)

    def disconnect(self, close_code):
        room = self.get_room_chat()
        async_to_sync(self.channel_layer.group_discard)(room, self.channel_name)
        print("Disconnect to Chat", room)

    def receive(self, text_data):
        room = self.get_room_chat()
        msg_hist = MessageHistory(data=text_data)
        message = MessageChatProcess.parsed(MessageChatProcess.create(mgs_hist=msg_hist))
        async_to_sync(self.channel_layer.group_send)(
            room,
            {
                "type": "chat.message",
                "text":  message,
            },
        )
    
    def chat_message(self, event):
        self.send(text_data=event["text"])
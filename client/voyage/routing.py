from django.urls import re_path, path

from . import consumers

websocket_urlpatterns = [
    re_path(r"chat/(?P<pubID>\w+)/$",  consumers.SocketIOConsumer.as_asgi()),
]
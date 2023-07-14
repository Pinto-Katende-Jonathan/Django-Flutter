from rest_framework.serializers import ModelSerializer, CharField
from ..models import Discussion


class ChatSerializer(ModelSerializer):
    sender_name = CharField(source = "user_id.username", read_only = True)
    class Meta:
        model = Discussion
        fields = '__all__'
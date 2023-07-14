from rest_framework.serializers import ModelSerializer

from voyage.serializers.authSerializer import UserSerializer
from ..models import CustomUser, Publication


from rest_framework.fields import SerializerMethodField

class PubSerializer(ModelSerializer):
    user = SerializerMethodField()

    def get_user(self, obj):
        user = CustomUser.objects.get(id=obj.user_id.id)
        return {
            'id': user.id,
            'username': user.username,
            'telephone': user.telephone,
            'role': user.role,
            'genre': user.genre,
            'plaque': user.plaque,
            'type_voiture': user.type_voiture,
            'photo_voiture': user.photo_voiture.url if user.photo_voiture else None
        }

    class Meta:
        model = Publication
        fields = ('id','depart', 'destination', 'date_voyage', 'user')
from rest_framework import serializers

from voyage.models import CustomUser as User
#from django.contrib.auth.models import User

# User Serializer
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'role', 'telephone', 'genre', 'plaque', 'type_voiture', 'photo_voiture')

# Register Serializer
class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password', 'role', 'telephone', 'genre', 'plaque', 'type_voiture', 'photo_voiture')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(validated_data['username'], validated_data['email'], validated_data['password'])
        user.role = validated_data.get('role', None)
        user.telephone = validated_data.get('telephone', None)
        user.genre = validated_data.get('genre', None)
        user.plaque = validated_data.get('plaque', None)
        user.type_voiture = validated_data.get('type_voiture', None)
        user.photo_voiture = validated_data.get('photo_voiture', None)

        user.save()

        return user
    
    def validate_username(self, value):
        if self.instance is None and User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Un utilisateur avec ce nom existe déjà.")
        return value
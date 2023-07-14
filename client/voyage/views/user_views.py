# class CustomAuthToken(ObtainAuthToken):
#     def post(self, request, *args, **kwargs):
#         # serializer = self.serializer_class(data=request.data,
#         #                                    context={'request': request})
#         # serializer.is_valid(raise_exception=True)
#         # user = serializer.validated_data['user']
#         # token, created = Token.objects.get_or_create(user=user)
#         # return Response({
#         #     'token': token.key,
#         #     'id': user.pk,
#         #     'email': user.email,
#         #     'username': user.username,
#         #     'role': user.role if user.role else None,
#         #     'telephone': user.telephone,
#         #     'genre': user.genre,
#         #     'plaque': user.plaque if user.plaque else None,
#         #     'type_voiture': user.type_voiture if user.type_voiture else None,
#         #     'photo_voiture': str(request.build_absolute_uri(user.photo_voiture.url)) if user.photo_voiture else None
#         # })

from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response

from voyage.serializers.authSerializer import RegisterSerializer, UserSerializer


# --------- Create user ------------------------------------------------------
class CreateUser(ObtainAuthToken):
    serializer_class = RegisterSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response({
            "user": UserSerializer(user, context=self.get_serializer_context()).data  # ,
            # "token": AuthToken.objects.create(user)[1]
        })
# -------------------------------------------------------------------------


# from rest_framework import generics, permissions
# from rest_framework.response import Response
# from knox.models import AuthToken
# from ..serializers.authSerializer import UserSerializer, RegisterSerializer


# class RegisterAPI(generics.GenericAPIView):
#     serializer_class = RegisterSerializer

#     def post(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         user = serializer.save()
#         return Response({
#             "user": UserSerializer(user, context=self.get_serializer_context()).data  # ,
#             # "token": AuthToken.objects.create(user)[1]
#         })

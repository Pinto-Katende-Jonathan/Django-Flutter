# ---- Create user ----------------
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from voyage.models import CustomUser as User
from voyage.serializers.authSerializer import UserSerializer, RegisterSerializer
from voyage.utils import image_preprocessing
from rest_framework.authtoken.models import Token

@api_view(['POST'])
def create_user(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#----------------------------------------

# ------------- All users ---------------
@api_view(['GET'])
def all_users(request):
    users = User.objects.all()
    serializer = RegisterSerializer(users, many=True)
    return Response(serializer.data)

#--------- Get user ---------------------
@api_view(['GET'])
def get_user(request, pk):
    try:
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = RegisterSerializer(user)
    return Response(serializer.data)
#-------------------------------------------

#--------- Update user --------------------
@api_view(['PUT'])
def update_user(request, pk):
    try:
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = RegisterSerializer(user, data=request.data, partial=True) # ajout de 'partial=True' pour autoriser la mise à jour partielle des champs
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#----------------------------------------------

# --------- Delete user -----------------------
@api_view(['DELETE'])
def delete_user(request, pk):
    try:
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return Response("user does not exist")
        # return Response(status=status.HTTP_404_NOT_FOUND)

    user.delete()
    return Response("deleted successfully")
#-------------------------------------------------

@api_view(['POST'])
def login(request):
    data = request.data
    print(data)

    from rest_framework import exceptions
    from voyage.utils import generate_access_token

    # Strip remove w
    username = str(data['username']).strip()
    password = data['password']

    response = Response()
    if (username is None) or (password is None):
        raise exceptions.AuthenticationFailed(
            'username and password required')

    user = User.objects.filter(username=username).first()
    if(user is None):
        raise exceptions.AuthenticationFailed('user not found')
    if (not user.check_password(password)):
        raise exceptions.AuthenticationFailed('wrong password')

    serialized_user = UserSerializer(user).data

    access_token = generate_access_token(user)

    response.data = {
        'access': access_token,
        'user': serialized_user,
    }

    return response


# Display image
#======================
from django.http import HttpResponse
from rest_framework.views import APIView
from django.conf import settings
import os

class ImageView(APIView):
    def get(self, request, filename, format=None):
        image_path = os.path.join(settings.MEDIA_ROOT, filename)
        with open(image_path, 'rb') as f:
            return HttpResponse(f.read(), content_type='image/png')

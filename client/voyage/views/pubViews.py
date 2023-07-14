# from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from rest_framework.response import Response

from voyage.models import Publication, CustomUser as User
from voyage.serializers.authSerializer import UserSerializer
from voyage.serializers.pubSerializer import PubSerializer
from voyage.utils import date_convert

# Get all publications
# =======================
@api_view(['GET'])
def publications(request):
    pubs = Publication.objects.order_by("-id")
    serializer = PubSerializer(pubs, many=True) # Many = True, s'il s'agit d'une liste d'éléments
    return Response(serializer.data)

# Get all publications by specification
# =======================================
@api_view(['GET'])
def pub_spec(request):
    pubs = Publication.objects.order_by("-id")
    destination = request.GET.get('destination')
    depart = request.GET.get('depart')

    if  destination != '':
        pubs_filtered = pubs.filter(destination__icontains=destination)

    elif destination != '' and depart is not None:
        pubs_filtered = pubs.filter(destination__icontains=destination, depart__icontains=depart)
    
    
    serializer = PubSerializer(pubs_filtered, many=True) # Many = True, s'il s'agit d'une liste d'éléments
    return Response(serializer.data)

# Get a specific publication
# ===========================
@api_view(['GET'])
def publication(request, pk):
    pub = Publication.objects.get(id=pk)
    serializer = PubSerializer(pub, many=False) # Many = False, s'il s'agit d'un élément
    return Response(serializer.data)

# Create a publication
# =======================
@api_view(['POST'])
def pub_creation(request):
    data = request.data
    print(data)
    try:
        pub = Publication.objects.create(
            depart = data["depart"],
            destination = data["destination"],
            date_voyage = date_convert(data['date_voyage']),
            user_id = User.objects.get(id = data['user_id'])
        )
        serializer = PubSerializer(pub, many=False)
        return Response(serializer.data)
    except:
        return Response({'message':"Vérifiez vos informations"}, 400)

# Update a publication
# =======================
@api_view(['PUT'])
def pub_update(request, pk):
    try:
        pub = Publication.objects.get(id=pk)
        data = request.data

        if pub:
            pub.depart = data["depart"]
            pub.destination = data["destination"]
            pub.date_voyage = date_convert(data['date_voyage'])
            pub.save()

            serializer = PubSerializer(pub, many=False)
            return Response(serializer.data)
    except:
        return Response({'message':"la publication n'existe pas"}, 404)

# Delete a publication
# =======================
@api_view(['DELETE'])
def del_pub(request, pk):
    try:
        pub = Publication.objects.get(id=pk)
        if(pub):
            pub.delete()
            return Response('la publication est supprimée avec succès')
    except:
        return Response({'message':"la publication n'existe pas"}, 404)

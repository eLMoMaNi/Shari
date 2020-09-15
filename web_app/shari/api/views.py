from products.models import Product, ProductImg
from markets.models import MarketProfile
from django.contrib.auth.models import User

from rest_framework.authtoken.models import Token
from rest_framework import status
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly, IsAdminUser
from django.http import HttpResponse, HttpResponseNotFound
from rest_framework.response import Response
from rest_framework.views import APIView
from api.serializers import *

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#        >>  Core <<        #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

########################################################
class CreateUserProfileView(APIView):     # api/singup #

    def post(self, request, *args, **kwargs):

        if not request.POST.get('username', False):
            return Response({'error': 'Username Field is Required'}, status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(username=request.POST['username']).exists():
            return Response({'error': 'Username taken, try another one'}, status.HTTP_400_BAD_REQUEST)
        user = User(
            username=request.POST['username']
        )
        user.set_password(request.POST['password'])
        user.save()

        serializer = UserProfileSer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)

            token = Token.objects.create(user=user)
            t = {'token': token.key , 'id' : user.id}

            t.update(serializer.data)

            return Response(t)

        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)

########################################################
class ShowUserProfileView(APIView):    # api/user/<id> #
    permission_classes = (IsAuthenticated,)

    def get(self,  request, *args, **kwargs):
        if UserProfile.objects.filter(user=kwargs['id']).exists():
            profile = UserProfileSer(
                UserProfile.objects.filter(user=kwargs['id']).first())

            return Response(profile.data)
        else:
            return HttpResponseNotFound('Page Not Found :c ')




########################################################
class UserProfileView(APIView):   # api/user/myprofile #
    permission_classes = (IsAuthenticated,)

    def get(self,  request, *args, **kwargs):
            profile = UserProfileSer(
                UserProfile.objects.filter(user=request.user.id).first())
            d =  profile.data
            d.update({'username':request.user.username, 'id' :  request.user.id })
            return Response(d)


    def put(self, request, *args, **kwargs):

        serializer = UserProfileSer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)

        profile = UserProfile.objects.get(user=request.user)

        old_id = profile.id     # Profile id not user id
        profile.pic.delete()
        profile.delete()

        user = request.user
        serializer.save(user=user, id = profile.id)

        if not user.username == request.POST['username']:
            if User.objects.filter(username=request.POST['username']).exists():
                return Response({'error':'Username taken, try another one.'},status.HTTP_400_BAD_REQUEST)
            user.username = request.POST['username']

        user.set_password(request.POST['password'])
        user.save()

        return Response(serializer.data)


    def delete(self, request, *args, **kwargs):

        profile = UserProfile.objects.get(user=request.user)
        profile.pic.delete()
        profile.delete()

        user = request.user
        user.delete()
        return Response({'msg': 'Your user profile has been deleted'})
     

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#       >>  Markets <<      #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#       >>  Products  <<    #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>##############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#     >>  ProductsImg  <<    #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>##############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#TODO more file manging 

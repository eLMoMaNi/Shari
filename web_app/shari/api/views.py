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


########################################################
class MarketView(APIView):      # api/market/myprofile #
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        if MarketProfile.objects.filter(user=request.user).exists():
            return Response ({'error':'You have already created your market'},status.HTTP_400_BAD_REQUEST)

        serializer = MarketProfileSer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data)
        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)


    def put(self, request, *args, **kwargs):
        if not MarketProfile.objects.filter(user=request.user).exists():
            return Response({'error':'You do not have market to edit'},status.HTTP_400_BAD_REQUEST)

        serializer = MarketProfileSer(data=request.data)
        if serializer.is_valid():
            old_id = MarketProfile.objects.get(user=request.user).id
            market = MarketProfile.objects.get(user=request.user)

            market.pic.delete()
            market.wall_pic.delete()
            market.delete()

            serializer.save(user=request.user, id=old_id)
            return Response(serializer.data)
        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)


    def delete(self, request, *args, **kwargs):
        if not MarketProfile.objects.filter(user=request.user).exists():
            return Response({'error':'You do not have market to delete'},status.HTTP_400_BAD_REQUEST)

        market = MarketProfile.objects.get(user=request.user)
        market.pic.delete()
        market.wall_pic.delete()
        market.delete()
        return Response({'msg': 'Your market profile has been deleted'})


    def get(self,  request, *args, **kwargs):
        if MarketProfile.objects.filter(user=request.user).exists():
            market = MarketProfileSer(
                MarketProfile.objects.filter(user=request.user).first())
            return Response(market.data)
        else:
            return HttpResponseNotFound( 'Page Not Found :c ' )

########################################################
class ShowMarketView(APIView):      # api/market/<id>  #
    permission_classes = (IsAuthenticated,)

    def get(self,  request, *args, **kwargs):
        if MarketProfile.objects.filter(id=kwargs['id']).exists():
            market = MarketProfileSer(
                MarketProfile.objects.filter(id=kwargs['id']).first())
            return Response(market.data)
        else:
            return HttpResponseNotFound( 'Page Not Found :c ')




# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#       >>  Products  <<    #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

########################################################
class CreateProductView(APIView):      #   api/product #
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        if not MarketProfile.objects.filter(user=request.user).exists():
            return Response({'error':'You do not have a market, create a market profile first to add products'},status.HTTP_400_BAD_REQUEST)

        serializer = ProductSer(data=request.data)
        if serializer.is_valid():

            serializer.save(
                market=MarketProfile.objects.get(user=request.user))
            product = Product.objects.filter(
                market=MarketProfile.objects.get(user=request.user)).last()

            for pic in request.FILES.getlist('pics', None):
                img = ProductImg(pic=pic, product=product)
                img.save()
            
            for feature in request.POST.get('features', None):
                product_features +=  feature + ', '

            product.features    =   product_features
            product.save()

            return Response(serializer.data)
        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)


########################################################
class ProductView(APIView):       #   api/product/<id> #
    permission_classes = (IsAuthenticated,)

    def get(self,  request, *args, **kwargs):
        if Product.objects.filter(id=kwargs['id']).exists():
            product = Product.objects.get(id=kwargs['id'])

            serialized = ProductSer(product)
            d = serialized.data

            pics = []
            product = Product.objects.get(id=kwargs['id'])
            
            for img in ProductImg.objects.filter(product=product):
                pics.append(img.pic.url)

            d.update({'pics':pics})
            return Response(d)
        else:
            return HttpResponseNotFound('Page Not Found :c ')


    def put(self, request, *args, **kwargs):
        if not Product.objects.filter(id=kwargs['id']).exists():
            return HttpResponseNotFound('Page Not Found :c ')

        his_market = MarketProfile.objects.filter(user=request.user).first()
        if not his_market == Product.objects.get(id=kwargs['id']).market:
            return Response({'error':'This product does not belong to you'},status.HTTP_400_BAD_REQUEST)

        serializer = ProductSer(data=request.data)
        if serializer.is_valid():
            old_id = Product.objects.get(id=kwargs['id']).id
            product = Product.objects.get(id=kwargs['id'])

            product.wall_pic.delete()
            for img in ProductImg.objects.filter(product=product):
                img.pic.delete()

            product.delete()

            serializer.save(market=his_market, id=old_id)

            product = Product.objects.get(id=old_id)

            for pic in request.FILES.getlist('pics', None):
                img = ProductImg(pic=pic, product=product)
                img.save()
            
            for feature in request.POST.get('features', None):
                product_features +=  feature + ', '

            product.features    =   product_features
            product.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)


    def delete(self, request, *args, **kwargs):
        if not Product.objects.filter(id=kwargs['id']).exists():
            return HttpResponseNotFound('Page not found :c')

        his_market = MarketProfile.objects.filter(user=request.user).first()
        if not his_market == Product.objects.get(id=kwargs['id']).market:
            return Response({'error':'This product does not belong to you'}, status.HTTP_400_BAD_REQUEST)

        product = Product.objects.get(id=kwargs['id'])
        for img in ProductImg.objects.filter(product=product):
            img.pic.delete()
        product.wall_pic.delete()
        product.delete()
        return Response({'msg': 'Your product has been deleted'})


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>##############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#     >>  ProductsImg  <<    #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>##############################<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#TODO more file manging 

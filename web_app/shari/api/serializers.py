from rest_framework import serializers
from markets.models import MarketProfile
from products.models import Product, ProductImg
from core.models import UserProfile


class UserProfileSer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = (
             'firstname','lastname', 'pic', 'number' , 'created_at', 'fav'
        )


class MarketProfileSer(serializers.ModelSerializer):
    class Meta:
        model = MarketProfile
        fields = (
             'id', 'name', 'bio', 'user', 'number', 'location', 'layout', 'pic','wall_pic','created_at','rating','mclass'
        )
        
        

class ProductSer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = (
            'id', 'title', 'description', 'price', 'market', 'wall_pic', 'created_at', 'mclass','sclass','tags','rating'
        )


class ProductImgtSer(serializers.ModelSerializer):
    class Meta:
        model = ProductImg
        fields = (
            'id', 'pic', 'created_at', 'product'
        )



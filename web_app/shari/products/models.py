from django.db import models
from django.contrib.postgres.fields import ArrayField, JSONField
from markets.models import MarketProfile

class Product(models.Model):
    market      =   models.ForeignKey(MarketProfile, on_delete=models.CASCADE, default=None, blank=True, null=True)

    title       =   models.CharField(max_length=200)
    description =   models.TextField(blank=True, null=True, max_length=2000)
    price       =   models.FloatField(  blank=True, null=True)
    wall_pic    =   models.ImageField(blank=True, null=True,upload_to='productWall')  #Featured pic
    rating      =   models.FloatField(blank=True, null = True)

    mclass      =   models.CharField(max_length=100)
    sclass      =   models.CharField(max_length=100)
    tags        =   ArrayField(models.CharField(max_length=100), blank=True, null=True)
   
    created_at  =   models.DateTimeField(auto_now_add=True)
    updated_at  =   models.DateTimeField(auto_now=True)


    def __str__(self):
        return self.title

        
class ProductImg(models.Model):
    product     =   models.ForeignKey(Product, on_delete=models.CASCADE, default=None, blank=True, null=True)

    pic         =   models.ImageField(blank=True, null=True,upload_to='productPics')

    def __str__(self):
        return self.product.title
from django.db import models
from django.contrib.postgres.fields import ArrayField, JSONField
from django.contrib.auth.models import User
# Create your models here.

class MarketProfile(models.Model):
    user        =   models.ForeignKey(User, on_delete=models.CASCADE, default=None, blank=True, null=True)

    name        =   models.CharField(max_length=200)
    bio         =   models.TextField(blank=True, null=True, max_length=2000)
    number      =   models.CharField( max_length=20, blank=True, null=True) 

    location    =   JSONField(blank=True, null=True)
    layout      =   JSONField(blank=True, null=True)

    pic         =   models.ImageField(blank=True,upload_to='market_profiles', null = True)
    wall_pic    =   models.ImageField(blank=True, upload_to='market_walls', null = True)

    rating      =   models.FloatField(blank=True, null = True)
    mclass      =   ArrayField( models.CharField(blank=True,null = True,max_length=200) , blank=True, null = True) 

    created_at  =   models.DateTimeField(auto_now_add=True)
    updated_at  =   models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name
from django.db import models
from django.contrib.postgres.fields import ArrayField, JSONField
from django.contrib.auth.models import User
# Create your models here.

class UserProfile(models.Model):
    firstname        =   models.CharField(max_length=200)
    secondname       =   models.CharField(blank=True, max_length=200)

    pic         =   models.ImageField(blank=True,upload_to='profile_pic')
    number      =   models.CharField( max_length=15, blank=True) 

    user        =   models.ForeignKey(User, on_delete=models.CASCADE, default=None, blank=True)
    created_at  =   models.DateField(auto_now_add=True)
    
    fav         =   JSONField(null=True, blank=True)


    def __str__(self):
        return self.name
""" 
    @classmethod
    def create(cls, title, memo, important, user):
        market_profile = cls(title=title, memo=memo, important=important, user=user)
        return market_profile
 """
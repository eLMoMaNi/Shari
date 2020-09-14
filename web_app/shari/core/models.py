from django.db import models
from django.contrib.postgres.fields import ArrayField, JSONField
from django.contrib.auth.models import User
# Create your models here.

class UserProfile(models.Model):
    user        =   models.ForeignKey(User, on_delete=models.CASCADE, default=None, blank=True, null=True)

    firstname   =   models.CharField(max_length=200,null=True, blank=True)
    lastname    =   models.CharField(blank=True, null=True, max_length=200)

    pic         =   models.ImageField(blank=True, null=True,upload_to='profile_pic')
    number      =   models.CharField( max_length=15, blank=True, null=True) 
    fav         =   JSONField( blank=True, null=True)
   
    created_at  =   models.DateTimeField(auto_now_add=True)
    updated_at  =   models.DateTimeField(auto_now=True)



    def __str__(self):
        return self.name
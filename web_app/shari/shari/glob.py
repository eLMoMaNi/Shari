from django.contrib.auth.models import User
from markets.models import MarketProfile 
import random


def glob(request):
    has_market  =   MarketProfile.objects.filter(user=request.user.id).exists() 
    his_market  =   MarketProfile.objects.filter(user=request.user.id).first()
    rand        =   random.randint(1,8)
    mclasses    =   ['Food', 'Grocery', 'Clothset', 'Handicraft', 'Pharmacy', 'Other' ]
    return {'has_market': has_market , 'his_market': his_market , 'rand': rand , 'mclasses':mclasses } 
from django.urls import path, include
from . import views

urlpatterns = [
    path(''          , views.home       ,name='home'),
    path('login/'    , views.loginuser  ,name='loginuser'),
    path('logout/'   , views.logoutuser ,name='logoutuser'),
    path('signup/'   , views.signupuser ,name='signupuser'),
    path('market/'   , views.market     ,name='market'),
    path('my-market/', views.mymarket   ,name='mymarket'),
    
    
]
from django.urls import path, include
from rest_framework.authtoken.views import ObtainAuthToken
from . import views



urlpatterns = [
#*********************************************************************************************.
    path('login'            , ObtainAuthToken.as_view()             ),  # post                |         
#                                                                                             |
    path('signup'           , views.CreateUserProfileView.as_view() ),  # post                |
#*********************************************************************************************+
    path('user/myprofile'   , views.UserProfileView.as_view()       ),  # get,put,delete      |
#                                                                                             |
    path('user/<int:id>'    , views.ShowUserProfileView.as_view()   ),  # get                 |
#*********************************************************************************************+
#    path('search'           , SearchView.as_view()                         ),  # get         |    
#    path('market/myprofile' , views.MarketView.as_view()            ),  # get,post,put,delete|
#                                                                                             |
#    path('market/<int:id>'  , views.ShowMarketView.as_view()        ),  # get                |
#*********************************************************************************************+
#    path('product'          , views.CreateProductView.as_view()     ),  # post               |
#                                                                                             |
#    path('product/<int:id>' , views.ProductView.as_view()           ),  # get,put,delete     |      
#*********************************************************************************************'
]
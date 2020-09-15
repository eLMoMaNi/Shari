from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.pagination import PageNumberPagination
from rest_framework.generics import ListAPIView
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework import filters

from rest_framework.response import Response

from api.serializers import *
from markets.models import MarketProfile
from products.models import Product


class CustomSearchFilter(filters.SearchFilter):
    def get_search_fields(self, view, request):
        if request.query_params.get('m'):
            return ['name','bio','mclass','rating', 'location']
        else:
            return ['title','description','mclass','price', 'sclass','tags','rating', 'features']

        return super(CustomSearchFilter, self).get_search_fields(view, request)




#self.kwargs['username']
class SearchView(ListAPIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    pagination_class = PageNumberPagination
    filter_backends = (CustomSearchFilter, OrderingFilter)
    
    def get_serializer_class(self):
        if self.request.query_params.get('m'):
            return MarketProfileSer
        return ProductSer

    def get_queryset(self):
        if self.request.query_params.get('m'):
            ags =   {}
            if self.request.query_params.get('mclass'):
                ags.update({ 'mclass': [self.request.query_params.get('mclass')],})
            if self.request.query_params.get('location'):
                ags.update({ 'location': {self.request.query_params.get('location')},})
            if self.request.query_params.get('rating'):
                ags.update({ 'rating': self.request.query_params.get('rating'),})
            

            return MarketProfile.objects.filter(**ags)
        else:
            ags =   {}
            if self.request.query_params.get('price'):
                ags.update({ 'price': self.request.query_params.get('price'),})
            if self.request.query_params.get('market'):
                ags.update({ 'market': self.request.query_params.get('market'),})
            if self.request.query_params.get('mclass'):
                ags.update({ 'mclass': self.request.query_params.get('mclass'),})
            if self.request.query_params.get('sclass'):
                ags.update({ 'sclass': self.request.query_params.get('sclass'),})
            if self.request.query_params.get('tags'):
                ags.update({ 'tags': [self.request.query_params.get('tags')],})
            if self.request.query_params.get('rating'):
                ags.update({ 'rating': self.request.query_params.get('rating'),})
            if self.request.query_params.get('features'):
                ags.update({ 'features': self.request.query_params.get('features'),})
            if self.request.query_params.get('location'):
                ags.update({ 'location': {self.request.query_params.get('location')},})



            return Product.objects.filter(**ags)

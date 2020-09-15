from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.http import HttpResponse
from markets.models import MarketProfile 
from products.models import Product
from rest_framework.authtoken.models import Token
import requests as req
from math import ceil


def home(request):  # TODO
    return render(request, 'core/home.html')



def search(request): # for DEV use Only 
    if request.method == 'GET' and request.user.is_authenticated:
        
        if not Token.objects.filter(user = request.user).exists():
            token = Token.objects.create(user=request.user)
        else:
            token = Token.objects.get(user=request.user)


        auth = {'Authorization':'Token '+ token.key  }  
        results =   req.get( 'https://' + request.META['HTTP_HOST'] + '/api/search',headers=auth,params=request.GET).json()
        return render(request,'core/search.html',{'results': results,'range': range(ceil(results['count'] / 10) )   } )
    return redirect ('/login')


def loginuser(request):

    error = ''
    if request.method == 'GET':
        if request.user.is_authenticated:
            return redirect('/')
        return render(request, 'core/loginuser.html')
    else:
        user = authenticate(
            username=request.POST['username'], password=request.POST['password'])

        if user is not None:
            login(request, user)
            return redirect('/')
        else:
            if User.objects.filter(username=request.POST['username']).exists():
                error = 'Wrong Username / Password'
            else:
                error = 'Username (' + \
                    request.POST['username'] + ') is not registerd'
        return render(request, 'core/loginuser.html', {'error': error})


def logoutuser(request):
    if request.method == 'POST':
        if request.user.is_authenticated:
            logout(request)
            return redirect('/')
        else:
            return HttpResponse('Not Logged in')


def signupuser(request):
    if request.method == 'GET':
        if request.user.is_authenticated:
            return redirect('/')
        return render(request, 'core/signupuser.html')
    else:
        if request.POST['password1'] == request.POST['password2']:
            if User.objects.filter(username=request.POST['username']).exists():
                return render(request, 'core/signupuser.html', {'error': 'Username already taken'})

            user = User.objects.create_user(
                username=request.POST['username'], password=request.POST['password1'])
            user.save()
            login(request, user=user)
            return redirect('/')
        else:
            return render(request, 'core/signupuser.html', {'error': 'Mismatched Passwords, try again'})


def market(request):
    if request.method == 'GET':
        if request.user.is_authenticated:
            markets =   MarketProfile.objects.all() 
            return render (request, 'core/market.html', {'markets': markets}) 
        else:
            return redirect('/login')
    return redirect ('/')


def mymarket(request):
    if request.method == 'GET':
        if request.user.is_authenticated and MarketProfile.objects.filter(user=request.user.id).exists(): #has a market
            market =   MarketProfile.objects.filter(user=request.user.id).first() # first in case of many market (tests)
            return redirect ("/market/" + str(market.id)) 
        else:
            return redirect('/login')
    return redirect ('/')


def product(request):
    if request.method == 'GET':
        if request.user.is_authenticated:
            products =   Product.objects.all() 
            return render (request, 'core/product.html', {'products': products}) 
        else:
            return redirect('/login')
    return redirect ('/')

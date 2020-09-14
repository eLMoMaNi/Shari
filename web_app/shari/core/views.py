from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.http import HttpResponse


def home(request):  # TODO
    return render(request, 'core/home.html')


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

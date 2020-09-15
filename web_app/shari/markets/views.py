from django.shortcuts import render,redirect
from .models import MarketProfile
from products.models import Product
from django.http import HttpResponse, HttpResponseNotFound
import json
# Create your views here.

def create(request):
    if request.method == 'GET':
        if not request.user.is_authenticated:
            return redirect('/login')
        if not MarketProfile.objects.filter(user=request.user).exists():
            return render(request,'markets/create.html')
        else:
            return redirect('/market/' + str(MarketProfile.objects.filter(user=request.user).first().id ) )
    else:
        if request.user.is_authenticated:
            if MarketProfile.objects.filter(name=request.POST['name']).exists():
                error   =   'Market Name Already Taken, Try another name'
                return render(request,'markets/create.html', {'error':error})
            else:
                mclass = []
                for i in request.POST:
                    if i == 'Food' or i == 'Grocery' or i == 'Clothes' or i == 'Handicraft' or i == 'Pharmacies'  or i == 'Other'  : 
                        mclass.append(i)


                market  =   MarketProfile(
                    user    =   request.user,
                    name    =   request.POST['name'],
                    number  =   request.POST['number'],
                    bio     =   request.POST['bio'],
                    location=   { 'test': request.POST['location']} ,
                    pic     =   request.FILES.get( 'pic', None ),
                    wall_pic=   request.FILES.get( 'wall_pic', None ),
                    layout  =   { 'test': True} ,

                    mclass  =   mclass
                    )
                #TODO: market.validate
                
                market.save()                
                #return HttpResponse(request.FILES['pic'])
                return redirect('/market/'+ str(market.id) )
        else:
            return render(request,'markets/create.html', {'error':"log in first"}) 
 

def show(request,id):
    if request.method == 'GET':
        if MarketProfile.objects.filter(id=id).exists():
            market  =   MarketProfile.objects.get(id=id)
            return render(request,'markets/profile.html', {'market':market, 'products': Product.objects.filter(market=market) })
    return HttpResponseNotFound('page not found')



def edit(request):

    if MarketProfile.objects.filter(user=request.user).exists():
        market  =   MarketProfile.objects.filter(user=request.user).first()    

        if request.method == 'GET':
            return render(request,'markets/edit.html')
        else:
            mclass= []
            for i in request.POST:
                if i == 'Food' or i == 'Grocery' or i == 'Clothes' or i == 'Handicraft' or i == 'Pharmacies'  or i == 'Other'  : 
                    mclass.append(i)

            market.name     =   request.POST['name']
            market.number   =   request.POST['number']
            market.location =   { 'test': request.POST['location']} ,
            market.pic      =   request.FILES.get( 'pic', None )
            market.wall_pic =   request.FILES.get( 'wall_pic', None )
            market.mclass   =   mclass
            market.bio      =   request.POST['bio']

            #TODO: market.validate
            
            market.save()
            return redirect('/market/'+ str(market.id) )     
    return HttpResponse("You don't have a market profile ")

def delete(request):
    if request.method == 'POST':
        if MarketProfile.objects.filter(user=request.user).exists():
            market  =   MarketProfile.objects.get(user=request.user)
            market.pic.delete()
            market.wall_pic.delete()
            market.delete()
            return redirect('/')
        else: 
            return HttpResponse("You don't have market profile ")
    return HttpResponseNotFound()


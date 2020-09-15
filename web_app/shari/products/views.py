from django.shortcuts import render, redirect
from .models import Product, ProductImg
from markets.models import MarketProfile
from django.http import HttpResponse, HttpResponseNotFound
import json
# Create your views here.


def create(request):
    if request.method == 'GET':
        if not request.user.is_authenticated:
            return redirect('/login')
        if not MarketProfile.objects.filter(user=request.user).exists():
            return redirect('/market/create')
        return render(request, 'products/create.html')
    else:
        his_market = MarketProfile.objects.filter(user=request.user).first()
        mclass = request.POST['mclass']

        mc = 'Food' if mclass == 'fo' else '', 'Grocery' if mclass == 'gr' else '', 'Clothes' if mclass == 'cl' else '','Handicraft' if mclass == 'ha' else '', 'Pharmacies' if mclass == 'ph' else '', 'Other' if mclass == 'ot' else ''
        for i in mc:
            if i :
                mclass=i
        
        product = Product(
            market=his_market,
            title=request.POST['title'],
            description=request.POST['description'],
            price=request.POST['price'],

            wall_pic=request.FILES.get('wall_pic', None),#request.FILES.get('pics', [])

            mclass= mclass,
            sclass=request.POST['sclass'],
            tags=request.POST['tags'].split(","),
        )
        #TODO: product.validate

        product.save()

        for pic in request.FILES.getlist('pics', None):
            img =   ProductImg(pic=pic, product=product)
            img.save()
        # return HttpResponse(request.FILES['pic'])
        return redirect('/product/' + str(product.id))


def show(request, id):
    if request.method == 'GET':
        if not request.user.is_authenticated:
            return redirect('/login')

        if Product.objects.filter(id=id).exists():
            product = Product.objects.get(id=id)
            imgs    = ProductImg.objects.filter(product=product)

            return render(request, 'products/show.html', {'product': product, 'imgs':imgs})

    return HttpResponseNotFound('page not found 404')


def edit(request, id):

    if not Product.objects.filter(id=id).exists():
        return HttpResponse("Page not found 404 ")

    if request.method == 'GET':
        return render(request, 'products/edit.html')
    else:
        product = Product.objects.get(id=id)
        
        if request.user == product.market.user:
            
            old_id  = Product.objects.get(id=id).id
            product.delete()
            
            mclass = request.POST['mclass']
            product=    Product(
            title = request.POST['title'],
            description = request.POST['description'],
            price = request.POST['price'],

            wall_pic = request.FILES.get('wall_pic', None),
            sclass = request.POST['sclass'],
            tags = request.POST['tags'].split(","),

            )

            mc     =  'Food' if mclass == 'fo' else '', 'Grocery' if mclass == 'gr' else '', 'Clothes' if mclass == 'cl' else '','Handicraft' if mclass == 'ha' else '', 'Pharmacies' if mclass == 'ph' else '', 'Other' if mclass == 'ot' else ''
            for i in mc:
                if i :
                    mclass=i
            product.mclass=mclass

            product.save()

            for pic in request.FILES.getlist('pics', None):
                img =   ProductImg(pic=pic, product=product)
                img.save()
                
            return redirect('/product/' + str(product.id))


def delete(request, id):
    if request.method == 'POST':

        if not Product.objects.filter(id=id).exists():
            return HttpResponse("Page not found 404")
        else:
            product = Product.objects.get(id=id)

            if request.user == product.market.user:
                product.pics.delete()
                product.wall_pic.delete()
                product.delete()
                return redirect('/')
            else:
                return HttpResponse("You can't change others' products")
    else:
        return HttpResponse("Page not found 404")

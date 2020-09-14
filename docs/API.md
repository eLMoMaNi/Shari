# login/singup
* /api/login?username=&password=
* /api/signup?username=&password=
returns :
    {
    "token": [token]
    }
note: for now, user token is unique but consistent, and should always be passed in the Authorization Header as follow.
___
# Authorization Header
#### Syntax  
  
>"Authorization: Token <credentials>"

#### example
>curl -H  "Authorization: Token mytoken12345" <ShariHost>/api/search

    Note the space betwwen Token and mytoken12345
___

# user
##### NOTE: always pass auth token in the header
### available methods
* /api/user/myprofile
	* *POST*: Create user profile for exist user (Optinal)
		* sent body: {"firstname","lastname", "pic", "number", <"password"> }
		* recived body: New user profile object if success
	* *GET*: get user profile object for logged user (based on the token)
		* recived body:  {"firstname","lastname", "pic", "number", "user": ID }
	* *PUT*: Edit exist user profile
		* sent body: {"firstname","lastname", "pic", "number", <"password"> }
		* recived body: Changed user profile object if success
	* *DELETE*: Delete exist user profile
		* recived body: Success message or error

* /api/user/<id>
	* *GET*: get user profile object  (based on the id)
		* recived body:  {"firstname","lastname", "pic", <"number"> }
___

# market

##### NOTE: always pass auth token in the header
* /api/market/myprofile
	* *POST*: Create Market profile for exist user (Optinal)
		* sent body: {"name","bio", "pic", "number", "location", <"wall_pic">, "mclass" : Array }
		* recived body: New market profile object if success
	* *GET*: get Market profile object for logged user (based on the token)
		* recived body:  { "id", "name","bio", "pic", "number", "location", "rating", "layout", "user" : ID  , <"wall_pic">, "mclass" : Array }
	* *PUT*: Edit exist market profile
		* sent body: {"firstname","lastname", "pic", "number", <"password"> }
		* recived body: Changed user profile object if success
	* *DELETE*: Delete exist user profile
		* recived body: Success message or error

* /api/market/<id>
	* *GET*: get user profile object  (based on the id)
		* recived body:  { "id", "name","bio", "pic", "number", "location", "rating", "layout", "user" : ID  , <"wall_pic">, "mclass" : Array of categories }

___

# product

##### NOTE: always pass auth token in the header

* /api/product
	* *POST*: Create new product  (based on the token of the user having a market profile)
    	* sent body: {"title", "description", "price", "pics", "wall_pic" : Featured img , "mclass" : category , "sclass" : sub-category , "tags"}
		* recived body:  Created product object if success 


* /api/product/<id>
	* *GET*: Get product object  (based on the id)
		* recived body:  {"title", "description", "price", "pics", "wall_pic" : Featured img , "mclass" : category , "sclass" : sub-category , "tags", "rating", "market": ID }
	* *PUT*: Edit exist product
		* sent body: {"title", "description", "price", "pics", "wall_pic" : Featured img , "mclass" : category , "sclass" : sub-category , "tags"}
		* recived body: Changed product object if success
	* *DELETE*: Delete exist product object
		* recived body: Success message or error


##### NOTE: All objects of User, User Profile, Market Profile and Product has two date attribute.

.

    created_at: date of object creation         in form of YYYY-MM-DDTHH:MM:SS
    updated_at: date of object last modified    in form of YYYY-MM-DDTHH:MM:SS
___
# Search
#####  /api/search (GET)

* #### Parameters
    * ##### ?m=1 (Search in market profiles instead of products)
    * ##### ?search=<string to search for>
    * ##### ?ordering=<name of column to order by>
    * ##### ?attr=<value of attr to filter with>
    * ##### ?page=<number of page> 


##### market attrs : mclass location

##### Product attrs :  location market mclass sclass    

.
#### example

> /api/search?search=shawrma&ordering=-rating&location=amman&page=1

This will search for  "shawrma"  in amman ordered by higher rating  

    Note that the minus in -rating indicates ordering from higher to lower 

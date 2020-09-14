import random


def glob(request): 
    rand        =   random.randint(1,8)
    return { 'rand': rand  } 
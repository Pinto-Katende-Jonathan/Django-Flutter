import base64
from datetime import datetime
import uuid
import jwt
from django.conf import settings

def date_convert(date):
    if '/' in date:
        return datetime.strptime(date, '%Y/%m/%d').date()
    elif ('-' in date) and (' ' in date):
        try:
            return datetime.strptime(date.split(' ')[0], '%Y-%m-%d').date() 
        except:
            return
    else:
        return datetime.strptime(date, '%Y-%m-%d').date()

def random_name():
    return f"{uuid.uuid4().hex}{'.png'}"


def image_preprocessing(image):
    if(image == None):
        return
    return base64.b64decode(image)


def generate_access_token(user):

    access_token_payload = {
        'user_id': user.id
    }
    access_token = jwt.encode(access_token_payload,
                              settings.SECRET_KEY, algorithm='HS256')
    return access_token
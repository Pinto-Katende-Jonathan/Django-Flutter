from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Publication, Discussion, CustomUser

# Register your models here.
admin.site.register(Publication)
admin.site.register(Discussion)
admin.site.register(CustomUser,UserAdmin)
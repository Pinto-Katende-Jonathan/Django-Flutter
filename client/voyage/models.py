from django.core.validators import MinLengthValidator
from django.db import models
# from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractUser

from django.conf import settings
User = settings.AUTH_USER_MODEL

# -------- Custom user ------------------------- #
class CustomUser(AbstractUser):

    ROLES = (
        ('admin', 'Administrateur'),
        ('client', 'Client'),
        ('chauffeur', 'Chauffeur'),
    )

    GENDERS = (
        ('masculin', 'Masculin'),
        ('feminin', 'Féminin'),
    )

    telephone = models.CharField(max_length=10,validators=[MinLengthValidator(10)], blank=True, null=True, unique=True)
    role = models.CharField(max_length=10, choices=ROLES, default='client')
    genre = models.CharField(max_length=10, choices=GENDERS, default='masculin')
    plaque = models.CharField(max_length=20, blank=True, null=True)
    type_voiture = models.CharField(max_length=50, blank=True, null=True)
    photo_voiture = models.FileField(blank=True, null=True, default='defaul.jpg')
    #photo_voiture = models.ImageField(upload_to='photos_voitures/', blank=True, null=True)

    # Ajouter les arguments related_name pour éviter les conflits d'accès entre auth.User et voyage.User
    groups = models.ManyToManyField("auth.Group", related_name="users_voyage", blank=True)
    user_permissions = models.ManyToManyField(
        "auth.Permission",
        related_name="users_voyage",
        verbose_name="user permissions",
        blank=True,
    )

# ========================================
class Publication(models.Model):
    depart = models.CharField(max_length=255)
    destination = models.CharField(max_length=255)
    #pub_img = models.ImageField(null=True)
    date_voyage = models.DateField()
    user_id = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return f"Pub {self.id} msg({self.discussion_set.count()})"
        # self.discussion_set.count() : ici on compte le nombre des discussions que contient la publication


class Discussion(models.Model):
    message = models.TextField(max_length=100000, blank=False, null=False)
    date_msg = models.DateTimeField(auto_now_add=True, blank=True)
    pub_id = models.ForeignKey(Publication, on_delete=models.CASCADE)
    user_id = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return f"msg from {self.user_id.username} related to pub {self.pub_id}"
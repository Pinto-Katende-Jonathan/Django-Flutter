# Generated by Django 4.2 on 2023-06-16 11:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('voyage', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='customuser',
            name='photo_voiture',
            field=models.FileField(blank=True, default='defaul.jpg', null=True, upload_to=''),
        ),
    ]

import uuid
from django.db import models
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _
from ApiPianta.models import User

# Create your models here.
class Project(models.Model):
    id = models.AutoField(primary_key= True)
    idrandom = models.UUIDField(default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=300, blank = False, null= False)
    location = models.CharField(max_length=100, blank = False, null= False)
    description = models.CharField(max_length=300, blank = False, null= False)
    relationUserProject = models.ForeignKey(User, on_delete=models.CASCADE, related_name='projects', default=None)
    
class Devices(models.Model):
    id = models.AutoField(primary_key= True)
    name = models.CharField(max_length=30, blank = False, null= False)
    location = models.CharField(max_length=100, blank = False, null= False)

class Template(models.Model):
    id = models.AutoField(primary_key= True)
    name = models.CharField(max_length=30, blank = False, null= False)
    sensor = models.CharField(max_length=50,blank = False, null= False)
    red = models.CharField(max_length=50, blank = False, null= False)  
    descripcion = models.CharField(max_length=100, blank = False, null= False)
# Create your models here.
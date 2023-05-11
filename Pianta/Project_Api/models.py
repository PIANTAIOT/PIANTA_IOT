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
    location = models.CharField(max_length=100, blank = False, null= False, )
    description = models.CharField(max_length=300, blank = False, null= False)
    relationUserProject = models.ForeignKey(User, on_delete=models.CASCADE, related_name='projects', default=None)
#class maps(models.Model)
class SharedProject(models.Model):
    id = models.AutoField(primary_key= True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)
    
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

class DatosSensores(models.Model):
    name = models.CharField(max_length=255)
    v1 = models.FloatField()
    v2 = models.FloatField()
    v3 = models.FloatField()
    v4 = models.FloatField()
    v5 = models.FloatField()
    v6 = models.FloatField()
    v7 = models.FloatField()
    v8 = models.FloatField()
    v9 = models.FloatField()
    v10 = models.FloatField()
    v11 = models.FloatField()
    v12 = models.FloatField()
    created_at = models.DateTimeField()

    def _str_(self):
        return f"{self.name} - {self.valor}"
    def save(self, *args, **kwargs):
        # Establecer la zona horaria correspondiente a Colombia
        timezone = pytz.timezone('America/Bogota')
        
        # Obtener la fecha y hora actual con la zona horaria del servidor
        now = datetime.now()

        # Convertir la fecha y hora actual a la zona horaria de Colombia
        colombia_time = timezone.localize(now)

        # Ajustar la hora para tener en cuenta la diferencia horaria con UTC
        adjusted_time = colombia_time - timedelta(hours=5)

        # Establecer el campo created_at con la hora ajustada
        self.created_at = adjusted_time
        super().save(*args, **kwargs)
# Create your models here.
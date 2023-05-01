
from django.contrib import admin

from Project_Api.models import Devices, Project, Template

# Register your models here.

class ProjectAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "location",
        "description",
    )
class DevicesAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "name",
        "location",
        
    )

class TemplateAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "name",
        "sensor",
        "red",    
        "descripcion",     

    )

admin.site.register(Project, ProjectAdmin)
admin.site.register(Devices, DevicesAdmin )
admin.site.register(Template, TemplateAdmin )
# Register your models here.

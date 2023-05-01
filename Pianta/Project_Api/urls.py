from django.urls import path
from Project_Api import views
from .views import DevicesListApiView, ProjectDetailApiView, ProjectListApiView, DevicesDetailApiView, TemplateDetailApiView, TemplateListApiView, SharedProjectView, obtener_datos_sensores, save_DatosSensores#, SharedrandonView

urlpatterns = [
    path('project/', ProjectListApiView.as_view(), name="Project_List"),
    path('devices/', DevicesListApiView.as_view(), name="Devices_List"),
    path('template/', TemplateListApiView.as_view(), name="template_List"),
    path('project/<int:project_id>/', ProjectDetailApiView.as_view(), name="Project_detail"),
    #path('project/share/', SharedrandonView.as_view(), name="Project_share"),
    path('project/<str:idrandom>/detail/', SharedProjectView.as_view(), name="Project_detail_share"),
    path('devices/<int:device_id>/', DevicesDetailApiView.as_view(), name="Device_detail"),
    path('template/<int:template_id>/', TemplateDetailApiView.as_view(), name="Template_detail"),
    path('api/DatosSensores/',save_DatosSensores, name='save_DatosSensores'),
    path('datos-sensores/', obtener_datos_sensores, name='obtener_datos_sensores'),
]   
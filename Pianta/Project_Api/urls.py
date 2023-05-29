from django.urls import path
from Project_Api import views
from .views import DevicesListApiView, ProjectDetailApiView, ProjectListApiView, DevicesDetailApiView, TemplateDetailApiView, TemplateListApiView, SharedProjectView, ShareProjectView, save_DatosSensores, obtener_datos_sensores, datos_sensores, DeleteSharedProjectView, SharedProjectList, GraphicsApiView, GraphicsApiDetailView#, SharedrandonView

urlpatterns = [
    path('project/', ProjectListApiView.as_view(), name="Project_List"),
    path('devices/', DevicesListApiView.as_view(), name="Devices_List"),
    path('template/', TemplateListApiView.as_view(), name="template_List"),
    path('graphics/', GraphicsApiView.as_view(), name="graphics_list"),
    path('graphics/<int:graphics_id>/', GraphicsApiDetailView.as_view(), name="graphics_detail"),
    path('project/<int:project_id>/', ProjectDetailApiView.as_view(), name="Project_detail"),
    path('project/share/', ShareProjectView.as_view(), name='share_project'),
    path('project/detail/share/<uuid:idrandom>/', SharedProjectView.as_view(), name='project_detail_share'),
    path('project/share/<int:pk>/', DeleteSharedProjectView.as_view(), name='delete-shared-project'),
    path('relationshared/projects/', SharedProjectList.as_view(), name='shared/projects/list'),
    path('devices/<int:device_id>/', DevicesDetailApiView.as_view(), name="Device_detail"),
    path('template/<int:template_id>/', TemplateDetailApiView.as_view(), name="Template_detail"),
    path('api/DatosSensores/',save_DatosSensores, name='save_DatosSensores'),
    path('datos-sensores/', obtener_datos_sensores, name='obtener_datos_sensores'),
    path('datos-sensores/<str:field>/', datos_sensores, name='obtener_datos_sensores'),
]   
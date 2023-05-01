import json
from django.shortcuts import render
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from Project_Api.models import Devices, Project, Template
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import generics

from Project_Api.serializers import  DatosSensoresSerializer, DevicesSerializer, ProjectSerializer, TemplateSerializer#, SharedProjectValidationSerializer

from rest_framework import status
from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.views.generic.base import View

from rest_framework.response import Response
from rest_framework.renderers import JSONRenderer, TemplateHTMLRenderer

from django.http import JsonResponse

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import DatosSensores

# class SharedrandonView(View):
#     serializer_class = SharedProjectValidationSerializer
    
#     def get(self, request, *args, **kwargs):
#         serializer = self.serializer_class()
#         return JsonResponse(serializer.data, status=status.HTTP_200_OK)
    
#     def post(self, request):
#         serializer = self.serializer_class(data=request.POST)
#         if serializer.is_valid():
#             validated_data = serializer.validated_data
#             idrandom = validated_data.get('idrandom')
#             return redirect('Project_detail_share', idrandom=idrandom)
#         else:
#             return JsonResponse(serializer.errors, status=400)
        
class SharedProjectView(generics.RetrieveAPIView):
    permission_classes = (AllowAny,)
    serializer_class = ProjectSerializer
    
    def get(self, request, idrandom, format=None):
        try:
            project = Project.objects.get(idrandom=idrandom)
            serializer = self.get_serializer(project)
            return Response(serializer.data)
        except Project.DoesNotExist:
            return Response({"res": "Object with project id does not exists"},status=status.HTTP_404_NOT_FOUND)

class ProjectListApiView(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated, )
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer

    def get_queryset(self):
        return Project.objects.filter(relationUserProject=self.request.user)

    def perform_create(self, serializer):
        serializer.save(relationUserProject=self.request.user)

    def get(self, request, *args, **kwargs):
        '''
        List all the project items for given requested user
        '''
        project = Project.objects.filter(relationUserProject=request.user)
        serializer = ProjectSerializer(project, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        '''
        Create a new project with the given data
        '''
        data = {
            'idrandom': request.data.get('idrandom'),
            'name': request.data.get('name'),
            'location': request.data.get('location'),
            'description': request.data.get('description')
        }
        serializer = self.get_serializer(data=data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
    
    
class ProjectDetailApiView(APIView):
    #Método auxiliar para obtener el objecto con project_id dado
       
    def get_object(self, project_id):
        try:
            return Project.objects.get(id=project_id, relationUserProject=self.request.user)
        except Project.DoesNotExist:
            return None
    #Recupera el elemento Project con project_id dado
    def get(self, request, project_id, *args, **kwargs):
        project_instance = self.get_object(project_id)
        if not project_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST    
            )
        serializer = ProjectSerializer(project_instance)
        return Response(serializer.data, status=status.HTTP_200_OK)
    #Actualiza el elemento Project con project_id dado, si existe
    def put(self, request, project_id, *args, **kwargs):
        project_instance = self.get_object(project_id)
        if not project_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST
            )
        data ={
            'idrandom': request.data.get('idrandom'),
            'name' : request.data.get('name'),
            'location': request.data.get('location'),
            'description' : request.data.get('description'),
        }
        serializer = ProjectSerializer(
            instance = project_instance,
            data=data,
            partial = True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #Elimina el elemento Project con project_id dado, si existe
    def delete(self, request, project_id, *args, **kwargs):
        project_instance = self.get_object(project_id)
        if not project_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST
            )
        project_instance.delete()
        return Response(
            {"res": "Object deleted!"},
            status=status.HTTP_200_OK
        )   


class DevicesListApiView(APIView):
     #Lista todos los registros
    def get( self, request, *args, **kwargs):
        '''
        List all the project items for given requeted user
        '''
        devices = Devices.objects
        serializer = DevicesSerializer(devices, many=True)
        return Response(serializer.data, status= status.HTTP_200_OK)
    
    #Crea un nuevo registro
    def post(self, request, *args, **kwags):
        '''
        Create the Project wint given project data
        '''
        data = {
            'id' : request.data.get('id'),
            'name' : request.data.get('name'),
            'location': request.data.get('location'),
        }
        serializer = DevicesSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class DevicesDetailApiView(APIView):
    #Método auxiliar para obtener el objecto con project_id dado
    def get_objects(self, device_id):
        try:
            return Devices.objects.get(id= device_id)
        except Devices.DoesNotExist:
            return None
    #Recupera el elemento Project con project_id dado
    def get(self, request,device_id, *args, **kwargs):
        device_instance = self.get_objects(device_id)
        if not device_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST    
            )
        serializer = DevicesSerializer(device_instance)
        return Response(serializer.data, status=status.HTTP_200_OK)
    #Actualiza el elemento Project con project_id dado, si existe
    def put(self, request,device_id, *args, **kwargs):
        device_instance = self.get_objects(device_id)
        if not device_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST
            )
        data ={
            #'id' : request.data.get('id'),
            'name' : request.data.get('name'),
            'description': request.data.get('location'),
        }
        serializer = DevicesSerializer(
            instance = device_instance,
            data=data,
            partial = True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #Elimina el elemento Project con project_id dado, si existe
    def delete(self, request,device_id, *args, **kwargs):
        device_instance = self.get_objects(device_id)
        if not device_instance:
            return Response(
                {"res": "Object with project id does not exists"},
                status=status.HTTP_400_BAD_REQUEST
            )
        device_instance.delete()
        return Response(
            {"res": "Object deleted!"},
            status=status.HTTP_200_OK
        )   

class TemplateListApiView(APIView):
    # Lista todos los registros
    def get(self, request, *args, **kwargs):
        '''
        List all the project items for given requested user
        '''
        templates = Template.objects.all()
        serializer = TemplateSerializer(templates, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # Crea un nuevo registro
    def post(self, request, *args, **kwargs):
        '''
        Create the Project with given project data
        '''
        data = {
            'id': request.data.get('id'),
            'name': request.data.get('name'),
            'sensor': request.data.get('sensor'),
            'red' : request.data.get('red'),
            'descripcion': request.data.get('descripcion'),
        }
        serializer = TemplateSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TemplateDetailApiView(APIView):
    # Método auxiliar para obtener el objeto con project_id dado
    def get_object(self, template_id):
        try:
            return Template.objects.get(id=template_id)
        except Template.DoesNotExist:
            return None

    # Recupera el elemento Project con project_id dado
    def get(self, request, template_id, *args, **kwargs):
        template_instance = self.get_object(template_id)
        if not template_instance:
            return Response(
                {"res": "Object with template id does not exist"},
                status=status.HTTP_400_BAD_REQUEST
            )
        serializer = TemplateSerializer(template_instance)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # Actualiza el elemento Project con project_id dado, si existe
    def put(self, request, template_id, *args, **kwargs):
        template_instance = self.get_object(template_id)
        if not template_instance:
            return Response(
                {"res": "Object with template id does not exist"},
                status=status.HTTP_400_BAD_REQUEST
            )
        data = {
            'id': request.data.get('id'),
            'name': request.data.get('name'),
            'sensor': request.data.get('sensor'),
            'red' : request.data.get('red'),
            'descripcion': request.data.get('descripcion'),
        }
        serializer = TemplateSerializer(
            instance=template_instance,
            data=data,
            partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # Elimina el elemento Project con project_id dado, si existe
    def delete(self, request, template_id, *args, **kwargs):
        template_instance = self.get_object(template_id)
        if not template_instance:
            return Response(
                {"res": "Object with template id does not exist"},
                status=status.HTTP_400_BAD_REQUEST
            )
        template_instance.delete()
        return Response(
            {"res": "Object deleted!"},
            status=status.HTTP_200_OK
        )

# Create your views here.
@csrf_exempt
def save_DatosSensores(request):
    if request.method == 'POST':
        # Obtener los datos de la solicitud POST en formato JSON
        data = request.body.decode('utf-8')
        
        # Convertir los datos de JSON a un diccionario de Python
        data_dict = json.loads(data)
        
        # Obtener los valores de los sensores del diccionario
        namePerson = data_dict.get('name', '')
        sensor1_value = data_dict.get('v1', 0)
        sensor2_value = data_dict.get('v2', 0)
        sensor3_value = data_dict.get('v3', 0)
        sensor4_value = data_dict.get('v4', 0)
        sensor5_value = data_dict.get('v5', 0)
        sensor6_value = data_dict.get('v6', 0)
        sensor7_value = data_dict.get('v7', 0)
        sensor8_value = data_dict.get('v8', 0)
        sensor9_value = data_dict.get('v9', 0)
        sensor10_value = data_dict.get('v10', 0)
        sensor11_value = data_dict.get('v11', 0)
        sensor12_value = data_dict.get('v12', 0)
        
        # Guardar los valores de los sensores en la base de datos
        datos_sensores = DatosSensores(v1=sensor1_value, v2=sensor2_value,v3=sensor3_value,v4=sensor4_value,v5=sensor5_value,v6=sensor6_value,v7=sensor7_value,v8=sensor8_value,v9=sensor9_value,v10=sensor10_value,v11=sensor11_value,v12=sensor12_value,name=namePerson )
        datos_sensores.save()
        
        # Devolver una respuesta exitosa
        response_data = {'status': 'success'}
        return JsonResponse(response_data)
    
    # Devolver una respuesta de error si la solicitud no es POST
    response_data = {'status': 'error', 'message': 'Metodo no permitido'}
    return JsonResponse(response_data, status=405)

@api_view(['GET'])
def obtener_datos_sensores(request):
    datos_sensores = DatosSensores.objects.all().order_by('created_at')
    serializer = DatosSensoresSerializer(datos_sensores, many=True)
    return Response(serializer.data)
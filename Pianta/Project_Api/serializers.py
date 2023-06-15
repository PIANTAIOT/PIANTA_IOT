from rest_framework import serializers
from .models import Devices, Project, Template, DatosSensores, SharedProject, graphics



# class SharedProjectValidationSerializer(serializers.Serializer):
#     idrandom = serializers.CharField()

#     def validate_idrandom(self, value):
#         try:
#             project = Project.objects.get(idrandom=value)
#         except Project.DoesNotExist:
#             raise serializers.ValidationError("Invalid idrandom")
#         return value

class SharedRelationSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(read_only=True)
    class Meta:
        model = SharedProject
        fields = ['id', 'user', 'project', 'timestamp']
        
class ShareProjectSerializer(serializers.Serializer):
    idrandom = serializers.CharField(max_length=300)
    
class ProjectSerializer(serializers.ModelSerializer):
    relationUserProject = serializers.ReadOnlyField(source='relationUserProject.username')

    class Meta:
        model = Project
        fields = ['id', 'idrandom', 'name', 'location', 'description', 'relationUserProject']
        read_only_fields = ['id']

    def create(self, validated_data):
        # Obtenemos el usuario autenticado de la solicitud
        user = self.context["request"].user
        # Establecemos el valor de relationUserProject en el usuario autenticado
        validated_data["relationUserProject"] = user
        # Creamos el objeto Project usando los datos validados actualizados
        project = Project.objects.create(**validated_data)
        return project

class DevicesSerializer(serializers.ModelSerializer):
    relationUserDevice = serializers.ReadOnlyField(source='relationUserDevice.username')
    class Meta:
        model = Devices
        fields = [
            "id",
            "name",
            "location",
            "relationUserDevice",
        ]
        read_only_fields = ['id']
    
    def create(self, validated_data):
        # Obtenemos el usuario autenticado de la solicitud
        user = self.context["request"].user
        # Establecemos el valor de relationUserDevice en el usuario autenticado
        validated_data["relationUserDevice"] = user
        # Creamos el objeto relationUserDevice usando los datos validados actualizados
        devices = Devices.objects.create(**validated_data)
        return devices
    
    
class TemplateSerializer(serializers.ModelSerializer):
    relationUserTemplate = serializers.ReadOnlyField(source='relationUserTemplate.username')
    class Meta:
        model = Template
        fields = [
            "id",
            "name",
            "sensor",
            "red",
            "descripcion",
            "relationUserTemplate",
        ]
        read_only_fields = ['id']
        
    def create(self, validated_data):
        # Obtenemos el usuario autenticado de la solicitud
        user = self.context["request"].user
        # Establecemos el valor de relationUserDevice en el usuario autenticado
        validated_data["relationUserTemplate"] = user
        # Creamos el objeto relationUserDevice usando los datos validados actualizados
        template = Template.objects.create(**validated_data)
        return template
    
        
class DatosSensoresSerializer(serializers.ModelSerializer):
    class Meta:
        model = DatosSensores
        fields = ['name', 'created_at', 'v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12']
        read_only_fields = ['name', 'created_at', 'v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12']
        
class GraphicsSerializer(serializers.ModelSerializer):
    relationUserGraphics = serializers.ReadOnlyField(source='relationUserGraphics.username')
    class Meta:
        model = graphics
        fields = [
            "id",
            "titlegraphics",
            "namegraphics",
            "aliasgraphics",
            "location",
            "relationUserGraphics",
        ]
        read_only_fields = ['id']
    def create(self, validated_data):
        # Obtenemos el usuario autenticado de la solicitud
        user = self.context["request"].user
        # Establecemos el valor de relationUserDevice en el usuario autenticado
        validated_data["relationUserGraphics"] = user
        # Creamos el objeto relationUserDevice usando los datos validados actualizados
        graphicsx = graphics.objects.create(**validated_data)
        return graphicsx
    

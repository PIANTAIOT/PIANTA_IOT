from rest_framework import serializers
from .models import DatosSensores, Devices, Project, Template



# class SharedProjectValidationSerializer(serializers.Serializer):
#     idrandom = serializers.CharField()

#     def validate_idrandom(self, value):
#         try:
#             project = Project.objects.get(idrandom=value)
#         except Project.DoesNotExist:
#             raise serializers.ValidationError("Invalid idrandom")
#         return value
    
    
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
    class Meta:
        model = Devices
        fields = (
            "id",
            "name",
            "location",
        )
    
class TemplateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Template
        fields = (
            "id",
            "name",
            "sensor",
            "red",
            "descripcion",
        )

class DatosSensoresSerializer(serializers.ModelSerializer):
    class Meta:
        model = DatosSensores
        fields = ['name', 'created_at', 'v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12']
        read_only_fields = ['name', 'created_at', 'v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12']
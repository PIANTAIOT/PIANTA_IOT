# Generated by Django 4.1.3 on 2023-04-30 15:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Project_Api', '0003_alter_project_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='DatosSensores',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('v1', models.FloatField()),
                ('v2', models.FloatField()),
                ('v3', models.FloatField()),
                ('v4', models.FloatField()),
                ('v5', models.FloatField()),
                ('v6', models.FloatField()),
                ('v7', models.FloatField()),
                ('v8', models.FloatField()),
                ('v9', models.FloatField()),
                ('v10', models.FloatField()),
                ('v11', models.FloatField()),
                ('v12', models.FloatField()),
                ('created_at', models.DateTimeField()),
            ],
        ),
    ]

# Generated by Django 4.1.7 on 2023-06-10 22:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Project_Api', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='graphics',
            name='location',
            field=models.CharField(max_length=1000, null=True),
        ),
    ]
from rest_framework import serializers
from dj_rest_auth.serializers  import LoginSerializer

from django.contrib.auth import get_user_model

#from django.contrib.auth.models import User
from django.db import transaction
from django.utils.translation import gettext as _
from django.conf import settings
from dj_rest_auth.registration.serializers import RegisterSerializer


from django.contrib.auth import authenticate, get_user_model
from rest_framework.authtoken.models import Token

from rest_framework.exceptions import ValidationError
from django.core.mail import send_mail
from dj_rest_auth.serializers import LoginSerializer, TokenSerializer, PasswordResetSerializer, UserDetailsSerializer

from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers

from django.contrib.auth import authenticate, get_user_model
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.encoding import smart_str, force_bytes
from django.utils.http import urlsafe_base64_encode
from django.urls import reverse
from django.core.mail import EmailMessage


UserModel=get_user_model()
from dj_rest_auth.serializers import UserDetailsSerializer

class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserModel
        fields = ('username', 'email')


# class CustomUserDetailsSerializer(UserDetailsSerializer):
#     last_login = serializers.DateTimeField(read_only=True)

#     class Meta(UserDetailsSerializer.Meta):
#         fields = UserDetailsSerializer.Meta.fields + ('last_login',)

class NewRegisterSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=UserModel._meta.get_field('username').max_length, required=False)
    email = serializers.EmailField(required=False)
    password = serializers.CharField(write_only=False, required=False)

    def create(self, validated_data):
        with transaction.atomic():
            user = UserModel.objects.create_user(
                username=validated_data['username'],
                email=validated_data['email'],
                password=validated_data['password'],
            )
            Token.objects.create(user=user)
        return user

# class CustomPasswordResetSerializer(PasswordResetSerializer):
#     email = serializers.EmailField()

#     def validate_email(self, value):
#         # Check if the email is registered in the database
#         try:
#             user = UserModel.objects.get(email=value)
#         except UserModel.DoesNotExist:
#             raise serializers.ValidationError(_('This email is not registered.'))
#         return value

    # def send_reset_email(self, user):
    #     uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
    #     token = PasswordResetTokenGenerator().make_token(user)
    #     reset_link = reverse('password_reset_confirm', kwargs={'uidb64': uidb64, 'token': token})
    #     reset_url = 'http://127.0.0.1:8000/' + reset_link  # Reemplaza 'your_website.com' por tu dominio
    #     message = 'Please use this link to reset your password:\n\n' + reset_url
    #     email = EmailMessage(
    #         subject='Password reset',
    #         body=message,
    #         from_email=settings.EMAIL_HOST_USER,
    #         to=[user.email],
    #     )
    #     email.send()

    # def save(self, **kwargs):
    #     # Use Django's built-in password reset mechanisms to send a reset email to the user
    #     email = self.validated_data['email']
    #     for user in UserModel.objects.filter(email=email):
    #         self.send_reset_email(user)
    #         # send_mail(
    #         #     _('Password reset'),
    #         #     _('Please click on the following link to reset your password'),
    #         #     from_email=settings.DEFAULT_FROM_EMAIL,
    #         #     recipient_list=[user.email],
    #         #     fail_silently=False,
    #         # )
                            
class NewLoginSerializer(LoginSerializer):
    pass

class NewTokenSerializer(TokenSerializer):
    pass

class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()
    
class ResetPassowrdSerializer(serializers.Serializer):
    password = serializers.CharField()
    confirm_password = serializers.CharField()
    
class CustomPasswordResetConfirmSerializer(serializers.Serializer):
    new_password1 = serializers.CharField(required=True, style={'input_type': 'password'})
    new_password2 = serializers.CharField(required=True, style={'input_type': 'password'})
    uid = serializers.CharField(required=True)
    token = serializers.CharField(required=True)
    
    def __str__(self):
        return f"CustomPasswordResetConfirmSerializer(uid={self.validated_data.get('uid')})"

    def create(self, validated_data):
        # Obtiene el uid y el token del serializer
        uid = validated_data.get('uid')
        token = validated_data.get('token')

        # Obtiene el usuario correspondiente al uid
        try:
            #uid = force_text(urlsafe_base64_decode(uid))
            user = UserModel._default_manager.get(pk=uid)
        except (TypeError, ValueError, OverflowError, UserModel.DoesNotExist):
            user = None

        # Verifica que el token sea válido
        if user is not None and default_token_generator.check_token(user, token):
            # Actualiza la contraseña del usuario
            password = validated_data.get('new_password1')
            user.set_password(password)
            user.save()
            return user

        raise ValidationError('Invalid reset password token.')
    # def create(self, validated_data):
    #     user = UserModel.objects.create_user(
    #         email=validated_data['email'],
    #         username=validated_data['username'],
    #         password=validated_data['password']
    #     )

    #     # Generate token for the new user
    #     token = Token.objects.create(user=user)

    #     # Authenticate user and login
    #     auth_user = authenticate(
    #         username=validated_data['username'],
    #         password=validated_data['password']
    #     )
    #     login(self.context['request'], auth_user)

    #     return {'token': token.key}
    
    # def save(self, request):
    #     user = super().save(request)
    #     Token.objects.create(user=user)
    #     return user
  





  # first_name=serializers.CharField()
    # last_name=serializers.CharField()
    #nickname=serializers.CharField()
    # def custom_signup(self, request, user):
        # user.first_name=request.data['first_name']
        # user.last_name=request.data['last_name']
        #user.nickname=request.data['nickname']
      #  user.save()





# class UserSerializer(serializers.ModelSerializer):
    
#     password = serializers.CharField(write_only=True)

#     class Meta:
#         model = get_user_model()
#         fields = ['id', 'username', 'email', 'password']

#     def create(self, validated_data):
#         password = validated_data.pop('password')
#         #user = get_user_model().objects.create(email=validated_data['email'], **validated_data)
#         user = get_user_model().objects.create(**validated_data)
#         user.set_password(password)
#         user.save()
#         return user



# class ProjectSerializer(serializers.ModelSerializer):
#     class Meta: 
#         model = Project
#         fields = (
#             'id',
#             'nombre',
#             'descripcion',
#         )

# class DeviceSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Device
#         fields = (
#             'nombre',
#         )
        
# class TemplateSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Template
#         fields = (
#             'namehardware',
#             'descripcionTemplate',
#         )
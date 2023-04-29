from django.shortcuts import render
from rest_framework import generics
from django.urls import reverse_lazy
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.views.decorators.csrf import csrf_protect
from django.views.generic.edit import FormView
from django.contrib.auth import login, logout, authenticate
from django.http import HttpResponseRedirect
from django.contrib.auth.forms import AuthenticationForm
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
# from .serializers import UserSerializer
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from rest_framework.permissions import AllowAny
#from .serializers import UserSerializer

from django.http import HttpResponse
from datetime import timedelta

from django.utils import timezone
from django.conf import settings
# from celery.decorators import periodic_task
# from celery.task.schedules import crontab
from .models import TokensEmail
# from django_otp import devices_for_user
# from django_otp.plugins.otp_totp.models import TOTPDevice
# from django_otp.oath import totp
# from .models import Project, Device, Template
# Create your views here.
from django.core.mail import send_mail
from .models import User , TokensEmail

from rest_framework.authtoken.views import ObtainAuthToken
from django.shortcuts import render
from django.core.mail import send_mail
import random
import json


from rest_framework import generics, status
from rest_framework.response import Response
from django.db import IntegrityError

#from .serializers import UserSerializer
from .models import User

from django.contrib.auth import authenticate, login
from .serializers import NewRegisterSerializer,NewLoginSerializer, ResetPassowrdSerializer, UserUpdateSerializer#, CustomPasswordResetSerializer

from django.core.mail import send_mail
from django.urls import reverse

from django.contrib.auth import views as auth_views

from django.contrib.auth.tokens import default_token_generator
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode

from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from django.http import HttpResponse
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import ForgotPasswordSerializer
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.models import User
from django.core.mail import send_mail
from django.urls import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.exceptions import ValidationError
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError

from django.urls import reverse_lazy
from django.utils.decorators import method_decorator
from django.views.decorators.debug import sensitive_post_parameters

from django.core.exceptions import ValidationError
from django.shortcuts import render
from django.shortcuts import get_object_or_404
from django.views.generic.edit import FormView
from django.utils.http import urlsafe_base64_decode
from django.template.loader import render_to_string
from django.http import HttpResponse
import django
from django.utils.encoding import force_bytes, force_str
from django.shortcuts import redirect
from .forms import CustomPasswordResetForm
from dj_rest_auth.views import (
    PasswordResetView, 
    PasswordResetConfirmView, 
    PasswordChangeView,
    LoginView,
    UserDetailsView
)
from django.contrib import messages
from django.utils.translation import gettext_lazy as _

from django.views.generic import TemplateView

from dj_rest_auth.views import PasswordResetView
from django.utils.translation import gettext as _
from dj_rest_auth import serializers as api_settings

# class CustomPasswordResetCompleteView(TemplateView):
#     template_name = 'password_reset_confirm.html'

User = get_user_model()

class MyUserDetailsView(UserDetailsView):
    serializer_class = UserUpdateSerializer
    permission_classes = (IsAuthenticated,)
    # def get_object(self):
    #     return self.request.user
    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)
# def user_edit_view(request, pk):
#     user = get_object_or_404(User, pk=pk)
#     if request.method == 'POST':
#         form = UserEditForm(request.POST, instance=user)
#         if form.is_valid():
#             form.save()
#             return redirect('user_detail', pk=user.pk)
#     else:
#         form = UserEditForm(instance=user)
#         context = {
#         'user': user,
#     }
#     return render(request, 'user_edit.html', {'form': form})
class CustomPasswordResetConfirmView(PasswordResetConfirmView):
    template_name = 'password_reset.html'
    form_class = CustomPasswordResetForm
    queryset = User.objects.all()
    success_url = reverse_lazy('password_reset_complete')

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        context = {
            'uid': self.kwargs['uidb64'],
            'uidb64': self.kwargs['uidb64'],
            'token': self.kwargs['token'],
            'csrf_token': django.middleware.csrf.get_token(request),
        }
        form = self.form_class(uid=self.kwargs['uidb64'], initial={
            'uid': self.kwargs['uidb64'],
        })
        form.fields['uid'].initial = kwargs['uidb64']
        context['form'] = form
        return render(request, self.template_name, context)

    def get_object(self, queryset=None):
        uidb64 = self.kwargs.get('uidb64')
        token = self.kwargs.get('token')
        if queryset is None:
            queryset = self.get_queryset()
            uidb64 = self.kwargs.get('uidb64')
        try:
            uid = urlsafe_base64_decode(uidb64).decode()
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None
        return user
    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        context = {
            'message': _('Your password has been reset successfully.'),
        }
        return render(request, 'password_reset_confirm.html', context=context)
    
# class CustomPasswordResetView(PasswordResetView):
#     def post(self, request,  *args, **kwargs):
#         email = request.data.get('email')
#         # Check if the email is registered in the database
#         users = User.objects.filter(email=email)
#         if not users.exists():
#             return Response({'error': 'El email no está registrado'}, status=status.HTTP_404_NOT_FOUND)
#         # Reset the user's password and return a success message
#         #serializer.save()
#         # Return the success message with OK HTTP status
#         return redirect('password_reset_confirm')

# class CustomPasswordResetConfirmView(PasswordResetConfirmView):
#     #success_url = reverse_lazy('password_reset_complete')    
#     def dispatch(self, request, uidb64=False, token=False, *args, **kwargs):
#         try:
#             # Comprobar si uidb64 y token son valores válidos aquí
#             # ...
#             return super().dispatch(request, uidb64=uidb64, token=token, *args, **kwargs)
#         except Exception as e:
#             # Devolver un error o redirigir a una página de error aquí
#             # ...
#             return redirect('pagina_de_error')

# class ForgotPasswordView(APIView):
#     serializer_class = ForgotPasswordSerializer
#     permission_classes = [AllowAny]

#     def post(self, request, format=None):
#         serializer = self.serializer_class(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         email = serializer.validated_data['email']
#         try:
#             user = User.objects.get(email=email)
#         except User.DoesNotExist:
#             return Response({'error': 'No user found with that email.'}, status=status.HTTP_400_BAD_REQUEST)
#         refresh = RefreshToken.for_user(user)
#         reset_url = reverse('password_reset_confirm', kwargs={
#             'uidb64': urlsafe_base64_encode(force_bytes(user.pk)),
#             'token': str(refresh.access_token),
#         })
#         reset_url = request.build_absolute_uri(reset_url)
#         message = f'Please click the following link to reset your password: {reset_url}'
#         send_mail(
#             subject='Reset your password',
#             message=message,
#             from_email='senaiot04@gmail.com',
#             recipient_list=[email],
#         )
#         return Response({'message': 'Instructions for resetting your password have been sent to your email.'}, status=status.HTTP_200_OK)





# class ResetPasswordView(APIView):
#     permission_classes = [AllowAny]

#     def put(self, request, uidb64, token, format=None):
#         password = request.data.get('password')
#         confirm_password = request.data.get('confirm_password')

#         try:
#             uid = urlsafe_base64_decode(uidb64).decode()
#             user = User.objects.get(pk=uid)
#         except (TypeError, ValueError, OverflowError, User.DoesNotExist):
#             user = None

#         if user is not None and default_token_generator.check_token(user, token):
#             if password == confirm_password:
#                 user.set_password(password)
#                 user.save()
#                 return Response({'success': 'La contraseña ha sido cambiada exitosamente.'})
#             else:
#                 return Response({'error': 'Las contraseñas no coinciden.'}, status=status.HTTP_400_BAD_REQUEST)
#         else:
#             return Response({'error': 'El enlace de recuperación de contraseña es inválido.'}, status=status.HTTP_400_BAD_REQUEST)

# from django.views.decorators.csrf import csrf_protect
# from django.contrib.auth.views import PasswordResetView

# @csrf_protect
# class CustomPasswordResetView(PasswordResetView):
#     pass



# class PasswordResetConfirmView(auth_views.PasswordResetConfirmView):
#     success_url = reverse_lazy('password_reset_complete')
    
    

# @csrf_exempt


# def reset_password(request):
#     if request.method == 'POST':
#         email = request.POST.get('email')
#         try:
#             user = User.objects.get(email=email)
#         except User.DoesNotExist:
#             return JsonResponse({'error': 'No user found with that email.'}, status=400)
#         token_generator = default_token_generator
#         token = token_generator.make_token(user)
#         uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
#         reset_url = reverse('reset_password_confirm', kwargs={'uidb64': uidb64, 'token': token}).replace('/auth/reset_password_confirm', '/auth/reset_password_confirm/')
#         reset_url = request.build_absolute_uri(reset_url)
#         message = f'Please click the following link to reset your password: {reset_url}'
#         send_mail(
#             subject='Reset your password',
#             message=message,
#             from_email='senaiot04@gmail.com',
#             recipient_list=[email],
#         )
#         return JsonResponse({'message': 'Instructions for resetting your password have been sent to your email.'})
#     else:
#         return JsonResponse({'error': 'Invalid request method.'}, status=400)


# def send_password_reset_email(request):
#     user = User.objects.get(username='username')

#     # Generar el token de reseteo de contraseña
#     token = default_token_generator.make_token(user)
#     uid = urlsafe_base64_encode(force_bytes(user.pk))
#     # Construir la URL de reseteo de contraseña
#     reset_url = reverse('password_reset_confirm', kwargs={'uidb64': uid, 'token': token})
#     reset_url = request.build_absolute_uri(reset_url)
#     # Construir el mensaje de correo electrónico
#     subject = 'Restablecer contraseña'
#     message = f'Ha recibido este correo electrónico porque ha solicitado restablecer la contraseña para su cuenta en {request.get_host()}.\n\nPor favor, vaya a la página siguiente y escoja una nueva contraseña.\n\n{reset_url}\n\nSu nombre de usuario, en caso de que lo haya olvidado: {user.username}\n\n¡Gracias por usar nuestro sitio!'
#     # Enviar el correo electrónico
#     send_mail(subject, message, None, [user.email])



class CustomLoginView(LoginView):
    def get_response_data(self, user):
        response_data = super().get_response_data(user)
        response_data['last_login'] = user.last_login
        # si el usuario acaba de iniciar sesión, actualiza last_login a la hora actual
        user.last_login = timezone.now()
        user.save()
        return response_data
    
class RegisterView(APIView):
    serializer_class = NewRegisterSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            user_exists = User.objects.filter(email=email).exists()

            if user_exists:
                return Response({'error': 'El email ya está registrado'}, status=status.HTTP_409_CONFLICT)

            # si el email es válido, verificar si el username también lo es
            username = serializer.validated_data.get('username', None)
            if username:
                username_exists = User.objects.filter(username=username).exists()
                if username_exists:
                    return Response({'error': 'El nombre de usuario ya está en uso'}, status=status.HTTP_409_CONFLICT)

            user = serializer.save()
            token, created = Token.objects.get_or_create(user=user)
            token.user = user
            token.save()
            data = {
                'user': NewLoginSerializer(user).data,
                'token': str(token)
            }
            return Response(data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class UserCreateAPIView(generics.CreateAPIView):
#     queryset = User.objects.all()
#     serializer_class = UserSerializer
#     permission_classes = [AllowAny]

#     def post(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         serializer.save(email=request.data['email'])
#         serializer.save()
#         return Response(serializer.data, status=status.HTTP_201_CREATED)


def send_registration_email(request):
    if request.method == 'POST':
        json_data = request.body.decode('utf-8')
        data = json.loads(json_data)
        #data = request.POST
        email = data.get('email')
        if email:
            token = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=6))
            subject = 'Código de verificación'
            message = f'Hola, para continuar con el registro, por favor ingrese siguiente codigo: {token}, este codigo tendra 10 minutos de caducidad, asi que usalo en este momento.'
            from_email = settings.EMAIL_HOST_USER
            recipient_list = [email]
            res = send_mail(subject, message, from_email, recipient_list, fail_silently=False)
            if res == 1:
                #guardamos el token en la base de datos 
                TokensEmail.objects.create(token=token)
                msg = "Mail Sent Successfully"
            else:
                msg = "Mail could not be sent"
            return HttpResponse(msg)
        else:
            return HttpResponse('No se proporcionó una dirección de correo electrónico en la solicitud.')
    else:
        return HttpResponse('Esta vista solo admite solicitudes POST.')
    
@csrf_exempt
def validate_token(request):
    if request.method == 'POST':
        json_data = request.body.decode('utf-8')
        data = json.loads(json_data)
        user_token = data.get('token')
        
        try:
            token_obj = TokensEmail.objects.get(token=user_token, is_valid=True)
        except Token.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Token inválido.'})

        if token_obj.is_expired():
            token_obj.is_valid = False
            token_obj.save()
            TokensEmail.create_token()
            return JsonResponse({'success': False, 'message': 'El token ha expirado.'})
        else:
            token_obj.expires_at = timezone.now() + timedelta(minutes=10)
            token_obj.save()
            
            return JsonResponse({'success': True, 'message': 'Token verificado con éxito.'})
    else:
        return JsonResponse({'success': False, 'message': 'Esta vista solo admite solicitudes POST.'})






    
    #Token de registro
    
# def validate_registration_token(request):
#     if request.method == 'POST':
#         json_data = request.body.decode('utf-8')
#         data = json.loads(json_data)
#         user_token = data.get('token')

#         # Obtener el token generado previamente
        
#         token = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#         if user_token == token:
#             # Si los tokens son iguales, entonces la verificación es exitosa
#             return HttpResponse('Token verificado con éxito.')
#         else:
#             return HttpResponse('El token no coincide.')
#     else:
#         return HttpResponse('Esta vista solo admite solicitudes POST.')



#@periodic_task(run_every=crontab(minute='*/10'))


 # if token_obj.has_expired():
        #     tokens = Token.objects.filter(is_valid=True)
        #     for token in tokens:
        #         if token.has_expired():
        #             #token.delete()
        #             token_obj.is_valid = False
        #             token_obj.save()



# @periodic_task(run_every=crontab(minute='*/10'))
# def delete_expired_tokens():
#     tokens = Token.objects.filter(is_valid=True)
#     for token in tokens:
#         if token.has_expired():
#             token.is_valid = False
#             token.save()
    
    
    
    
    #------------------------//-------------------
    # code = random.randint(100000, 999999)
    # email = request.data  
    # subject = 'Código de verificación'
    
    # message = f'Su código de verificación es: {code}'
    # from_email = settings.EMAIL_HOST_USER
    # recipient_list = [email]
    # res     = send_mail( subject, message, from_email, recipient_list, fail_silently=False)  
    # if(res == 1):  
    #     msg = "Mail Sent Successfuly"  
    # else:  
    #     msg = "Mail could not sent"  
    # return HttpResponse(msg)  
    # Generar token de registro
    #email =request.POST.get('email')
    # email = User.email
    # #email = request.POST.get('email')
    # # token = ''.join(random.choices('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=6))
    # code = random.randint(100000, 999999)
    # subject = 'Código de verificación'
    # message = f'Su código de verificación es: {code}'
    # from_email = settings.EMAIL_HOST_USER
    # recipient_list = [email]

    # # Enviar correo electrónico
    # send_mail(
    #     subject, message, from_email, recipient_list, fail_silently=False
    #     # 'Token de registro',
    #     # f'Hola, para continuar con el registro, por favor ingrese el siguiente token: {code}',
    #     # settings.EMAIL_HOST_USER,  # Remitente
    #     # [email],  # Destinatario
    #     # fail_silently=False,
    # )
    # # code = random.randint(100000, 999999)
    # # subject = 'Código de verificación'
    # # message = f'Su código de verificación es: {code}'
    # # from_email = settings.EMAIL_HOST_USER
    # # recipient_list = [email]
    # # send_mail(subject, message, from_email, recipient_list, fail_silently=False)
    
    # # Retornar respuesta exitosa
    # return HttpResponse('Correo electrónico enviado con éxito')
# import pyotp

# def generate_otp(user):
#     totp = pyotp.TOTP(user.otp_secret_key)
#     code = totp.now()
#     message = f"Your OTP is: {code}"
#     send_mail("OTP Verification", message, "pruebasgg6@gmail.com", [user.email], fail_silently=False)
#     return code




# @csrf_exempt
# @api_view(['POST'])
# def register(request):
#     email = request.data.get('email')
#     # password = request.data.get('password')

#     user = User.objects.create_user(email, email)
#     user.save()

#     device = EmailDevice.objects.create(user=user, name=email, confirmed=False)
#     devices_for_user(user, EmailDevice).exclude(pk=device.pk).delete()

#     otp_code = default_otp_service().generate_otp(device)
#     device.generate_challenge(otp_code)

#     device.send_token(otp_code)

#     return Response({'message': 'User registered successfully.'})

# class OTPView(APIView):
#     def post(self, request):
#         email = request.data.get("email")
#         code = request.data.get("code")
#         user = User.objects.get(email=email)
#         totp = pyotp.TOTP(user.otp_secret_key)
#         if totp.verify(code):
#             return Response({"success": True})
#         else:
#             return Response({"success": False})
    
# @csrf_exempt
# @api_view(['POST'])
# def verify_otp(request):
#     email = request.data.get('email')
#     code = request.data.get('code')

#     device = EmailDevice.objects.get(user__email=email, confirmed=True)
#     if default_otp_service().verify_token(device, code):
#         device.generate_challenge()
#         return Response({'success': True})
#     else:
#         return Response({'success': False})
        
        
# @api_view(['POST'])
# def send_otp(request):
#     email = request.data.get('email')
#     if not email:
#         return Response({'error': 'Email is required.'}, status=400)

#     try:
#         user = User.objects.get(email=email)
#     except User.DoesNotExist:
#         return Response({'error': 'User not found.'}, status=404)

#     otp = user.generate_otp()
#     user.otp_code = otp
#     user.otp_created_at = timezone.now()
#     user.save()

#     send_mail(
#         'OTP for login',
#         f'Your OTP is {otp}. Please enter this code to log in.',
#         'your_email@gmail.com',
#         [email],
#         fail_silently=False,
#         auth_user='pruebasgg6@gmail.com', # Reemplaza esto con tu dirección de correo electrónico autenticada
#         auth_password='Pianta123', # Reemplaza esto con la contraseña de tu dirección de correo electrónico autenticada
#     )

#     return Response({'message': 'OTP sent successfully.'}, status=200)

# @api_view(['POST'])
# def authenticate_otp(request):
#     # Obtener el correo electrónico y el código OTP proporcionados por el usuario
#     email = request.data.get('email')
#     otp = request.data.get('otp')

#     # Verificar que se proporcionaron tanto el correo electrónico como el código OTP
#     if not email or not otp:
#         return Response({'error': 'Email and OTP are required.'}, status=status.HTTP_400_BAD_REQUEST)

    # Buscar un usuario en la base de datos con el correo electrónico proporcionado
    # User = get_user_model()
    # try:
    #     user = User.objects.get(email=email)
    # except User.DoesNotExist:
    #     return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

    # Obtener el dispositivo OTP del usuario correspondiente
    # devices = devices_for_user(user)
    # device = next((dev for dev in devices if isinstance(dev, TOTPDevice)), None)

    # Verificar el código OTP proporcionado con el almacenado en la base de datos para el usuario correspondiente
    # if not device or not totp.verify(otp, device.bin_key):
    #     return Response({'error': 'Invalid OTP.'}, status=status.HTTP_400_BAD_REQUEST)

#     # Generar y devolver un token de autenticación
#     token = user.auth_token.key
#     return Response({'token': token})


# class ProjectList(generics.ListCreateAPIView):
#     queryset = Project.objects.all()
#     serializer_class = ProjectSerializer
#     permission_classes = (IsAuthenticated,)
#     authentication_class = (TokenAuthentication,)
    

# class DeviceList(generics.ListCreateAPIView):
#     queryset = Device.objects.all()
#     serializer_class = DeviceSerializer
#     permission_classes = (IsAuthenticated,)
#     authentication_class = (TokenAuthentication,)

    
# class TemplateList(generics.ListCreateAPIView):
#     queryset = Template.objects.all()
#     serializer_class = TemplateSerializer
#     permission_classes = (IsAuthenticated,)
#     authentication_class = (TokenAuthentication,)


# class Login(FormView):
#     # template_name = "login.html"
#     form_class = AuthenticationForm
#     success_url = reverse_lazy('api:project_list')
    
#     @method_decorator(csrf_protect)
#     @method_decorator(never_cache)
#     def dispatch(self, request, *args, **kwargs):
#         if request.user.is_authenticated:
#             return HttpResponseRedirect(self.get_success_url())
#         else: 
#             return super(Login, self). dispatch(request, *args, *kwargs)
    
#     def form_valid(self, form):
#         user = authenticate(username = form.cleaned_data['username'], password = form.cleaned_data['password'])  
#         token,_ = Token.objects.get_or_create(user = user)
#         if token:
#             login(self.request, form.get_user()) 
#             return super(Login, self).form_valid(form) 
        
# class Logout(APIView):
#     def get(self, request, format = None):
#         request.user.auth_token.delete()
#         logout(request)
#         return Response(status= status.HTTP_200_OK)
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, UserManager, PermissionsMixin, Permission
from django.contrib.auth.models import AbstractUser
from django_resized import ResizedImageField
from django.contrib.auth.validators import UnicodeUsernameValidator
from datetime import timedelta
from django.contrib.auth.models import Group
from django.utils.translation import gettext_lazy as _

from django.utils import timezone

class UserManager(BaseUserManager):
    def create_user(self, username, email, password=None):
        if not email:
            raise ValueError('El usuario debe tener un email válido.')
        user = self.model(
            username=username,
            email=self.normalize_email(email),
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, email, password=None):
        user = self.create_user(
            username=username,
            email=email,
            password=password,
        )
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user

class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(unique=True,  max_length=255)
    email = models.EmailField(unique=True)
    last_login = models.DateTimeField(null=True, blank=True, auto_now=True)
    #nickname=models.CharField(max_length=55, unique=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    groups = models.ManyToManyField(
        Group,
        verbose_name=_('groups'),
        blank=True,
        related_name='api_users'
    )

    user_permissions = models.ManyToManyField(
        Permission,
        verbose_name=_('user permissions'),
        blank=True,
        related_name='api_users'
    )
    objects = UserManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']
    

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    def __str__(self) -> str:
        return str(self.id)

class TokensEmail(models.Model):
    token = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    is_valid = models.BooleanField(default=True)

    def is_expired(self):
        return self.expires_at <= timezone.now()

    def save(self, *args, **kwargs):
        if not self.expires_at:
            self.expires_at = timezone.now() + timedelta(minutes=10)
        super().save(*args, **kwargs)
        if self.is_valid and self.is_expired():
            self.is_valid = False
            self.save()

    @classmethod
    def create_token(cls):
        # Busca un token válido
        token_obj = cls.objects.filter(is_valid=True, expires_at__gte=timezone.now()).first()

        if token_obj:
            # Si se encuentra un token válido, actualiza el tiempo de expiración
            token_obj.expires_at = timezone.now() + timedelta(minutes=10)
            token_obj.save()
        else:
            # Si no hay tokens válidos, crea uno nuevo
            token = str(uuid4())
            token_obj = cls(token=token)
            token_obj.save()

        return token_obj

    @classmethod
    def clean_tokens(cls):
        tokens = cls.objects.filter(is_valid=True)
        for token in tokens:
            if token.is_expired():
                token.is_valid = False
                token.save()


#     @classmethod
#     def create_token(cls):
#         from uuid import uuid4
#         token = str(uuid4())
#         token_obj = cls(token=token)
#         token_obj.save()
#         return token_obj

#     @classmethod
#     def clean_tokens(cls):
#         tokens = cls.objects.filter(is_valid=True)
#         for token in tokens:
#             if token.is_expired():
#                 token.is_valid = False
#                 token.save()

# @periodic_task(run_every=crontab(minute='*/10'))
# def clean_tokens():
#     Token.clean_tokens()

#Create your models here.






# class CustomUserManager(BaseUserManager):
#     def create_user(self, email, password=None, **extra_fields):
#         if not email:
#             raise ValueError('The Email field must be set')
#         email = self.normalize_email(email)
#         user = self.model(email=email, **extra_fields)
#         user.set_password(password)
#         user.save(using=self._db)
#         return user

#     def create_superuser(self, email, password=None, **extra_fields):
#         extra_fields.setdefault('is_staff', True)
#         extra_fields.setdefault('is_superuser', True)
#         return self.create_user(email, password, **extra_fields)


    
    
    
    
    
    
    
    
    
    
    
# class User(AbstractBaseUser, PermissionsMixin):
#     # username_validator = UnicodeUsernameValidator()
#     username = models.CharField(
#         ('username'),
#         max_length=150,
#         unique=True,
#         help_text=('Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.'),
#         # validators=[username_validator],
#         error_messages={
#             'unique': ("A user with that username already exists."),
#         },
#     )
#     #first_name = models.CharField(('first name'), max_length=150, blank=True)
#     #last_name = models.CharField(('last name'), max_length=150, blank=True)

#     email = models.EmailField(('email address'), unique=True)
#     is_staff = models.BooleanField(
#         ('staff status'),
#         default=False,
#         help_text=('Designates whether the user can log into this admin site.'),
#     )
#     is_active = models.BooleanField(
#         ('active'),
#         default=True,
#         help_text=(
#             'Designates whether this user should be treated as active. '
#             'Unselect this instead of deleting accounts.'
#         ),
#     )
#     date_joined = models.DateTimeField(('date joined'), default=timezone.now)
#     email = models.EmailField(unique=True)
#     @classmethod
#     def create_user(cls, email):
#         if not email:
#             raise ValueError('The Email field must be set')
#         user = cls(email=email)
#         user.save()
#         return user
#     EMAIL_FIELD = 'email'
#     USERNAME_FIELD = 'email'
#     REQUIRED_FIELDS = ['username']
#     objects = CustomUserManager()
#     def __str__(self):
#         return self.email
   












    # def generate_otp(self):
    #     import pyotp
    #     totp = pyotp.TOTP('JBSWY3DPEHPK3PXP')
    #     return totp.now()
    
    # username_validator = UnicodeUsernameValidator()

    # username = models.CharField(
    #     ('username'),
    #     max_length=150,
    #     unique=True,
    #     help_text=('Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.'),
    #     validators=[username_validator],
    #     error_messages={
    #         'unique': ("A user with that username already exists."),
    #     },
    #)
    # first_name = models.CharField(('first name'), max_length=150, blank=True)
    # last_name = models.CharField(('last name'), max_length=150, blank=True)
    # email = models.EmailField(('email address'), unique=True)
    # is_staff = models.BooleanField(
    #     ('staff status'),
    #     default=False,
    #     help_text=('Designates whether the user can log into this admin site.'),
    # )
    # is_active = models.BooleanField(
    #     ('active'),
    #     default=True,
    #     help_text=(
    #         'Designates whether this user should be treated as active. '
    #         'Unselect this instead of deleting accounts.'
    #     ),
    # )
    # date_joined = models.DateTimeField(('date joined'), default=timezone.now)

    # objects = UserManager()

    # EMAIL_FIELD = 'email'
    # USERNAME_FIELD = 'email'
    # REQUIRED_FIELDS = ['username']
    # nickname = models.CharField(max_length=55)
    # # profile_picture=ResizedImageField(upload_to,null=True,blank=True)
    
    # def __str__(self):
    #      return self.email

    # def generate_otp(self):
    #     import pyotp
    #     totp = pyotp.TOTP('JBSWY3DPEHPK3PXP')
    #     return totp.now()
    
 
    
# class Project(models.Model):
#     id = models.AutoField(primary_key= True)
#     nombre = models.CharField('Nombre', max_length= 100)
#     descripcion = models.CharField('Descripcion', max_length= 500)

    

#     def __str__(self):
#         return f'{self.nombre} : {self.descripcion}'

# class Device(models.Model):
#     nombre = models.CharField('Nombre', max_length= 100, primary_key= True)

    
#     def __str__(self):
#         return f'{self.nombre}'

# class Template(models.Model):

#     namehardware = models.CharField('Namehardware', max_length=100, primary_key=500)
#     descripcionTemplate = models.CharField('Descripcion', max_length=500)
    
#     def __str__(self):
#         return f'{self.namehardware } : {self.descripcionTemplate}' 
from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token
from ApiPianta import views
from dj_rest_auth.registration.views import RegisterView
from .views import RegisterView, CustomPasswordResetConfirmView, CustomLoginView, MyUserDetailsView #, CustomPasswordResetView
#from django.contrib.auth import views as auth_views
#from django.views.generic import TemplateView
from dj_rest_auth.views import (
    PasswordResetView, 
    #PasswordResetConfirmView, 
    #PasswordChangeView,
)
urlpatterns = [
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/user/edit/', MyUserDetailsView.as_view(), name='user_edit'),
    #path('user/auth/editUser/<int:pk>/', views.user_edit_view, name='user_edit'),
    path('auth/loggeo/', CustomLoginView.as_view(), name='loggeo'),
    path('auth/send-registration-email/', views.send_registration_email, name='send_registration_email'),
    path('auth/password/resete/', PasswordResetView.as_view(), name='rest_password_reset'),
    #path('auth/password/reset/custom/', CustomPasswordResetView.as_view(), name='rest_password_reset_custom'),
    path('auth/password/reset/confirm/<uidb64>/<token>/', CustomPasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    #path('auth/password/reset/complete/', CustomPasswordResetCompleteView.as_view(), name='password_reset_complete'),
   # path('auth/reset_password/', ForgotPasswordView.as_view(), name='reset_password'),
    #path('auth/reset_password_confirm/<uidb64>/<token>/', ResetPasswordView.as_view(), name='password_reset_confirm'),
    # path('auth/reset_password_confirm/<uidb64>/<token>/', PasswordResetConfirmView.as_view(), name='reset_password_confirm'),
    # path('auth/reset/done/', auth_views.PasswordResetCompleteView.as_view(), name='password_reset_complete'),
    # path('auth/reset_password/', auth_views.PasswordResetView.as_view(), name='reset_password'),
    # path('auth/reset_password/done/', auth_views.PasswordResetDoneView.as_view(), name='password_reset_done'),
    # path('auth/reset_password_complete/', auth_views.PasswordResetCompleteView.as_view(), name='password_reset_complete'),
    #path('auth/send_password_reset_email/', views.send_password_reset_email, name='send_password_reset_email'),
    # path('auth/password_reset/',auth_views.PasswordResetView.as_view(),name='password_reset'),
    # path('auth/password_reset/done/',auth_views.PasswordResetDoneView.as_view(),name='password_reset_done'),
    # path('auth/reset/<uidb64>/<token>/',auth_views.PasswordResetConfirmView.as_view(),name='password_reset_confirm'),
    # path('auth/reset/done/',auth_views.PasswordResetCompleteView.as_view(),name='password_reset_complete'),
    #path('auth/registration/', RegisterView.as_view(), name='rest_register'),
    #path('auth/validate_registration_token/', views.validate_registration_token, name ='registration_token'),
    path('auth/validate_token/', views.validate_token, name ='validate_token'),
    #path('auth/token/', obtain_auth_token, name='auth_token'),
    path('auth/RegisterView/', RegisterView.as_view(), name='registration')
    #path('auth/delete_expired_tokens/', views.delete_expired_tokens, name='expired_token'),
    #path('auth/registration/',include('dj_rest_auth.registration.urls')),
    # path('auth/register/', register, name='register_api'),
    # path('auth/verify_otp/', verify_otp, name='verify_otp'),
    # path('project/', ProjectList.as_view(), name = 'project_list'),
    # path('device/', DeviceList.as_view(), name = 'device_list'),
    # path('template/', TemplateList.as_view(), name = 'template_list'),
]
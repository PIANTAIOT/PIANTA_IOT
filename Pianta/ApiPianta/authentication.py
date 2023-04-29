# from django.contrib.auth.backends import ModelBackend
# from django.utils import timezone

# class CustomBackend(ModelBackend):
#     def authenticate(self, request, username=None, password=None, **kwargs):
#         user = super().authenticate(request, username=username, password=password, **kwargs)
#         if user is not None:
#             user.last_login = timezone.now()
#             user.save()
#         return user
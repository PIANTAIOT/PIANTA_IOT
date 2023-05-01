from django import forms
# from .models import User

# class UserUpdateForm(forms.ModelForm):
#     class Meta:
#         model = User
#         fields = ['username', 'email']

class CustomPasswordResetForm(forms.Form):
    uid = forms.CharField(widget=forms.HiddenInput(), error_messages={'required': 'Uid is required.'})
    # token = forms.CharField(widget=forms.HiddenInput())
    # new_password1 = forms.CharField(label='New password', widget=forms.PasswordInput)
    # new_password2 = forms.CharField(label='New password confirmation', widget=forms.PasswordInput)

    def __init__(self, *args, uid=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['uid'].initial = uid

    # def clean(self):
    #     cleaned_data = super().clean()
    #     password1 = cleaned_data.get("new_password1")
    #     password2 = cleaned_data.get("new_password2")
    #     if password1 and password2 and password1 != password2:
    #         raise forms.ValidationError("Passwords don't match")
    #     return cleaned_data
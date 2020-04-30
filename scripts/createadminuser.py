from django.contrib.auth.models import User
try:
    User.objects.create_superuser('admin', 'nhorman@gmail.com', 'admin')
except:
    pass

from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

def health_check(request):
    return JsonResponse({'status': 'healthy'})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('todo_app.auth_urls')),
    path('api/', include('todo_app.urls')),
    path('health/', health_check),
]

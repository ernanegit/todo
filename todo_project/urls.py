from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

def health_check(request):
    return JsonResponse({'status': 'healthy'})

def home_page(request):
    return JsonResponse({
        'message': 'Django Todo API',
        'version': '1.0.0',
        'endpoints': {
            'admin': '/admin/',
            'health': '/health/',
            'api': '/api/',
        },
        'status': 'running'
    })

urlpatterns = [
    path('', home_page, name='home'),
    path('admin/', admin.site.urls),
    path('health/', health_check, name='health'),
    path('api/', include('todo_app.urls')),
]

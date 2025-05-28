from django.urls import path

def api_info(request):
    from django.http import JsonResponse
    return JsonResponse({
        'message': 'Todo API endpoints',
        'available_endpoints': [
            'GET /api/ - Esta página',
            'POST /api/auth/register/ - Registrar usuário', 
            'POST /api/auth/login/ - Login',
            'GET /api/todos/ - Listar todos',
            'POST /api/todos/ - Criar todo',
        ],
        'status': 'API funcionando'
    })

urlpatterns = [
    path('', api_info, name='api_info'),
]
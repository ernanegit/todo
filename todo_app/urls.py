from django.urls import path, include
from rest_framework.routers import DefaultRouter
from django.http import JsonResponse
from .views import TodoViewSet
from . import auth_views

# Router para os ViewSets
router = DefaultRouter()
router.register(r'todos', TodoViewSet, basename='todo')

def api_info(request):
    """View para mostrar informações da API"""
    return JsonResponse({
        'message': 'Django Todo API REST',
        'version': '1.0.0',
        'endpoints': {
            'auth': {
                'register': '/api/auth/register/ (POST)',
                'login': '/api/auth/login/ (POST)',
                'logout': '/api/auth/logout/ (POST)',
                'profile': '/api/auth/profile/ (GET)',
            },
            'todos': {
                'list': '/api/todos/ (GET)',
                'create': '/api/todos/ (POST)',
                'detail': '/api/todos/{id}/ (GET)',
                'update': '/api/todos/{id}/ (PUT/PATCH)',
                'delete': '/api/todos/{id}/ (DELETE)',
                'marcar_concluida': '/api/todos/{id}/marcar_concluida/ (POST)',
                'estatisticas': '/api/todos/estatisticas/ (GET)',
            },
            'filters': {
                'status': '?status=pendente|em_progresso|concluida',
                'prioridade': '?prioridade=baixa|media|alta',
                'search': '?search=termo_busca',
            }
        },
        'authentication': 'Token required: Authorization: Token {your_token}',
        'status': 'API REST funcionando'
    })

urlpatterns = [
    # Autenticação
    path('auth/register/', auth_views.register, name='auth_register'),
    path('auth/login/', auth_views.login, name='auth_login'),
    path('auth/logout/', auth_views.logout, name='auth_logout'),
    path('auth/profile/', auth_views.profile, name='auth_profile'),
    
    # Todos API REST
    path('', include(router.urls)),
    
    # Informações da API
    path('info/', api_info, name='api_info'),
]
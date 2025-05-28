from django.urls import path

def placeholder_view(request):
    from django.http import JsonResponse
    return JsonResponse({'message': 'API funcionando'})

urlpatterns = [
    path('', placeholder_view),
]

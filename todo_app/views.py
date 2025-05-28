from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from .models import Todo
from .serializers import TodoSerializer

class TodoViewSet(viewsets.ModelViewSet):
    serializer_class = TodoSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        queryset = Todo.objects.filter(usuario=self.request.user)
        
        status_filter = self.request.query_params.get('status')
        prioridade_filter = self.request.query_params.get('prioridade')
        search = self.request.query_params.get('search')
        
        if status_filter:
            queryset = queryset.filter(status=status_filter)
        
        if prioridade_filter:
            queryset = queryset.filter(prioridade=prioridade_filter)
        
        if search:
            queryset = queryset.filter(
                Q(titulo__icontains=search) | Q(descricao__icontains=search)
            )
        
        return queryset
    
    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)
    
    @action(detail=True, methods=['post'])
    def marcar_concluida(self, request, pk=None):
        todo = self.get_object()
        todo.status = 'concluida'
        todo.save()
        serializer = self.get_serializer(todo)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def estatisticas(self, request):
        queryset = self.get_queryset()
        return Response({
            'total': queryset.count(),
            'pendentes': queryset.filter(status='pendente').count(),
            'em_progresso': queryset.filter(status='em_progresso').count(),
            'concluidas': queryset.filter(status='concluida').count(),
        })

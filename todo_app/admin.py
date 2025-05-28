from django.contrib import admin
from .models import Todo

@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ['titulo', 'status', 'prioridade', 'usuario', 'data_criacao']
    list_filter = ['status', 'prioridade']
    search_fields = ['titulo', 'descricao']
    list_per_page = 25

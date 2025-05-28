# apply-css-fixes.ps1
# Script para aplicar correções do CSS Django Admin

Write-Host "🔧 Aplicando correções CSS Django Admin..." -ForegroundColor Cyan

# 1. Atualizar requirements.txt
Write-Host "📦 Atualizando requirements.txt..." -ForegroundColor Yellow
$requirements = @"
Django==4.2.7
djangorestframework==3.14.0
psycopg2-binary==2.9.9
django-cors-headers==4.3.1
gunicorn==21.2.0
whitenoise==6.6.0
"@
$requirements | Out-File -FilePath "requirements.txt" -Encoding UTF8
Write-Host "✅ requirements.txt atualizado com WhiteNoise" -ForegroundColor Green

# 2. Atualizar settings.py
Write-Host "⚙️  Atualizando settings.py..." -ForegroundColor Yellow
$settings = @'
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-dev-key')
DEBUG = os.environ.get('DEBUG', 'True').lower() == 'true'
ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework.authtoken',
    'corsheaders',
    'todo_app',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'todo_project.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'todo_project.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'todoapp'),
        'USER': os.environ.get('DB_USER', 'postgres'),
        'PASSWORD': os.environ.get('DB_PASSWORD', 'postgres'),
        'HOST': os.environ.get('DB_HOST', 'db'),
        'PORT': '5432',
    }
}

LANGUAGE_CODE = 'pt-br'
TIME_ZONE = 'America/Sao_Paulo'
USE_I18N = True
USE_TZ = True

# Static files configuration
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# WhiteNoise configuration for serving static files
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
WHITENOISE_USE_FINDERS = True
WHITENOISE_AUTOREFRESH = True

# Media files
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.TokenAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}

CORS_ALLOW_ALL_ORIGINS = True
'@
$settings | Out-File -FilePath "todo_project\settings.py" -Encoding UTF8
Write-Host "✅ settings.py atualizado com WhiteNoise middleware" -ForegroundColor Green

# 3. Atualizar docker-compose.yml para melhor gerenciamento de estáticos
Write-Host "🐳 Atualizando docker-compose.yml..." -ForegroundColor Yellow
$compose = @'
services:
  db:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    environment:
      POSTGRES_DB: todoapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  web:
    build: .
    command: >
      sh -c "
        echo 'Aguardando PostgreSQL...' &&
        while ! nc -z db 5432; do sleep 1; done &&
        echo 'Executando migracoes...' &&
        python manage.py migrate &&
        echo 'Coletando arquivos estaticos...' &&
        python manage.py collectstatic --noinput &&
        echo 'Criando superusuario...' &&
        python manage.py shell -c \"from django.contrib.auth.models import User; User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin123')\" &&
        echo 'Iniciando servidor...' &&
        gunicorn todo_project.wsgi:application --bind 0.0.0.0:8000 --timeout 120
      "
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    environment:
      - DEBUG=False
      - SECRET_KEY=django-production-key-change-me
      - DB_NAME=todoapp
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_HOST=db
    depends_on:
      db:
        condition: service_healthy

volumes:
  postgres_data:
'@
$compose | Out-File -FilePath "docker-compose.yml" -Encoding UTF8
Write-Host "✅ docker-compose.yml atualizado" -ForegroundColor Green

# 4. Corrigir start.bat para evitar BOM
Write-Host "📝 Corrigindo start.bat..." -ForegroundColor Yellow
$startBat = @'
@echo off
echo Iniciando Django Todo API...
docker-compose up --build -d
echo.
echo Aguarde 30 segundos e acesse:
echo API: http://localhost:8000/api/
echo Admin: http://localhost:8000/admin/ (admin/admin123)
echo.
echo Para ver logs: docker-compose logs -f web
echo Para parar: docker-compose down
echo.
pause
'@
$startBat | Out-File -FilePath "start.bat" -Encoding ASCII
Write-Host "✅ start.bat corrigido (sem BOM)" -ForegroundColor Green

# 5. Atualizar README.md
Write-Host "📚 Atualizando README.md..." -ForegroundColor Yellow
$readme = @'
# 🚀 Django Todo API - Aplicação Containerizada

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://python.org)
[![Django](https://img.shields.io/badge/Django-4.2-green.svg)](https://djangoproject.com)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue.svg)](https://docker.com)
[![API](https://img.shields.io/badge/API-REST-orange.svg)](http://localhost:8000/api/)

## 📋 Sobre o Projeto

Esta é uma aplicação Django REST API completa para gerenciamento de tarefas (Todo), containerizada com Docker e pronta para produção.

## ✨ Funcionalidades Principais

- 🔐 **Sistema de autenticação** completo (registro, login, perfil)
- 📝 **CRUD de tarefas** com filtros avançados
- 🔍 **Busca e paginação** automática
- 📊 **Estatísticas** em tempo real
- 🎨 **Django Admin** com CSS funcional
- 🐳 **Totalmente containerizada** com Docker
- 🔒 **Segurança** enterprise (rate limiting, headers de segurança)
- ⚡ **Performance** otimizada com WhiteNoise
- 🧪 **Testes** incluídos

## 🚀 Como Executar

### Pré-requisitos
- **Docker Desktop** instalado e funcionando
- **Git** (para clonar o repositório)

### Execução Rápida
```bash
# 1. Clonar repositório
git clone https://github.com/ernanegit/todo.git
cd todo

# 2. Executar aplicação
start.bat          # Windows
# OU
./start.sh         # Linux/Mac
# OU
docker-compose up --build -d

# 3. Aguardar 30 segundos

# 4. Acessar aplicação
```

### 🌐 Acessos Disponíveis
- **API**: http://localhost:8000/api/
- **Admin Django**: http://localhost:8000/admin/ (admin/admin123)
- **Health Check**: http://localhost:8000/health/

## 📊 Endpoints da API

### 🔐 Autenticação
- `POST /api/auth/register/` - Registrar usuário
- `POST /api/auth/login/` - Login
- `POST /api/auth/logout/` - Logout
- `GET /api/auth/profile/` - Perfil do usuário

### 📝 Tarefas (requer autenticação)
- `GET /api/todos/` - Listar tarefas
- `POST /api/todos/` - Criar tarefa
- `GET /api/todos/{id}/` - Obter tarefa específica
- `PUT /api/todos/{id}/` - Atualizar tarefa
- `DELETE /api/todos/{id}/` - Deletar tarefa
- `POST /api/todos/{id}/marcar_concluida/` - Marcar como concluída

### 📊 Estatísticas
- `GET /api/todos/estatisticas/` - Estatísticas das tarefas

### 🔍 Filtros Disponíveis
- `?status=pendente|em_progresso|concluida`
- `?prioridade=baixa|media|alta`
- `?search=termo_busca`

## 🛠️ Tecnologias Utilizadas

- **Backend**: Django 4.2 + Django REST Framework
- **Banco de Dados**: PostgreSQL 15
- **Containerização**: Docker + Docker Compose
- **Servidor Web**: Gunicorn + WhiteNoise
- **Arquivos Estáticos**: WhiteNoise (CSS do Admin funcional)
- **Autenticação**: Token-based Authentication

## 📁 Estrutura do Projeto

```
todo/
├── 📄 manage.py              # Django management
├── 📄 requirements.txt       # Dependências Python
├── 📄 Dockerfile            # Imagem Docker
├── 📄 docker-compose.yml    # Orquestração
├── 📄 start.bat             # Script Windows
├── 📁 todo_project/         # Configurações Django
├── 📁 todo_app/             # Aplicação principal
└── 📁 tests/                # Testes automatizados
```

## 🔧 Comandos Úteis

```bash
# Ver logs da aplicação
docker-compose logs -f web

# Parar aplicação
docker-compose down

# Executar shell Django
docker-compose exec web python manage.py shell

# Executar testes
docker-compose exec web python manage.py test

# Criar migrações
docker-compose exec web python manage.py makemigrations
```

## 🧪 Exemplos de Uso da API

### Registrar usuário
```bash
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username": "usuario", "email": "user@example.com", "password": "minhasenha123"}'
```

### Criar tarefa
```bash
curl -X POST http://localhost:8000/api/todos/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token SEU_TOKEN" \
  -d '{"titulo": "Minha Tarefa", "descricao": "Descrição", "prioridade": "alta"}'
```

## 🚀 Deploy em Produção

Esta aplicação está pronta para deploy em:
- **Heroku**
- **DigitalOcean**
- **AWS**
- **Azure**
- **Google Cloud**

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

**⭐ Se este projeto foi útil para você, considere dar uma estrela!**
'@
$readme | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "✅ README.md atualizado com novas informações" -ForegroundColor Green

Write-Host ""
Write-Host "🎯 Todas as correções aplicadas!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Testar localmente: docker-compose up --build -d" -ForegroundColor White
Write-Host "2. Verificar CSS Admin: http://localhost:8000/admin/" -ForegroundColor White
Write-Host "3. Fazer commit: git add . && git commit && git push" -ForegroundColor White
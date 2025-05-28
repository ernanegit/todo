Write-Host "=== CORRIGINDO TODOS OS PROBLEMAS ===" -ForegroundColor Cyan

# 1. Ir para o diretório correto
Write-Host "1. Navegando para o diretório correto..." -ForegroundColor Yellow
Set-Location "C:\Users\ernane\todo\django-todo-api"

# 2. Parar todos os containers
Write-Host "2. Parando todos os containers..." -ForegroundColor Yellow
docker-compose down -v
docker stop $(docker ps -q) 2>$null

# 3. Criar docker-compose.yml correto
Write-Host "3. Criando docker-compose.yml correto..." -ForegroundColor Yellow
@"
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
      - "5433:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    environment:
      - DEBUG=True
      - SECRET_KEY=django-dev-key-simples
      - DB_NAME=todoapp
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_HOST=db
      - DB_PORT=5432
    depends_on:
      db:
        condition: service_healthy

volumes:
  postgres_data:
"@ | Out-File -FilePath "docker-compose.yml" -Encoding UTF8

# 4. Criar settings.py simplificado
Write-Host "4. Criando settings.py simplificado..." -ForegroundColor Yellow
@"
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get('SECRET_KEY', 'django-dev-key-simples')
DEBUG = True
ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
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

STATIC_URL = '/static/'
MEDIA_URL = '/media/'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
"@ | Out-File -FilePath "todo_project/settings.py" -Encoding UTF8

# 5. Rebuild e iniciar
Write-Host "5. Rebuilding e iniciando..." -ForegroundColor Yellow
docker-compose build --no-cache
docker-compose up -d

# 6. Aguardar e testar
Write-Host "6. Aguardando containers iniciarem..." -ForegroundColor Yellow
Start-Sleep 30

Write-Host "7. Testando..." -ForegroundColor Yellow
docker-compose ps
Write-Host ""
Write-Host "Testando health check:" -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health/" -UseBasicParsing
    Write-Host "SUCCESS! Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "Health check falhou, vendo logs..." -ForegroundColor Red
    docker-compose logs web
}
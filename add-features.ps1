Write-Host "=== ADICIONANDO FUNCIONALIDADES DE VOLTA ===" -ForegroundColor Cyan

# 1. Executar migrações
Write-Host "1. Executando migrações..." -ForegroundColor Yellow
docker-compose exec web python manage.py migrate

# 2. Criar superusuário
Write-Host "2. Criando superusuário..." -ForegroundColor Yellow
docker-compose exec web python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Admin criado: admin/admin123')
else:
    print('Admin já existe')
"

# 3. Coletar arquivos estáticos (para CSS do admin)
Write-Host "3. Coletando arquivos estáticos..." -ForegroundColor Yellow
docker-compose exec web python manage.py collectstatic --noinput

# 4. Testar endpoints
Write-Host "4. Testando endpoints..." -ForegroundColor Yellow
Write-Host "Health check:" -ForegroundColor Green
Invoke-WebRequest -Uri "http://localhost:8000/health/" -UseBasicParsing | Select-Object StatusCode, Content

Write-Host ""
Write-Host "Admin (teste no navegador):" -ForegroundColor Green  
Write-Host "URL: http://localhost:8000/admin/" -ForegroundColor Cyan
Write-Host "User: admin" -ForegroundColor Cyan
Write-Host "Pass: admin123" -ForegroundColor Cyan

Write-Host ""
Write-Host "=== PRÓXIMOS PASSOS ===" -ForegroundColor Yellow
Write-Host "1. Acesse http://localhost:8000/admin/ para testar o admin"
Write-Host "2. Verifique se o CSS está funcionando"
Write-Host "3. Me avise se está tudo OK para adicionarmos a API REST de volta"
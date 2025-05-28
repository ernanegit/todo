# dev-setup.ps1 - Setup rapido para desenvolvimento
Write-Host "Django Todo API - Setup de Desenvolvimento" -ForegroundColor Cyan

# Verificar Docker
try {
    docker --version | Out-Null
    Write-Host "Docker encontrado!" -ForegroundColor Green
}
catch {
    Write-Host "Erro: Docker nao encontrado!" -ForegroundColor Red
    exit 1
}

# Copiar .env se nao existir
if (-not (Test-Path ".env")) {
    try {
        Copy-Item ".env.example" ".env"
        Write-Host "Arquivo .env criado" -ForegroundColor Green
    }
    catch {
        Write-Host "Erro ao criar .env" -ForegroundColor Yellow
    }
}

# Iniciar containers
Write-Host "Iniciando containers..." -ForegroundColor Yellow
docker-compose up --build -d

# Aguardar containers iniciarem
Write-Host "Aguardando containers iniciarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verificar saude da aplicacao
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health/" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "Aplicacao iniciada com sucesso!" -ForegroundColor Green
    }
}
catch {
    Write-Host "Aplicacao pode estar ainda inicializando..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Acessos disponiveis:" -ForegroundColor Cyan
Write-Host "  API: http://localhost:8000/api/"
Write-Host "  Admin: http://localhost:8000/admin/ (admin/admin123)"
Write-Host "  Flower: http://localhost:5555"
Write-Host ""
Write-Host "Comandos uteis:" -ForegroundColor Cyan
Write-Host "  Ver logs: docker-compose logs -f"
Write-Host "  Parar: docker-compose down"
Write-Host "  Shell: docker-compose exec web bash"

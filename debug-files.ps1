Write-Host "=== DEBUGANDO ARQUIVOS DE URL ===" -ForegroundColor Cyan

Write-Host ""
Write-Host "Conteudo de todo_project/urls.py:" -ForegroundColor Yellow
Get-Content "todo_project/urls.py"

Write-Host ""
Write-Host "Conteudo de todo_app/urls.py:" -ForegroundColor Yellow  
Get-Content "todo_app/urls.py"

Write-Host ""
Write-Host "Verificando se auth_urls.py existe:" -ForegroundColor Yellow
if (Test-Path "todo_app/auth_urls.py") {
    Write-Host "ARQUIVO EXISTE! Conteudo:" -ForegroundColor Red
    Get-Content "todo_app/auth_urls.py"
} else {
    Write-Host "Arquivo NAO existe (correto)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Status dos containers:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "Logs completos do web:" -ForegroundColor Yellow
docker-compose logs web
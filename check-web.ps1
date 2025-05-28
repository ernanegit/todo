Write-Host "=== DIAGNOSTICO DO CONTAINER WEB ===" -ForegroundColor Cyan

Write-Host ""
Write-Host "1. Status de todos os containers:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "2. Tentando ver todos os containers (incluindo parados):" -ForegroundColor Yellow
docker ps -a

Write-Host ""
Write-Host "3. Logs do container web:" -ForegroundColor Yellow
docker-compose logs web

Write-Host ""
Write-Host "4. Tentando iniciar apenas o web container:" -ForegroundColor Yellow
docker-compose up web

Write-Host ""
Write-Host "5. Se falhar, vamos ver se o arquivo docker-compose.yml esta correto:" -ForegroundColor Yellow
Get-Content "docker-compose.yml"
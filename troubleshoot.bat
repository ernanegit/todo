@echo off
echo Resolvendo conflitos de porta e containers...

echo.
echo 1. Verificando processos na porta 8000...
netstat -ano | findstr :8000

echo.
echo 2. Parando TODOS os containers Docker...
docker stop $(docker ps -q) 2>nul
docker-compose down -v

echo.
echo 3. Limpando containers e volumes orfaos...
docker container prune -f
docker volume prune -f
docker network prune -f

echo.
echo 4. Verificando se a porta esta livre...
netstat -ano | findstr :8000

echo.
echo 5. Rebuilding do zero...
docker-compose build --no-cache

echo.
echo 6. Iniciando containers...
docker-compose up -d

echo.
echo 7. Aguardando 30 segundos...
timeout /t 30

echo.
echo 8. Verificando status dos containers...
docker-compose ps

echo.
echo 9. Coletando arquivos estaticos...
docker-compose exec web python manage.py collectstatic --noinput --clear

echo.
echo Processo concluido!
echo Acesse: http://localhost:8000/admin/
pause
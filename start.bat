@echo off
echo Iniciando Django Todo API...
docker-compose up --build -d
echo.
echo Aguarde 30 segundos e acesse:
echo API: http://localhost:8000/api/
echo Admin: http://localhost:8000/admin/ (admin/admin123)
pause

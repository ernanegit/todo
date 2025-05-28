#!/bin/bash
set -e

echo "Aguardando PostgreSQL..."
while ! nc -z db 5432; do
  sleep 1
done

echo "Executando migracoes..."
python manage.py migrate

echo "Coletando arquivos estaticos..."
python manage.py collectstatic --noinput

echo "Criando superusuario..."
python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Admin criado: admin/admin123')
"

exec "$@"

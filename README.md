# Instalar dependências
pip install -r requirements.txt

# Configurar banco PostgreSQL
# Editar settings.py ou usar SQLite

# Executar migrações
python manage.py migrate

# Criar superusuário
python manage.py createsuperuser

# Iniciar servidor
python manage.py runserver
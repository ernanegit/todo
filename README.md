Django Todo API
Uma API REST completa para gerenciamento de tarefas (todos) construída com Django REST Framework.
🚀 Setup Rápido
bash# 1. Clonar o repositório
git clone https://github.com/ernanegit/todo.git
cd todo

# 2. Iniciar com Docker
docker-compose up -d

# 3. Aguardar containers iniciarem (30-60 segundos)
docker-compose ps

# 4. Testar API
curl http://localhost:8000/api/info/
📋 Pré-requisitos

Docker
Docker Compose
Git

🛠️ Instalação Detalhada
Passo 1: Clonar repositório
bashgit clone https://github.com/ernanegit/todo.git
cd todo
Passo 2: Configurar ambiente (opcional)
bash# Copiar arquivo de exemplo
cp .env.example .env

# Editar configurações se necessário
# nano .env
Passo 3: Iniciar aplicação
bash# Construir e iniciar containers
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs (opcional)
docker-compose logs -f web
Passo 4: Verificar funcionamento
bash# Testar API
curl http://localhost:8000/health/
curl http://localhost:8000/api/info/

# Ou abrir no navegador:
# http://localhost:8000/
🌐 URLs Disponíveis
URLDescriçãohttp://localhost:8000/Página inicialhttp://localhost:8000/admin/Painel administrativohttp://localhost:8000/api/API Roothttp://localhost:8000/api/info/Documentação da APIhttp://localhost:8000/health/Health check
🔐 Credenciais Padrão
Admin Django:

URL: http://localhost:8000/admin/
Usuário: admin
Senha: admin123

📚 API Endpoints
Autenticação
bash# Registrar usuário
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"novouser","email":"user@email.com","password":"senha123"}'

# Login
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"novouser","password":"senha123"}'

# Resposta contém o token:
# {"user": {...}, "token": "abc123..."}
Tarefas (Todos)
bash# Usar token nas requisições
TOKEN="seu_token_aqui"

# Listar tarefas
curl -H "Authorization: Token $TOKEN" http://localhost:8000/api/todos/

# Criar tarefa
curl -X POST http://localhost:8000/api/todos/ \
  -H "Authorization: Token $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Minha tarefa","descricao":"Descrição","prioridade":"alta"}'

# Atualizar tarefa
curl -X PUT http://localhost:8000/api/todos/1/ \
  -H "Authorization: Token $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Tarefa atualizada","status":"concluida"}'

# Deletar tarefa
curl -X DELETE http://localhost:8000/api/todos/1/ \
  -H "Authorization: Token $TOKEN"
Filtros e Busca
bash# Filtrar por status
curl -H "Authorization: Token $TOKEN" \
  "http://localhost:8000/api/todos/?status=pendente"

# Filtrar por prioridade
curl -H "Authorization: Token $TOKEN" \
  "http://localhost:8000/api/todos/?prioridade=alta"

# Buscar por texto
curl -H "Authorization: Token $TOKEN" \
  "http://localhost:8000/api/todos/?search=importante"

# Combinar filtros
curl -H "Authorization: Token $TOKEN" \
  "http://localhost:8000/api/todos/?status=pendente&prioridade=alta"
Estatísticas
bash# Ver estatísticas das tarefas
curl -H "Authorization: Token $TOKEN" \
  http://localhost:8000/api/todos/estatisticas/
🗃️ Modelo de Dados
Todo (Tarefa)
json{
  "id": 1,
  "titulo": "Título da tarefa",
  "descricao": "Descrição detalhada",
  "prioridade": "baixa|media|alta",
  "status": "pendente|em_progresso|concluida",
  "data_criacao": "2025-05-28T10:00:00Z",
  "data_atualizacao": "2025-05-28T10:00:00Z",
  "data_vencimento": "2025-05-30T10:00:00Z",
  "usuario": {
    "id": 1,
    "username": "usuario",
    "email": "user@email.com"
  }
}
🛠️ Desenvolvimento
Comandos úteis
bash# Ver logs em tempo real
docker-compose logs -f web

# Executar comandos Django
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py shell

# Reiniciar aplicação
docker-compose restart web

# Parar aplicação
docker-compose down

# Limpar tudo (cuidado!)
docker-compose down -v
Executar sem Docker
bash# Instalar dependências
pip install -r requirements.txt

# Configurar banco PostgreSQL
# Editar settings.py ou usar SQLite

# Executar migrações
python manage.py migrate

# Criar superusuário
python manage.py createsuperuser

# Iniciar servidor
python manage.py runserver
🧪 Testes
bash# Testar API manualmente
curl http://localhost:8000/api/info/

# Registrar usuário de teste
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"teste","email":"teste@email.com","password":"senha123"}'

# Testar todos os endpoints
# (usar token retornado no registro)
🔧 Tecnologias

Backend: Django 4.2.7
API: Django REST Framework 3.14.0
Banco: PostgreSQL 15
Cache: Redis (opcional)
Autenticação: Token-based
Containerização: Docker + Docker Compose
CORS: Configurado para frontends

📝 Estrutura do Projeto
todo/
├── todo_app/              # App principal
│   ├── models.py          # Modelos (Todo)
│   ├── serializers.py     # Serializers DRF
│   ├── views.py           # Views/ViewSets
│   ├── urls.py            # URLs da API
│   └── auth_views.py      # Autenticação
├── todo_project/          # Configurações Django
│   ├── settings.py        # Settings
│   └── urls.py            # URLs principais
├── docker-compose.yml     # Orquestração Docker
├── Dockerfile             # Imagem Docker
├── requirements.txt       # Dependências Python
└── README.md              # Esta documentação
🚨 Troubleshooting
Problemas comuns
1. Container não inicia:
bashdocker-compose logs web
docker-compose down && docker-compose up -d
2. Erro de conexão com banco:
bash# Aguardar mais tempo para PostgreSQL inicializar
docker-compose ps
3. Porta 8000 ocupada:
bash# Alterar porta no docker-compose.yml
ports:
  - "8001:8000"  # Usar porta 8001
4. Erro de migração:
bashdocker-compose exec web python manage.py migrate
🤝 Contribuindo

Fork o projeto
Crie uma branch (git checkout -b feature/nova-funcionalidade)
Commit suas mudanças (git commit -m 'Adicionar nova funcionalidade')
Push para a branch (git push origin feature/nova-funcionalidade)
Abra um Pull Request

📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
🎯 Status

✅ API REST completa
✅ Autenticação por token
✅ CRUD de tarefas
✅ Filtros e busca
✅ Dockerizado
✅ Documentação completa
⏳ Testes automatizados (em desenvolvimento)
⏳ Frontend (planejado)

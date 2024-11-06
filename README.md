
# Руководство по развертыванию web-приложения
### Пример настройки с использованием Docker, Docker Compose и Nginx

В данном руководстве представлены два подхода к развертыванию web-приложения:
- Проксирование запросов на backend через Nginx.
- Прямой доступ к backend.

## Проксирование запросов через Nginx
### Примеры
#### Пример 1 ([Example1](/examples/proxying/example1/))
- **Frontend:** React
- **Backend:** Node.js

#### Пример 2 ([Example2](/examples/proxying/example2/))
- **Frontend:** Flutter (Dart)
- **Backend:** Spring (Kotlin, JVM)

### Описание
Nginx используется как промежуточный слой, перенаправляющий запросы от клиента на backend. Запросы сначала проходят через Nginx, который обрабатывает их и направляет в соответствующий контейнер с backend.

### Структура приложения
- **Nginx** — сервер, управляющий проксированием.
- **Frontend** — клиентская часть.
- **Backend** — серверная часть.
- **PostgreSQL** — база данных.

### Пошаговая настройка

1. **Создаем Dockerfile для backend и frontend**
   - **Backend**: [Пример 1](/examples/proxying/example1/server/Dockerfile), [Пример 2](/examples/proxying/example2/SchoolBack/Dockerfile).
   - **Frontend**: [Пример 1](/examples/proxying/example1/client/Dockerfile), [Пример 2](/examples/proxying/example2/SchoolFront/Dockerfile).
     > В случае с Flutter frontend также использует дополнительную конфигурацию Nginx, так как Dart не имеет встроенного веб-сервера.

2. **Создаем папку `/nginx` в корне проекта и файл конфигурации `nginx.conf`**
   В начале конфигурационного файла указываем порт и доменное имя:
   ```conf
   listen 80;
   server_name localhost;
   ```

   Настраиваем перенаправление запросов на frontend:
   ```conf
   # Прокси для frontend
   location / {
       resolver 127.0.0.11;  # Используем DNS Docker Compose для доступа по именам контейнеров
       proxy_pass http://frontend:3000;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
   }
   ```

   Настраиваем перенаправление запросов на backend:
   ```conf
   # Прокси для backend
   location /api {
       resolver 127.0.0.11; 
       proxy_pass http://backend:3001;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
   }
   ```

3. **Создаем файл `.env`**  
   В этом файле настраиваем переменные окружения для подключения к базе данных и backend:
   ```env
   # Настройки базы данных
   POSTGRES_DB=database_name         
   POSTGRES_USER=admin               
   POSTGRES_PASSWORD=password_12345

   # Настройки backend
   BACKEND_API_URL="/api"
   ```

   Эти же переменные указываем в проекте:
   + БД: [Пример 1](/examples/proxying/example1/server/db.js#L5-L9) [Пример 2](examples/proxying/example2/SchoolBack/src/main/resources/application.properties#L3-L8)
   + Api ссылка: [Пример 1](examples/proxying/example1/client/src/services/api.service.js#L3) [Пример 2](examples/proxying/example2/SchoolFront/lib/dataclasses/config.dart#L2)

4. **Создаем файл `docker-compose.yaml`**  
   В `docker-compose.yaml` указываем путь к Dockerfile для каждого сервиса (frontend и backend).

---

## Прямой доступ к backend
### Примеры
#### Пример 1 ([Example1](/examples/direct_access/example1/))
- **Frontend:** React
- **Backend:** Node.js

#### Пример 2 ([Example2](/examples/direct_access/example2/))
- **Frontend:** Flutter (Dart)
- **Backend:** Spring (Kotlin, JVM)

### Описание
При прямом доступе клиент напрямую обращается к backend-серверу, минуя Nginx.

### Структура приложения
- **Frontend** — клиентская часть.
- **Backend** — серверная часть.
- **PostgreSQL** — база данных.

### Пошаговая настройка

1. **Создаем Dockerfile для backend и frontend**
   - **Backend**: [Пример 1](/examples/direct_access/example1/server/Dockerfile), [Пример 2](/examples/direct_access/example2/SchoolBack/Dockerfile).
   - **Frontend**: [Пример 1](/examples/direct_access/example1/client/Dockerfile), [Пример 2](/examples/direct_access/example2/SchoolFront/Dockerfile).
     > Во втором примере frontend также использует дополнительную конфигурацию Nginx, поскольку Dart не имеет встроенного веб-сервера.

2. **Создаем файл `.env`**  
   В `.env` прописываем настройки для подключения к базе данных и backend:
   ```env
   # Настройки базы данных
   POSTGRES_DB=database_name         
   POSTGRES_USER=admin               
   POSTGRES_PASSWORD=password_12345

   # Настройки backend
   BACKEND_API_URL=http://localhost:3001/api
   ```

      Эти же переменные указываем в проекте:
   + БД: [Пример 1](/examples/proxying/example1/server/db.js#L5-L9) [Пример 2](examples/proxying/example2/SchoolBack/src/main/resources/application.properties#L3-L8)
   + Api ссылка: [Пример 1](examples/proxying/example1/client/src/services/api.service.js#L3) [Пример 2](examples/proxying/example2/SchoolFront/lib/dataclasses/config.dart#L2)

3. **Создаем файл `docker-compose.yaml`**  
   В этом файле указываем путь к Dockerfile для каждого сервиса (frontend и backend).

---

## Сборка и запуск проекта

Для сборки и запуска контейнеров с выводом логов:
```bash
docker-compose up --build
```

Для запуска контейнеров в фоновом режиме:
```bash
docker-compose up --build -d
```

---

## Полезные ссылки
- [Конфигурация Nginx](https://nginx.org/ru/docs/beginners_guide.html)
- [Создание Dockerfile](https://habr.com/ru/companies/ruvds/articles/439980/)
- [Создание Docker Compose](https://habr.com/ru/companies/ruvds/articles/450312/)

## Благодарность
- @igrishnyakov за [проект](https://github.com/igrishnyakov/Coursework-3rd-year/tree/main)
- @p1x1n1 за [проект](https://github.com/p1x1n1/react-fullstack)
- @alexvancasper за [обучение](https://github.com/alexvancasper/sshCollector)

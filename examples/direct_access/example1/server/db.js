const { Pool } = require('pg');

// Создаем пул подключений с использованием переменных окружения
const pool = new Pool({
    user: process.env.DB_USER || 'postgres',      
    password: process.env.DB_PASSWORD || '2536', 
    host: process.env.DB_HOST || 'localhost',    
    port: process.env.DB_PORT || 5432,            
    database: process.env.DB_NAME || 'coursework'
});

module.exports = pool;
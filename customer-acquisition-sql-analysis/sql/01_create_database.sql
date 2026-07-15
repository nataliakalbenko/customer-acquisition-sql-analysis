/* 1) Перевірка / увімкнення зовнішніх ключів (FOREIGN KEY) */
PRAGMA foreign_keys;        -- якщо повертає 0 → FK вимкнені
PRAGMA foreign_keys = ON;   -- вмикаємо FK для поточного підключення
PRAGMA foreign_keys;        -- якщо повертає 1 → FK увімкнені

/* 2) Видалення таблиць, якщо вони вже існують (для перезапуску) */
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

/* 3) Створення таблиці customers (PRIMARY KEY = user_id) */
CREATE TABLE customers (
    user_id              TEXT PRIMARY KEY,
    first_name           TEXT,
    last_name            TEXT,
    email                TEXT,
    gender               TEXT,
    age                  INTEGER,
    city                 TEXT,
    acquisition_channel  TEXT,
    registration_date    TEXT  -- 'YYYY-MM-DD'
);

/* 4) Створення таблиці orders (PRIMARY KEY + FOREIGN KEY) */
CREATE TABLE orders (
    order_id          TEXT PRIMARY KEY,
    user_id           TEXT NOT NULL,
    registration_date TEXT,   
    order_date        TEXT NOT NULL, -- 'YYYY-MM-DD'
    purchase_amount   REAL NOT NULL CHECK (purchase_amount >= 0),
    order_channel     TEXT,
    payment_method    TEXT,
    items_count       INTEGER,
    delivery_days     INTEGER,
    order_status      TEXT,

    FOREIGN KEY (user_id) REFERENCES customers(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

/* 5) Індекси — "швидкі покажчики" для прискорення 
 JOIN/WHERE по ключових колонках */
CREATE INDEX idx_orders_user_id     ON orders(user_id);
CREATE INDEX idx_orders_order_date  ON orders(order_date);
CREATE TABLE IF NOT EXISTS customer (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    username TEXT NOT NULL,
    hashed_password TEXT NOT NULL,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL,
    sex TEXT,
    dob DATE,
    phone TEXT,
    email TEXT,
    password_changed_at TIMESTAMP NOT NULL DEFAULT '0001-01-01 00:00:00',
    created_at TIMESTAMP NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%f','now')),
    UNIQUE (username)
);
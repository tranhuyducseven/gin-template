-- Strong entities
CREATE TABLE IF NOT EXISTS "customer" (
    "id" bigserial primary key, 
    "username" varchar NOT NULL,
    "hashed_password" varchar NOT NULL,
    "fname" varchar NOT NULL,
    "lname" varchar NOT NULL,
    "sex" varchar,
    "dob" Date,
    "phone" varchar,
    "email" varchar,
    "password_changed_at" timestamptz NOT NULL DEFAULT '0001-01-01 00:00:00Z',
    "created_at" timestamptz NOT NULL DEFAULT (now()),
    UNIQUE ("username")
);


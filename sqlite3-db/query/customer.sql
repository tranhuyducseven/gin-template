-- name: CreateCustomer :one
INSERT INTO
  customer (
    username,
    hashed_password,
    fname,
    lname,
    sex,
    dob,
    phone,
    email
  )
VALUES
  (?, ?, ?, ?, ?, ?, ?, ?)
RETURNING *;

-- name: GetCustomer :one
SELECT * FROM customer 
WHERE username = ? LIMIT 1;

-- name: ListCustomers :many
SELECT * FROM customer 
ORDER BY id
LIMIT ?
OFFSET ?;


-- name: DeleteCustomer :exec
DELETE FROM customer
WHERE username = ?;


-- name: UpdateInfoCustomer :one
UPDATE customer
SET sex = ?, dob = ?, phone = ?, email = ?
WHERE username = ?
RETURNING *;

-- name: UpdatePasswordCustomer :one
UPDATE customer
SET hashed_password = ?, password_changed_at = ?
WHERE username = ?
RETURNING *;



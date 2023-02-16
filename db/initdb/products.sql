-- Populate customer
INSERT INTO "customer" ("username", "hashed_password", "fname", "lname", "sex", "dob", "phone", "email", "password_changed_at", "created_at")
VALUES ('user1', 'user1', 'u_one', 'u_one', 'M', NULL, '1111', '1111@gmail.com', '0001-01-01 00:00:00+00', now());

INSERT INTO "customer" ("username", "hashed_password", "fname", "lname", "sex", "dob", "phone", "email", "password_changed_at", "created_at")
VALUES ('user2', 'user2', 'u_two', 'u_two', 'M', NULL, '2222', '2222@gmail.com', '0001-01-01 00:00:00+00', now());

INSERT INTO "customer" ("username", "hashed_password", "fname", "lname", "sex", "dob", "phone", "email", "password_changed_at", "created_at")
VALUES ('user3', 'user3', 'u_three', 'u_three', 'F', NULL, '3333', '3333@gmail.com', '0001-01-01 00:00:00+00', now());


-- Populate staff and manager
INSERT INTO "staff" ("username", "password", "ssn", "fname", "lname", "dob", "sex", "salary", "phone")
VALUES ('aaa', 'aaa', '123456789', 'Andrew', 'Ed', '2000-10-02', 'Male', '100', '0931111111');

INSERT INTO "manager" ("username", "password", "ssn", "fname", "lname", "dob", "sex", "salary", "phone")
VALUES ('bbb', 'bbb', '111199999', 'Brad', 'Heal', '2000-10-02', 'Male', '100', '0937111111');


-- Populate Publisher
INSERT INTO "publisher" (pid, publishername, phone, email) 
VALUES ('1', 'Pearson', '0911234123', 'pearson@gmail.com');
INSERT INTO "publisher" (pid, publishername, phone, email) 
VALUES ('2', 'RELX', '0911234222', 'relx@gmail.com');
INSERT INTO "publisher" (pid, publishername, phone, email) 
VALUES ('3', 'HarperCollins', '0911234333', 'harpercollins@gmail.com');
INSERT INTO "publisher" (pid, publishername, phone, email) 
VALUES ('4', 'Bertelsmann', '0911234444', 'bertelsmann@gmail.com');
INSERT INTO "publisher" (pid, publishername, phone, email) 
VALUES ('5', 'Thomson Reuters', '0911234555', 'thomson_reuters@gmail.com');


-- Populate Book and category
INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Tesla Wizard at War', '2000-10-01', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('1', 'biography');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Light We Carry', '2000-10-02', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('2', 'biography');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Harry Potter And The Order of Phoenix', '2000-10-03', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('3', 'children');



INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('How To Draw 101 Cute Stuff', '2000-10-01', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('4', 'children');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Interested Facts For Curious Minds', '2000-10-02', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('5', 'children');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Bad Guys', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('6', 'children');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('A Dress of Violet Taffeta', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('7', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('All Quiet On The Western Front', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('8', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Barbara Kingsolver', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('9', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Fellowship Point', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('10', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Interview With The Vampire', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('11', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('My Best Friends Exorcism', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('12', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Our Missing Hearts', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('13', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Grand Design', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('14', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Midcoast', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('15', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Seamstress of New Orleans', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('16', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Sound of Wings', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('17', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Vampire Academy', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('18', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('What I Never Expected', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('19', 'fiction');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Art of Mixology Bartenders Guide to Rum', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('20', 'food&drink');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Complete Baking Book For Young Chefs', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('21', 'food&drink');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Ditch the Diet', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('22', 'health');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Mayo Clinic Diet Journal', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('23', 'health');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('And There Was Light', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('24', 'history');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Devotion', '2000-10-03', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('25', 'history');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Enola Holmes Book One', '2000-10-01', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('26', 'mystery');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('Slow Horses', '2000-10-02', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('27', 'mystery');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('National Geographic Photo Basics', '2000-10-03', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('28', 'photography');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('The Complete Guide to Nature Photography', '2000-10-01', '200', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('29', 'photography');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('It Ends With Us', '2000-10-02', '100', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('30', 'romance');


INSERT INTO "book" ("bookname", "publishdate", "price", "current_rating", "pid", "eid")
VALUES ('It Starts With Us', '2000-10-03', '150', '1', NULL, NULL);
INSERT INTO "category" ("boid", "acategory")
VALUES ('31', 'romance');



-- Populate Purchase method
INSERT INTO "paymentmethod" (methodname) VALUES ('Debit card Bank VCB');
INSERT INTO "paymentmethod" (methodname) VALUES ('Momo');





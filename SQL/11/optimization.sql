/*Практическое задание тема №9
1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
идентификатор первичного ключа и содержимое поля name.
2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.*/


-- 1 --
SET AUTOCOMMIT = 0;
START TRANSACTION;
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
 created_at DATETIME DEFAULT NOW(), 
 table_name VARCHAR(25),
 id INTEGER,
 field_name_value VARCHAR(255)
)
ENGINE=ARCHIVE;
DROP PROCEDURE IF EXISTS write_log;
DROP TRIGGER IF EXISTS users_insert_trg;
DROP TRIGGER IF EXISTS products_insert_trg;
DROP TRIGGER IF EXISTS catalogs_insert_trg;
DELIMITER //
CREATE PROCEDURE write_log(IN table_name_ VARCHAR(25), IN id_ INTEGER, IN field_name_value_ VARCHAR(255))
BEGIN
	INSERT INTO logs(table_name, id, field_name_value) VALUES (table_name_, id_, field_name_value_);
END//

CREATE TRIGGER users_insert_trg AFTER INSERT ON users
FOR EACH ROW
BEGIN
    CALL write_log("users", NEW.id, NEW.name);
END//

CREATE TRIGGER products_insert_trg AFTER INSERT ON products
FOR EACH ROW
BEGIN
    CALL write_log("products", NEW.id, NEW.name);
END//

CREATE TRIGGER catalogs_insert_trg AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
    CALL write_log("catalogs", NEW.id, NEW.name);
END//
DELIMITER ;
COMMIT;

-- 2 --
SET AUTOCOMMIT = 0;
SET cte_max_recursion_depth = 1000001; -- Включаем безобразие
START TRANSACTION;
SET @iter := 1;


INSERT INTO users(name,birthday_at) 
SELECT username, birthday 
FROM ( 
WITH RECURSIVE T (id, username, birthday) AS 
(
SELECT @iter,UUID(), FROM_UNIXTIME(RAND() * 2147483647)
UNION ALL
SELECT @iter := @iter + 1,
       UUID(), FROM_UNIXTIME(RAND() * 2147483647)
FROM T
WHERE @iter < 1000000
)
select username, birthday FROM T
)
COMMIT;
SET cte_max_recursion_depth = 1001; -- Выключаем безобразие
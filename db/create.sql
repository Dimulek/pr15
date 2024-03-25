USE db;

CREATE TABLE wp_user(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	login_user VARCHAR(255) NOT NULL UNIQUE,
	pass_user VARCHAR(255) NOT NULL,
	nicename_user VARCHAR(255) NOT NULL,
	email_user VARCHAR(255) NOT NULL,
	url_user VARCHAR(255) NOT NULL,
	registered_user TIMESTAMP NOT NULL,
	status_user INT NOT NULL,
	display_name_user VARCHAR(255) NOT NULL,
	
	UNIQUE(login_user),
	CONSTRAINT CH_login_user CHECK(LENGTH(login_user) > 3)
);

CREATE TABLE wp_place(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	is_valid_place BIT NOT NULL DEFAULT 1,
	code_place VARCHAR(4) NOT NULL,
	
	UNIQUE(code_place),
	CONSTRAINT CH_code_place CHECK(code_place REGEXP '[A-Z][0-9][0-9][0-9]')
);

INSERT into wp_place (code_place)
values('A000'), ('A999');

CREATE TABLE wp_usermeta(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	meta_key_user VARCHAR(100) NULL,
	meta_value_user TEXT NULL,
	
	id_user BIGINT NOT NULL,

	FOREIGN KEY(id_user) REFERENCES wp_user(ID)
);

CREATE TABLE wp_message(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	date_message BIGINT NOT NULL DEFAULT(NOW()),
	telegram_id_mesaage BIGINT NOT NULL,
	text_message TEXT NULL,
	
	id_user BIGINT NULL,
	answer_id_mesaage BIGINT NULL,

	FOREIGN KEY(id_user) REFERENCES wp_user(ID),
	FOREIGN KEY(answer_id_mesaage) REFERENCES wp_message(ID)
);

CREATE TABLE wp_document(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	file_id_document VARCHAR(100) NULL,
	file_unique_id_document VARCHAR(100) NULL,
	file_size_document BIGINT NULL,
	file_url_document TEXT NULL,
	file_mime_document TEXT NULL,
	
	id_message BIGINT NOT NULL,

	FOREIGN KEY(id_message) REFERENCES wp_message(ID)
);

CREATE TABLE wp_documentmeta(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	meta_key_document VARCHAR(100) NULL,
	meta_value_document TEXT NULL,

	id_document BIGINT NOT NULL,
	
	FOREIGN KEY(id_document) REFERENCES wp_document(ID)
);

CREATE TABLE wp_reserve(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,

	begin_reserve BIGINT NOT NULL DEFAULT(NOW()),
	end_reserve BIGINT NOT NULL,

	is_deleted_reserve BIT NOT NULL DEFAULT 0,

	id_place BIGINT NOT NULL,
	id_user BIGINT NOT NULL,

	FOREIGN KEY(id_place) REFERENCES wp_place(ID),
	FOREIGN KEY(id_user) REFERENCES wp_user(ID),
	
	CONSTRAINT CH_timestamp_reserve CHECK(begin_reserve > end_reserve)
);


-- Trigger tables

CREATE TABLE wp_auth_history(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_telegram_id BIGINT NOT NULL,
	user_login TEXT NOT NULL,
	user_auth_datetime BIGINT NOT NULL DEFAULT(NOW())
);

CREATE TABLE wp_reserve_history(
	ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_login TEXT NOT NULL,
	begin_reserve DATETIME NOT NULL,
	end_reserve DATETIME NOT NULL,
	place_code VARCHAR(4) NOT NULL,
	is_deleted_reserve BIT NOT NULL DEFAULT 0,

	id_reserve BIGINT NOT NULL
);

-- Triggers
-- CREATE OR ALTER TRIGGER reserve_insert
-- ON wp_reserve AFTER INSERT
-- AS
-- 	BEGIN
-- 		INSERT INTO wp_reserve_history(id_reserve, begin_reserve, end_reserve, user_login, place_code)
-- 			select r.ID, CAST(r.begin_reserve as datetime), CAST(r.end_reserve as datetime),
-- 				u.login_user, p.code_place
-- 			from inserted r
-- 			inner join wp_user u on id_user = u.ID
-- 			inner join wp_place p on id_place = p.ID

-- 	END
-- GO

-- CREATE OR ALTER TRIGGER reserve_update
-- ON wp_reserve AFTER UPDATE
-- AS
-- 	BEGIN
-- 		UPDATE wp_reserve_history set is_deleted_reserve = 1 
-- 			WHERE id_reserve = (select ID from inserted);

-- 	END
-- GO

-- INSERT

-- Place

-- WITH Nums AS
-- (
--   SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
--   FROM sys.all_objects 

-- ), Letters AS
-- (
--   SELECT n1 = ROW_NUMBER() OVER (ORDER BY [object_id]) 
--   FROM sys.all_objects 

-- )
-- insert into wp_place(code_place)
-- SELECT Char(n) + iif(n1-1 >= 10, iif(n1-1 >= 100, '', '0'), '00') + Cast(n1- 1 as varchar(3)) FROM Nums, Letters
-- WHERE n BETWEEN 65 AND 70
-- And n1 BETWEEN 0 AND 100
-- Order by n, n1

-- INSERT INTO wp_place (code_place)
-- SELECT CONCAT(CHAR(n), IF(n1-1 >= 10, IF(n1-1 >= 100, '', '0'), '00'), CAST(n1-1 AS text))
-- FROM (
--     SELECT n
--     FROM (
--         SELECT @row_number:=@row_number+1 AS n
--         FROM (SELECT @row_number:=0) AS t,
--         (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS n1,
--         (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS n2
--     ) AS nums
--     WHERE n BETWEEN 65 AND 70
-- ) AS result
-- CROSS JOIN (
--     SELECT n1
--     FROM (
--         SELECT @row_number1:=@row_number1+1 AS n1
--         FROM (SELECT @row_number1:=0) AS t,
--         (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS n1
--     ) AS letters
--     WHERE n1 BETWEEN 0 AND 100
-- ) AS result1
-- ORDER BY n, n1;

--
-- select ID, is_valid_place, code_place from wp_place
-- FORMAT(CAST(date_message as datetime), 'dd.mm.yyyy hh:mm:ss', 'de-de')
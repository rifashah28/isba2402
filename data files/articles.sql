USE test;

CREATE TABLE articles (
id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
title VARCHAR(200),
body TEXT
) ENGINE=InnoDB;


INSERT INTO articles (title,body) VALUES
('MySQL Tutorial','DBMS stands for DataBase ...'),
('How To Use Mysql Well','After you went through a ...'),
('Optimizing Database','In this tutorial, we show database...'),
('1001 mySQL Tricks','1. Never run mysqld as root. 2. ...'),
('MySQL vs. YourSQL','In the following database comparison ...'),
('Database Database','database comparison, database syntax, database ...'),
('MySQL Security','When configured properly, MySQL ...');
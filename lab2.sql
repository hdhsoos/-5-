CREATE DATABASE BookshopDB0
ON
(
name = 'BookshopDB0_dat',
filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BookshopDB0_dat.mdf'
)
LOG ON
(
name = 'BookshopDB0_log',
filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BookshopDB0_dat.ldf'
)
CREATE TABLE Authors1
(
AuthorID int identity NOT NULL,
FirstName varchar(30) NOT NULL DEFAULT 'unknown',
LastName varchar(30) NULL,
YearBorn char(4) NULL,
YearDied char(4) NOT NULL DEFAULT 'no',
)

EXEC sp_help Authors1

ALTER TABLE Authors1 ADD Deser varchar(200) NOT NULL

CREATE TABLE Books1
(
BookID int NOT NULL PRIMARY KEY,
Title varchar(100) NOT NULL,
Genre varchar(150) NULL
)

ALTER TABLE Authors1
ADD PRIMARY KEY (AuthorID)
GO

ALTER TABLE Authors1
ADD CHECK (YearBorn LIKE '[1-2][0-9][0-9][0-9]')
GO

ALTER TABLE Authors1
ADD CHECK (YearDied LIKE '[1-2][0-9][0-9][0-9]' or YearDied LIKE 'no')
GO

ALTER TABLE Authors1
ADD CHECK (YearDied > YearBorn)
GO

use master;
ALTER TABLE Authors1
ADD CONSTRAINT check_YearBorn_YearDied
CHECK (YearDied > YearBorn);

INSERT INTO Authors1 (FirstName, LastName, YearBorn, YearDied, Deser)
VALUES
('Джейн', 'Остен', '1775', '1817', 'Английская писательница'),
('Агата', 'Кристи', '1890', '1976', 'Британская писательница'),
('Анна', 'Ахматова', '1889', '1966', 'Русская поэтесса, номинантка Нобелевской премии'),
('Вирджиния', 'Вулф', '1882', '1941', 'Британская писательница');

INSERT INTO Books1 (BookID, Title, Genre)
VALUES
(1, 'Гордость и предубеждение', 'Роман'),
(2, 'Убийство в восточном экспрессе', 'Детективный роман'),
(3, 'Реквием', 'Поэма'),
(4, 'Своя комната', 'Эссе')

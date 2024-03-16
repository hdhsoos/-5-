USE master;

GO

CREATE DATABASE ShopDB;

CREATE TABLE Goods 
	(DeptID INT NOT NULL DEFAULT 1 CHECK (DeptID >= 1 AND DeptID <=10), /*номер отдела, целое, 1 по умолчанию, от 1 до 10*/
	GoodID INT NOT NULL IDENTITY (10, 10) PRIMARY KEY, /*номер товара, целое, первичный ключ, увелич на 10*/
	GName VARCHAR(20) NOT NULL,  /*наименование товара, уникальность*/
	Descr VARCHAR(50) NULL,  /*описание товара, уникальность*/
	Price SMALLMONEY NOT NULL CHECK(Price > 0), /*цена товара, больше 0*/
	GCount INT NOT NULL CHECK(GCount > 0), /*количество, больше 0*/
	UNIQUE(GName, Descr));

INSERT INTO Goods VALUES
	(1,'ручка','шариковая', 2, 100),
	(1,'ручка','гелевая', 10, 50),
	(1,'карандаш','простой', 5, 200),
	(1,'карандаш','механический', 10, 30),
	(2,'мыло','хозяйственное', 6, 200),
	(2,'мыло','детское', 7, 150),
	(2,'шампунь','"Чистая Линия"', 50, 7);
/*номер отдела, (номер товара сам формируется), имя товара, описание товара, цена, количество*/
INSERT INTO Goods VALUES
	(3, 'хлеб', 'сельский', 20, 30),
	(DEFAULT, 'ручка', NULL, 15, 40);

DELETE FROM Goods WHERE Descr IS NULL; /*удаляем все строки без описания*/
UPDATE Goods SET Price = Price * 1.1; /*увеличиваем цены*/
SELECT * FROM Goods; /*выводим*/

SELECT GoodID, GName, Descr FROM Goods WHERE DeptID = 1; /*выводим номер имя и описания всего первого отдела*/
SELECT * FROM Goods WHERE Price BETWEEN 10 AND 30; /*выводим товары с ценой от 10 до 30*/

SELECT * FROM Goods WHERE DeptID IN (1, 3) ; /* выводим все сведения о товарах первого и третьего отделов */
SELECT * FROM Goods WHERE GName LIKE 'р%' ; /* выводим все сведения о товарах, имя которых начинается на 'р': */
SELECT * FROM Goods WHERE GName LIKE '%#_%' ESCAPE '#' ; /* выводим все сведения о товарах, в имени которых встречается символ _*/

SELECT GName FROM Goods; /* выводим наименования всех товаров */
SELECT GName FROM Goods GROUP BY GName;  /* выводим наименования всех товаров без повторений */

SELECT *, Price * GCount AS Cost FROM Goods; /*вывод всей таблицы и подсчет цена*количество в дополнительном столбце*/

SELECT MIN(Price) AS MinPrice, AVG(Price) AS AvPrice, MAX(Price) AS MaxPrice FROM Goods; 
/* выводим минимальную, среднюю, максимальную цены по всем товарам */
SELECT COUNT(DISTINCT GName) AS NameCount FROM Goods WHERE DeptID = 1;
/* считаем количество уникальных наименований */
SELECT COUNT(GoodID) AS GoodsCount FROM Goods WHERE Descr IS NOT NULL;
/* выводим количество товаров c описанием */
SELECT SUM(Price * GCount) AS SumCost FROM Goods WHERE DeptID = 2;
/* выводим суммарную стоимость (произведение цены на колво!) товаров по второму отделу */

SELECT * FROM Goods ORDER BY GName; /* вывод с сортировкой по имени*/
SELECT * FROM Goods ORDER BY DeptID, Price DESC; /* вывод с сортировкой по отделам и по убыванию цены */

SELECT DeptID, SUM(Price * GCount) AS TotalCost FROM Goods GROUP BY DeptID;
/* выводим стоимость товара по каждому отделу */
SELECT AVG(Price) AS AVG9Price FROM Goods WHERE Price > 9;
/* выводим среднюю цену по товарам, цена которых превышает 9 */
SELECT DISTINCT GName, MAX(Price) AS MaxPriceForType FROM Goods GROUP BY GName;
/* выводим максимальную цену по каждому наименованию товара */
SELECT DISTINCT DeptID FROM Goods GROUP BY DeptID HAVING COUNT(GName) > 2;
/* выводим номера отделов, где продаётся более двух наименований товаров */
USE ShopDB;

CREATE TABLE Departments 
	(DeptID INT NOT NULL PRIMARY KEY CHECK (DeptID >= 1 AND DeptID <=10),
	DeptName VARCHAR(50) NOT NULL);
/*номер отдела первичный ключ, ненулевой от 1 до 10, название ненулевое*/

INSERT INTO Departments (DeptID, DeptName)
	SELECT DeptID, '' FROM Goods GROUP BY DeptID;
/*заполняем*/

SELECT * FROM Departments, Goods;
/* выводим декартово произведение таблиц Departments и Goods */
SELECT * FROM Departments, Goods WHERE Departments.DeptID = Goods.DeptID;
/* выводим декартово произведение с условием соединения по столбцу DeptID */

SELECT * FROM Departments INNER JOIN Goods ON Departments.DeptID = Goods.DeptID;
/*Внутреннее соединение таблиц с помощью JOIN*/

INSERT INTO Departments VALUES (4, 'Заморозка');
SELECT * FROM Departments LEFT OUTER JOIN Goods ON Departments.DeptID = Goods.DeptID;
/*левое внешнее соединение*/

INSERT INTO Goods VALUES (5, 'колбаса', '"Молочная"', 50, 130);
SELECT * FROM Departments RIGHT OUTER JOIN Goods ON Departments.DeptID = Goods.DeptID;
/* правое внешнее соединение */
SELECT * FROM Departments FULL OUTER JOIN Goods ON Departments.DeptID = Goods.DeptID;
/* полное соединение */

SELECT *
FROM Departments FULL OUTER JOIN Goods ON Departments.DeptID = Goods.DeptID
EXCEPT
SELECT *
FROM Departments, Goods;
/* выводим все отделы и все товары, для которых не найдено соответствия в другой таблице */

SELECT DISTINCT Departments.DeptID, DeptName
FROM Departments, Goods
WHERE Departments.DeptID = ANY (
	SELECT Goods.DeptID
	FROM Departments
	WHERE (Goods.GName IS NOT NULL AND Goods.DeptID = Departments.DeptID));
/* выводим все отделы, в которых продаётся хотя бы 1 товар */

SELECT Goods.DeptID, MAX(Departments.DeptName) AS DeptName, SUM(Goods.Price * Goods.GCount) AS SumCost
FROM Departments LEFT OUTER JOIN Goods
ON Departments.DeptID = Goods.DeptID
WHERE (Goods.DeptID IS NOT NULL)
GROUP BY Goods.DeptID;
/* вычисляем суммарную стоимость проданного товара по отделам*/
SELECT TOP 1 Goods.DeptID, SUM(Goods.Price * Goods.GCount) AS SumCost, MAX(Departments.DeptName) AS DeptName
FROM Departments LEFT OUTER JOIN Goods
ON Departments.DeptID = Goods.DeptID
WHERE (Goods.DeptID IS NOT NULL)
GROUP BY Goods.DeptID 
ORDER BY SumCost DESC;
/* выводим номер и название отдела, где суммарная стоимость проданного товара максимальна */
SELECT TOP 2 Goods.DeptID, MAX(Departments.DeptName) AS DeptName, SUM(Goods.Price * Goods.GCount) AS SumCost
FROM Departments LEFT OUTER JOIN Goods
ON Departments.DeptID = Goods.DeptID
WHERE (Goods.DeptID IS NOT NULL)
GROUP BY Goods.DeptID 
ORDER BY SumCost DESC;
/* выводим два отдела с наибольшими суммами проданного товара: */

SELECT Goods.GoodID, MAX(Goods.GName) AS GName, MAX(Goods.Descr) AS Descr, MAX((Goods.Price * Goods.GCount)/CA.CostAll) * 100 AS Percents
FROM Goods, (SELECT DeptID,sum(Goods.Price * Goods.GCount) AS CostALL FROM Goods GROUP BY Goods.DeptID) AS CA
WHERE Goods.DeptID = CA.DeptID
GROUP BY Goods.GoodID;
/* выводим для каждого товара процентное отношение его стоимости к стоимости всех товаров в отделе в сумме */

UPDATE Goods SET Goods.Price = Goods.Price + ReturnsAVG.Average
FROM (SELECT AVG(Goods.Price)/10 AS Average FROM Goods) AS ReturnsAVG;
/* повышаем цену на все товары на 10% относительно средней цены на товар по всей таблице Goods */

CREATE TABLE Discount(
	DeptID INT NOT NULL DEFAULT 1 CHECK (DeptID >= 1 AND DeptID <= 10),
	GoodID INT NOT NULL PRIMARY KEY,
	GName VARCHAR(20) NOT NULL,
	Descr VARCHAR(50) NULL,
	Price SMALLMONEY NOT NULL CHECK (Price > 0),
	GCount INT NOT NULL CHECK (GCount > 0),
	GDiscount SMALLMONEY DEFAULT 0
	UNIQUE (GName,Descr)
);
/*Создаём таблицу Discount*/

INSERT INTO Discount (DeptID, GoodID, GName, Descr, Price, GCount)
SELECT Goods.DeptID, Goods.GoodID ,Goods.GName, Goods.Descr, Goods.Price, Goods.GCount FROM Goods;
/*Заполняем значениями из таблицы Goods*/

UPDATE Discount SET GDiscount = Price/5 WHERE (Discount.Price < 10) ;
UPDATE Discount SET GDiscount = Price/10 WHERE (Discount.Price >= 10) AND (Discount.Price <= 50);
UPDATE Discount SET GDiscount = Price/20 WHERE (Discount.Price > 50) ;
/*Устанавливаем скидки */

INSERT INTO Departments
VALUES (5, 'Мясной')
ALTER TABLE Goods  
ADD FOREIGN KEY (DeptID) REFERENCES Departments(DeptID);
/* cвязываем таблицы Departments и Goods по ключу DeptID */
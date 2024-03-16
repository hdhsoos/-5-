USE master;

GO

CREATE DATABASE ShopDB;

CREATE TABLE Goods 
	(DeptID INT NOT NULL DEFAULT 1 CHECK (DeptID >= 1 AND DeptID <=10), /*����� ������, �����, 1 �� ���������, �� 1 �� 10*/
	GoodID INT NOT NULL IDENTITY (10, 10) PRIMARY KEY, /*����� ������, �����, ��������� ����, ������ �� 10*/
	GName VARCHAR(20) NOT NULL,  /*������������ ������, ������������*/
	Descr VARCHAR(50) NULL,  /*�������� ������, ������������*/
	Price SMALLMONEY NOT NULL CHECK(Price > 0), /*���� ������, ������ 0*/
	GCount INT NOT NULL CHECK(GCount > 0), /*����������, ������ 0*/
	UNIQUE(GName, Descr));

INSERT INTO Goods VALUES
	(1,'�����','���������', 2, 100),
	(1,'�����','�������', 10, 50),
	(1,'��������','�������', 5, 200),
	(1,'��������','������������', 10, 30),
	(2,'����','�������������', 6, 200),
	(2,'����','�������', 7, 150),
	(2,'�������','"������ �����"', 50, 7);
/*����� ������, (����� ������ ��� �����������), ��� ������, �������� ������, ����, ����������*/
INSERT INTO Goods VALUES
	(3, '����', '��������', 20, 30),
	(DEFAULT, '�����', NULL, 15, 40);

DELETE FROM Goods WHERE Descr IS NULL; /*������� ��� ������ ��� ��������*/
UPDATE Goods SET Price = Price * 1.1; /*����������� ����*/
SELECT * FROM Goods; /*�������*/

SELECT GoodID, GName, Descr FROM Goods WHERE DeptID = 1; /*������� ����� ��� � �������� ����� ������� ������*/
SELECT * FROM Goods WHERE Price BETWEEN 10 AND 30; /*������� ������ � ����� �� 10 �� 30*/

SELECT * FROM Goods WHERE DeptID IN (1, 3) ; /* ������� ��� �������� � ������� ������� � �������� ������� */
SELECT * FROM Goods WHERE GName LIKE '�%' ; /* ������� ��� �������� � �������, ��� ������� ���������� �� '�': */
SELECT * FROM Goods WHERE GName LIKE '%#_%' ESCAPE '#' ; /* ������� ��� �������� � �������, � ����� ������� ����������� ������ _*/

SELECT GName FROM Goods; /* ������� ������������ ���� ������� */
SELECT GName FROM Goods GROUP BY GName;  /* ������� ������������ ���� ������� ��� ���������� */

SELECT *, Price * GCount AS Cost FROM Goods; /*����� ���� ������� � ������� ����*���������� � �������������� �������*/

SELECT MIN(Price) AS MinPrice, AVG(Price) AS AvPrice, MAX(Price) AS MaxPrice FROM Goods; 
/* ������� �����������, �������, ������������ ���� �� ���� ������� */
SELECT COUNT(DISTINCT GName) AS NameCount FROM Goods WHERE DeptID = 1;
/* ������� ���������� ���������� ������������ */
SELECT COUNT(GoodID) AS GoodsCount FROM Goods WHERE Descr IS NOT NULL;
/* ������� ���������� ������� c ��������� */
SELECT SUM(Price * GCount) AS SumCost FROM Goods WHERE DeptID = 2;
/* ������� ��������� ��������� (������������ ���� �� �����!) ������� �� ������� ������ */

SELECT * FROM Goods ORDER BY GName; /* ����� � ����������� �� �����*/
SELECT * FROM Goods ORDER BY DeptID, Price DESC; /* ����� � ����������� �� ������� � �� �������� ���� */

SELECT DeptID, SUM(Price * GCount) AS TotalCost FROM Goods GROUP BY DeptID;
/* ������� ��������� ������ �� ������� ������ */
SELECT AVG(Price) AS AVG9Price FROM Goods WHERE Price > 9;
/* ������� ������� ���� �� �������, ���� ������� ��������� 9 */
SELECT DISTINCT GName, MAX(Price) AS MaxPriceForType FROM Goods GROUP BY GName;
/* ������� ������������ ���� �� ������� ������������ ������ */
SELECT DISTINCT DeptID FROM Goods GROUP BY DeptID HAVING COUNT(GName) > 2;
/* ������� ������ �������, ��� �������� ����� ���� ������������ ������� */
if object_id('Product') is null
begin
	create table Product(
		ID int identity(1,1) primary key,
		Name nvarchar(20) not null
	)
end

if object_id('Category') is null
begin
	create table Category(
		ID int identity(1,1) primary key,
		Name nvarchar(20) not null
	)
end

if object_id('ProductCategory') is null
begin
	create table ProductCategory(
		ID int identity(1,1) primary key,
		ID_Product int foreign key references Product(ID) not null,
		ID_Category int foreign key references Category(ID) null
	)
end

merge into Product as tgtprod
using (
	values (N'Product 1')
		,(N'Product 2')
		,(N'Product 3')
		,(N'Product 4')
		,(N'Product 5')
) as srcprod (Name)
on tgtprod.Name = srcprod.Name
when not matched then
	insert (Name)
	values (srcprod.Name);


merge into Category as tgtcat
using (
	values (N'Category 1')
		,(N'Category 2')
		,(N'Category 3')
		,(N'Category 4')
		,(N'Category 5')
) as srccat (Name)
on tgtcat.Name = srccat.Name
when not matched then
	insert (Name)
	values (srccat.Name);

merge into ProductCategory as tgtpc
using (
	select prod.ID as ProdID, cat.ID as CatID 
	from(
		values (N'Product 1', N'Category 1')
		,(N'Product 1', N'Category 2')
		,(N'Product 2', N'Category 1')
		,(N'Product 2', N'Category 2')
		,(N'Product 2', N'Category 3')
		,(N'Product 3', N'Category 3')
		,(N'Product 3', N'Category 4')
		,(N'Product 4', N'Category 4')
		,(N'Product 4', N'Category 5')
		,(N'Product 5', N'Category 6')
		,(N'Product 5', N'Category 7')
	) as scrpc (NameProduct, NameCategory)
	inner join Product as prod on scrpc.NameProduct = prod.Name
	left join Category as cat on scrpc.NameCategory = cat.Name
) as s on s.ProdID = tgtpc.ID_Product and s.CatID = tgtpc.ID_Category
when not matched then
	insert (ID_Product, ID_Category)
	values (s.ProdID, s.CatID);

select distinct prod.Name as [Product Name], cat.Name as [Category Name]
from Product as prod
left join ProductCategory as pc on prod.ID = pc.ID_Product
left join Category as cat on pc.ID_Category = cat.ID
select SaleDate, CONVERT(date, SaleDate)
FROM [nashville project].[dbo].housing ;

UPDATE [nashville project].[dbo].housing
SET SaleDate = CONVERT(date, SaleDate);


ALTER TABLE [nashville project].[dbo].housing
ADD SaleDateConverted date;

UPDATE [nashville project].[dbo].housing
SET SaleDateConverted = CONVERT(date, SaleDate);

select *
FROM [nashville project].[dbo].housing ;

--fill in NULL property address

SELECT UniqueID, ParcelID, PropertyAddress 
FROM [nashville project].[dbo].housing
WHERE PropertyAddress IS NULL;

SELECT a.[UniqueID ], a.ParcelID,a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b. PropertyAddress)
FROM [nashville project].[dbo].housing a
 JOIN [nashville project].[dbo].housing b
   ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <>  b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL

  UPDATE  a
  SET a.PropertyAddress = ISNULL(a.PropertyAddress, b. PropertyAddress)
  FROM [nashville project].[dbo].housing a
 JOIN [nashville project].[dbo].housing b
   ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <>  b.[UniqueID ]

	--SPLIT PROPERTY ADDRESS INTO ADDRESS, CITY & STATE

	SELECT PropertyAddress 
	FROM [nashville project].[dbo].housing

	
	SELECT 
	SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address
	, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) AS CityAddress
	FROM [nashville project].[dbo].housing;

	ALTER TABLE [nashville project].[dbo].housing
    ADD PropertyHomeAddress nvarchar(255);

	update [nashville project].[dbo].housing
     set PropertyHomeAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) ;

	 ALTER TABLE [nashville project].[dbo].housing
    ADD PropertyCityAddress nvarchar(255);

	update [nashville project].[dbo].housing
     set PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) ;

	 SELECT * 
	FROM [nashville project].[dbo].housing

--	SPLIT OWNERS ADDRESS INTO ADRESS, CITY & STATE

    SELECT OwnerAddress 
	FROM [nashville project].[dbo].housing
	where OwnerAddress is not NULL

	SELECT
	PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
		,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
			,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
	FROM [nashville project].[dbo].housing

 
	ALTER TABLE [nashville project].[dbo].housing
    ADD OwnerHomeAddress nvarchar(255);

	update [nashville project].[dbo].housing
     set OwnerHomeAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);

	 ALTER TABLE [nashville project].[dbo].housing
    ADD OwnerCityAddress nvarchar(255);

	update [nashville project].[dbo].housing
     set OwnerCityAddress =PARSENAME(REPLACE(OwnerAddress,',','.'), 2)  ;

      ALTER TABLE [nashville project].[dbo].housing
    ADD OwnerStateAddress nvarchar(255);

	update [nashville project].[dbo].housing
     set OwnerStateAddress =PARSENAME(REPLACE(OwnerAddress,',','.'), 2)  ;


	 -- REPLACE 'Y' AND 'N'  WITH 'YES' AND 'NO' RESPECTIVELY

	 SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
	 FROM [nashville project].[dbo].housing
	 GROUP BY SoldAsVacant
	 order by 2

	 
	 SELECT SoldAsVacant,
	    CASE  WHEN SoldAsVacant = 'Y' THEN 'YES'
		      WHEN SoldAsVacant = 'N' THEN 'NO'
			  ELSE SoldAsVacant
			  END
	FROM [nashville project].[dbo].housing

	update [nashville project].[dbo].housing
	set SoldAsVacant = CASE  WHEN SoldAsVacant = 'Y' THEN 'YES'
		      WHEN SoldAsVacant = 'N' THEN 'NO'
			  ELSE SoldAsVacant
			  END

	 SELECT * 
	 FROM [nashville project].[dbo].housing;

	 --DELETE UNWANTED COLUMNS
	 ALTER TABLE [nashville project].[dbo].housing
	 DROP COLUMN SaleDate, PropertyAddress, OwnerAddress,Address,  CityAddress, PropertySplitAddress ;
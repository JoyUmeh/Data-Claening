SELECT*
FROM NashvilleHousing

--cleaning the date

SELECT SaleDate, CONVERT (Date, SaleDate) 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Saledateconverted date

UPDATE NashvilleHousing
SET Saledateconverted = CONVERT (Date, SaleDate)

-- to populate adress

SELECT PropertyAddress
FROM NashvilleHousing

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.propertyaddress, b.propertyaddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET Propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID =b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- breaking down address to individual column

SELECT
PARSENAME(REPLACE(Propertyaddress, ',', '.'),2),
PARSENAME(REPLACE(Propertyaddress, ',', '.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
add Propertsplityaddress nvarchar (255);

ALTER TABLE NashvilleHousing
add Propertsplitycity nvarchar (255);

UPDATE NashvilleHousing
SET Propertsplityaddress = PARSENAME(REPLACE(Propertyaddress, ',', '.'),2)

UPDATE NashvilleHousing
SET Propertsplitycity = PARSENAME(REPLACE(Propertyaddress, ',', '.'),1)

SELECT
PARSENAME(REPLACE(Owneraddress, ',', '.'),3),
PARSENAME(REPLACE(Owneraddress, ',', '.'),2),
PARSENAME(REPLACE(Owneraddress, ',', '.'),1)
FROM NashvilleHousing

ALTER TABLE Nashvillehousing
add ownersplitaddress nvarchar (255);

ALTER TABLE Nashvillehousing
add ownersplitcity nvarchar (255);

ALTER TABLE Nashvillehousing
add ownersplitstate nvarchar (255);

UPDATE NashvilleHousing
SET Ownersplitaddress = PARSENAME(REPLACE(Owneraddress, ',', '.'),3)

UPDATE NashvilleHousing
SET Ownersplitcity = PARSENAME(REPLACE(Owneraddress, ',', '.'),2)

UPDATE NashvilleHousing
SET Ownersplitstate = PARSENAME(REPLACE(Owneraddress, ',', '.'),1)

--change Y&N to yes or No

SELECT Soldasvacant
,CASE When soldasvacant = 'Y' then 'Yes'
     When soldasvacant = 'N' then 'No'
	 ELSE soldasvacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =CASE When soldasvacant = 'Y' then 'Yes'
     When soldasvacant = 'N' then 'No'
	 ELSE soldasvacant
	 END
FROM NashvilleHousing 

SELECT DISTINCT(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant

-- delete unused column

ALTER TABLE Nashvillehousing
DROP column owneraddress, propertyaddress, saledate,taxdistrict
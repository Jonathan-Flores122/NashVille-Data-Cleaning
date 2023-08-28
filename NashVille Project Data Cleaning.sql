select *
from NashvilleHousing

------------------------------------------------------------------------------------------
--Standardize Date Format

select SaleDateConverted, CONVERT(date, SaleDate)
from NashvilleHousing


update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

-------------------------------------------------------------------------------------------

--Populate Property Address data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
	from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing

SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

from NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress NVARCHAR(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity NVARCHAR(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
from NashvilleHousing









SELECT OwnerAddress
from NashvilleHousing

select
PARSENAME(replace(OwnerAddress,',','.'), 3),
PARSENAME(replace(OwnerAddress,',','.'), 2),
PARSENAME(replace(OwnerAddress,',','.'), 1)
from NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3)

alter table NashvilleHousing
add OwnerSplitCity NVARCHAR(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'), 2)

alter table NashvilleHousing
add OwnerSplitState NVARCHAR(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'), 1)


select *
from NashvilleHousing

------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold as Vacant" field

select distinct SoldAsVacant, count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2 



select SoldAsVacant,
 case when SoldAsVacant = 'Y' THEN 'YES'
	  when SoldAsVacant = 'N' THEN 'No'
	  else SoldAsVacant
	  end
from NashvilleHousing


update NashvilleHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'YES'
	  when SoldAsVacant = 'N' THEN 'No'
	  else SoldAsVacant
	  end

---------------------------------------------------------------------------------------------------------------------



--Remove Duplicates

with RowNumCTE AS (
select *,
ROW_NUMBER() over(
	partition by parcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					uniqueID
					) row_num



from NashvilleHousing
--order by ParcelID
)

select * 
from RowNumCTE
where row_num > 1


-----------------------------------------------------------------------------------------------------------------------


--Delete Unused Columns

select *
from NashvilleHousing



alter table NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress


alter table NashvilleHousing
drop column SaleDate

-------------------------------------------------------------------------------------------------------------------------
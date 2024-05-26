select * from nashville_housing_data



# Changing SaleDate format to date



SELECT SaleDate, STR_TO_DATE(SaleDate, '%M %e, %Y') AS FormattedSaleDate
FROM nashville_housing_data;


alter table nashville_housing_data 
add SalesDateCleaned date


update nashville_housing_data 
set SalesDateCleaned = STR_TO_DATE(SaleDate, '%M %e, %Y')


select * from nashville_housing_data




# populating property address data (null)


select * 
from nashville_housing_data 
order by ParcelID 



select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,COALESCE(NULLIF(a.PropertyAddress, ''), b.PropertyAddress)
from nashville_housing_data a
join nashville_housing_data b
on a.ParcelID = b.ParcelID and a.id <> b.id
where a.PropertyAddress = ""

UPDATE nashville_housing_data a
JOIN nashville_housing_data b ON a.ParcelID = b.ParcelID AND a.id <> b.id
SET a.PropertyAddress = COALESCE(NULLIF(a.PropertyAddress, ''), b.PropertyAddress)
WHERE a.PropertyAddress = '';


select * 
from nashville_housing_data 
where PropertyAddress = ""






# Cleaning PropertyAddress Column



select SUBSTRING_INDEX(PropertyAddress, ',', 1) AS First,
SUBSTRING_INDEX(PropertyAddress, ',', -1) AS Second
FROM nashville_housing_data;

alter table nashville_housing_data 
add column PropertySpliAddress varchar(225);

alter table nashville_housing_data 
add column PropertySplicity varchar(225);

update nashville_housing_data 
set PropertySpliAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1)

update nashville_housing_data 
set PropertySpliCity = SUBSTRING_INDEX(PropertyAddress, ',', -1)






# Cleaning Owner Address


select OwnerAddress 
from nashville_housing_data 


select substring_index(OwnerAddress,",",1) as address,
substring_index(substring_index(OwnerAddress,",",-2),",",1) as city,
substring_index(OwnerAddress,",",-1) as state
from nashville_housing_data 

alter table nashville_housing_data 
add column OwnerSplitAddress varchar(225)

alter table nashville_housing_data 
add column OwnerSplitCity varchar(225)

alter table nashville_housing_data 
add column OwnerSplitState varchar(225)


update nashville_housing_data
set OwnerSplitAddress = substring_index(OwnerAddress,",",1)

update nashville_housing_data 
set OwnerSplitCity  = substring_index(substring_index(OwnerAddress,",",-2),",",1)

update nashville_housing_data 
set OwnerSplitState = substring_index(OwnerAddress,",",-1)

select * from nashville_housing_data nhd 






# change Y and N to Yes and No in Sold As Vacant



select distinct (SoldAsVacant) , count(SoldAsVacant) 
from nashville_housing_data nhd
group by (SoldAsVacant)
order by count(SoldAsVacant)


select SoldAsVacant ,
case 
when SoldAsVacant = "N" then "No"
when SoldAsVacant = "Y" then "Yes"
else SoldAsVacant 
end
from nashville_housing_data  

update nashville_housing_data 
set SoldAsVacant = case 
	when SoldAsVacant = "N" then "No"
	when SoldAsVacant = "Y" then "Yes"
	else SoldAsVacant 
	end



# Removing Duplicatces



with cte as (	
select *,
row_number() over(partition by ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference 
	order by id) row_num
from nashville_housing_data nhd 
),
nashville_cleaned as(
select * 
from cte
where row_num = 1
)
select * from nashville_cleaned



# Now we can remove any colum we want or deemed unnessesary


/* alter table nashville_housing_data
   delete column column_name
 */



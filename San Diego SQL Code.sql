
----SELECTING TOP 100 ROWS----

SELECT TOP 1000 * FROM [San Diego 2]

----CHANGING 'neighbourhood' AND 'neighbourhood_cleansed' COLUMNS NAME TO 'city' AND 'neighbourhood'----

EXEC sp_rename '[San Diego 2].neighbourhood', 'city', 'COLUMN';

EXEC sp_rename '[San Diego 2].neighbourhood_cleansed', 'neighbourhood', 'COLUMN';

---- SELECTING DISTINCT DATA IN 'city' COLUMN----

SELECT DISTINCT(city) FROM [San Diego 2]


SELECT DISTINCT city
FROM [San Diego 2]
ORDER BY city ASC;


--SELECT AND COUNT DISTINCT CATEGORIES--


SELECT city, COUNT(*) FROM [San Diego 2]
GROUP BY city


--SELECTING DATA THAT NEEDS LTRIM --FIXED--


SELECT city FROM [San Diego 2]
WHERE city LIKE ' %';


----UPDATING DATA THAT NEEDS LTRIM 'city' COLUMN WITH "LTRIM"----


UPDATE [San Diego 2]
SET city = LTRIM(city)
WHERE city LIKE ' %';


----REMOVING EXTRA SPACES IN BETWEEN COMMAS----

--CREATING A FUNCTION TO REMOVE EXTRA SPACES BEFORE COMMAS--


CREATE FUNCTION dbo.CleanSpacesBEFORECommas(@input_string VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @output_string VARCHAR(MAX);
    SET @output_string = @input_string;

    WHILE CHARINDEX(' ,', @output_string) > 0
    BEGIN
        SET @output_string = REPLACE(@output_string, ' ,', ',');
    END;

    RETURN @output_string;
END;


----REMOVING EXTRA SPACES FROM 'city' COLUMN----

UPDATE [San Diego 2]
SET city = dbo.CleanSpacesBEFORECommas(city)
WHERE city LIKE '% ,%';


----UPDATING 'city' DUPLICATE DATA AND FORMATTING THE CITY ADDRESSES----


BEGIN TRANSACTION;
UPDATE [San Diego 2]
SET city = 
    CASE

        WHEN city LIKE 'San Diego%' THEN 'San Diego, California, United States'
        WHEN city LIKE 'Chula Vista%' THEN 'Chula Vista, California, United States'
        WHEN city LIKE 'La Jolla%' THEN 'La Jolla, California, United States'
        WHEN city LIKE 'Ocean Beach%' THEN 'Ocena Beach, San Diego, California, United States'
        WHEN city LIKE 'CA%' THEN 'California, United States'

    END

WHERE (city LIKE 'San Diego%' OR city LIKE 'Chula Vista%' OR city LIKE 'La Jolla%' OR city LIKE 'Ocean Beach%' OR city LIKE 'CA%')
AND city NOT LIKE '%Cove%';
COMMIT TRANSACTION; 


----FIX NULL DATA----

/* We will update 'city' base on 'neighbourhood' column */

--CHECKING THE DIFFERENT 'neighbourhood' 

SELECT DISTINCT neighbourhood
FROM [San Diego 2]
ORDER BY neighbourhood ASC;


--GROUPING BY 'neighbourhood' WHERE 'city' IS NULL

SELECT neighbourhood, COUNT(*) AS count
FROM [San Diego 2]
WHERE city IS NULL 
GROUP BY neighbourhood
ORDER BY neighbourhood;


--UPDATING NULL VALUES IN 'city' COLUMN--

UPDATE [San Diego 2]
SET city = (
    SELECT TOP 1 city
    FROM [San Diego 2]
    WHERE neighbourhood = [San Diego 2].[neighbourhood]
    AND city IS NOT NULL
)
WHERE city IS NULL;

/* 'city' column is updated */ 


----CHECKING PROPERTY TYPES----

SELECT DISTINCT property_type
FROM [San Diego 2]
ORDER BY property_type ASC;

--LOOKS FINE--

--CHECKING ROOM TYPES--

SELECT DISTINCT room_type
FROM [San Diego 2]
ORDER BY room_type ASC;

--LOOKS FINE--

----FIXING BATHROOM COLUMN WITH BATHROOM_TEXT COLUMN----

SELECT * FROM [San Diego 2]
WHERE bathrooms IS NULL 

SELECT DISTINCT bathrooms
FROM [San Diego 2]
ORDER BY bathrooms ASC;

SELECT bathrooms, COUNT(*) FROM [San Diego 2]
GROUP BY bathrooms 

--UPDATING IT--


ALTER TABLE [San Diego 2]
ALTER COLUMN bathrooms VARCHAR(10);


/* This SQL query updates the 'bathrooms' column in the '[San Diego 2]' table based on the values in the 'bathrooms_text' column. It sets the value of 
'bathrooms' to '0.5' for rows where the 'bathrooms_text' column contains 'Shared half-bath' or 'Half-bath'. For other rows, it extracts the numeric 
portion before the word 'bath' with a space and updates the 'bathrooms' column accordingly. The update is applied only to those rows where 
the 'bathrooms' column is NULL and the 'bathrooms_text' column contains the word 'bath'. */ 


UPDATE [San Diego 2]
SET bathrooms = 
    CASE 
        WHEN bathrooms_text LIKE 'Shared half-bath' OR bathrooms_text LIKE 'Half-bath' THEN '0.5'
        WHEN CHARINDEX(' bath', bathrooms_text) > 0 THEN LEFT(bathrooms_text, CHARINDEX(' bath', bathrooms_text) - 1)
        WHEN CHARINDEX('bath', bathrooms_text) > 0 THEN LEFT(bathrooms_text, CHARINDEX('bath', bathrooms_text) - 1)
        ELSE NULL
    END
WHERE bathrooms_text LIKE '% bath%' AND bathrooms IS NULL;



/*I was having a problem updating "Shared half-bath" and 'Half-bath" so I did the following:*/

/*This SQL query updates the 'bathrooms' column in the '[San Diego 2]' table by setting the value to '0.5' 
for rows where the 'bathrooms_text' column has either 'Shared half-bath' or 'Half-bath' as its value. The 
update is applied only to those rows where the 'bathrooms' column is NULL. */


UPDATE [San Diego 2]
SET bathrooms = '0.5'
WHERE bathrooms_text IN ('Shared half-bath', 'Half-bath') AND bathrooms IS NULL;


/*This code is deleting the data with NULL values in the 'bathrooms' column*/

DELETE FROM [San Diego 2]
WHERE bathrooms IS NULL;


---FIXING/CHECKING PROPERTY TYPE---

--NO NULLS--
SELECT * FROM [San Diego 2]
WHERE property_type IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT property_type
FROM [San Diego 2]
ORDER BY property_type ASC;


---FIXING/CHECKING ROOM TYPE---

--NO NULLS--
SELECT * FROM [San Diego 2]
WHERE room_type IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT room_type
FROM [San Diego 2]
ORDER BY room_type ASC;


---FIXING/CHECKING PRICE---

--NO NULLS--
SELECT * FROM [San Diego 2]
WHERE price IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT price
FROM [San Diego 2]
ORDER BY price ASC;


---FIXING/CHECKING MIN & MAX NIGHTS---

--NO NULLS--
SELECT * FROM [San Diego 2]
WHERE minimum_nights IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT minimum_nights
FROM [San Diego 2]
ORDER BY minimum_nights ASC;

--NO NULLS--
SELECT * FROM [San Diego 2]
WHERE maximum_nights IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT maximum_nights
FROM [San Diego 2]
ORDER BY maximum_nights ASC;


---FIXING/CHECKING BEDROOMS---

--YES NULLS--
SELECT * FROM [San Diego 2]
WHERE bedrooms IS NULL 

--NO SIMILAR DATA--
SELECT DISTINCT bedrooms
FROM [San Diego 2]
ORDER BY bedrooms ASC;

--HOW MANY ROOMS OF EACH TYPE DO WE HAVE--

SELECT bedrooms, COUNT(*) FROM [San Diego 2]
GROUP BY bedrooms 
ORDER BY bedrooms ASC;


--SELECT DIFFERENT PROPERTY TYPES--
/*I checked the 'property_type' column to see what type of properties didn't have bedrooms*/


SELECT DISTINCT property_type FROM [San Diego 2]
WHERE bedrooms IS NULL
ORDER BY property_type ASC;

SELECT DISTINCT * FROM [San Diego 2]
WHERE bedrooms IS NULL 
ORDER BY property_type ASC;


----UPDATING MISSING BEDROOM DATA----
/*I'll update all "PRIVATE ROOMS" and "ROOM IN.." to "1 BEDROOM" and "Entire...", "Tiny home", 
"Camper/RV". "Barn" and "Earthen home" with NULL data to "0 BEDROOM" because they are studios*/


UPDATE [San Diego 2]
SET bedrooms = 
    CASE 
        WHEN property_type LIKE 'Private room in%' OR property_type LIKE 'Room in%' THEN '1'
        WHEN property_type LIKE 'Entire%' OR property_type LIKE 'Tiny home%' OR property_type LIKE 'Camper/RV%' 
        OR property_type LIKE 'Barn' OR property_type LIKE 'Earthen home' THEN '0'
        ELSE NULL
    END
WHERE bedrooms IS NULL;


/*I'll delete the following listings because they're not longer in Airbnb*/


DELETE FROM [San Diego 2]
WHERE bedrooms IS NULL;


----FIXING/CHECKING BEDS----


--YES NULLS--
SELECT * FROM [San Diego 2]
WHERE beds IS NULL

--NO SIMILAR DATA--
SELECT DISTINCT bedrooms
FROM [San Diego 2]
ORDER BY bedrooms ASC;

--SELECT DIFFERENT ROOM TYPES--
SELECT *  FROM [San Diego 2]
WHERE beds IS NULL 
ORDER BY bedrooms ASC;

SELECT DISTINCT * FROM [San Diego 2]
WHERE beds IS NULL 
ORDER BY room_type ASC;


----UPDATING MISSING BEDS DATA----
/*This code estimates the number of beds for rows with missing data based on the average beds per bedroom and accommodated people, ensuring 
that the calculated beds don't exceed the number of people accommodated. It then updates the "Beds" column with the estimated values.*/

--Step 1 and 2: Calculate the average number of beds per bedroom and the average number of people that can be accommodated per bedroom--
DECLARE @AvgBedsPerBedroom FLOAT;
DECLARE @AvgPeoplePerBedroom FLOAT;

SELECT
    @AvgBedsPerBedroom = AVG(CAST(Beds AS FLOAT) / NULLIF(bedrooms, 0)),
    @AvgPeoplePerBedroom = AVG(CAST(accommodates AS FLOAT) / NULLIF(bedrooms, 0))
FROM [San Diego 2]
WHERE Beds IS NOT NULL AND bedrooms > 0;

--Step 3-5: Update the "Beds" column using the calculated averages and logic--
UPDATE [San Diego 2]
SET Beds = 
    CASE
        WHEN bedrooms > 0 THEN
            CEILING(
                CASE
                    WHEN bedrooms * @AvgBedsPerBedroom < accommodates THEN bedrooms * @AvgBedsPerBedroom
                    ELSE accommodates
                END
            )
        ELSE
            CEILING(
                CASE
                    WHEN accommodates / @AvgPeoplePerBedroom < accommodates THEN accommodates / @AvgPeoplePerBedroom
                    ELSE accommodates
                END
            )
    END
WHERE Beds IS NULL;


----FIXING/CHECKING RAITING----

--NO NULLS IN number_of_reviews--
SELECT * FROM [San Diego 2]
WHERE number_of_reviews IS NULL

--NO NULLS IN review_scores_rating--
SELECT * FROM [San Diego 2]
WHERE review_scores_rating IS NULL
AND first_review IS NULL

/*I'll have to delete the following data because the listings doesn't have a review yet and we won't be able to 
calculate our final results with these data*/

DELETE FROM [San Diego 2]
WHERE review_scores_rating IS NULL
AND first_review IS NULL

---CHECKING DATA---

SELECT * FROM [San Diego 2]
WHERE review_scores_rating > 4.8

/*Everything looks fine*/
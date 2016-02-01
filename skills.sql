-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.

select * from brands;

-- 2. Select all columns for all car models made by Pontiac in the Models table.

select * from models where brand_name = 'Pontiac';

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.
select brand_name, name from models where year = 1964;

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.

SELECT models.name, brand_name, headquarters FROM models
JOIN brands ON (models.brand_name = brands.name)
WHERE models.name = 'Mustang';

-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).

SELECT * FROM brands 
Order By founded 
LIMIT  3;

-- 6. Count the Ford models in the database (output should be a number).
select count(*) from models WHERE brand_name = 'Ford' GROUP BY brand_name;

-- 7. Select the name of any and all car brands that are not discontinued.

select name FROM brands WHERE discontinued IS NULL;

-- 8. Select rows 15-25 of the DB in alphabetical order by model name.

select * from models ORDER BY name LIMIT 10 OFFSET 15;
-- this gives inconsistent results; for better results, order by name and model year as follows:
select * from models ORDER BY name, year LIMIT 10 OFFSET 15;

-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)

SELECT models.brand_name, models.name, brands.founded FROM models
LEFT JOIN brands ON (models.brand_name = brands.name)
WHERE models.year = 1960;

-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Model AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued IS NULL;

select b.name, b.founded, m.name FROM models as m                        
LEFT JOIN brands as b ON (m.brand_name = b.name)                                
WHERE b.discontinued IS NULL;

-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;

SELECT m.name, m.brand_name, b.founded FROM models as m                  
INNER JOIN brands AS b                                                          
ON (b.name = m.brand_name);

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.

--LEFT JOINS select all columns from the left hand table that match query parameters, 
-- then find matching info from the right table to add to it. This can produce nulls
-- where the right table doesn't have matching data.
-- INNER JOINS only return records where there is data from both tables; 
-- this does not produce any NEW nulls, though nulls from either table's records might be included. 



-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;

select brands.name, founded FROM brands
left join models On brands.name = models.brand_name WHERE models.name IS NULL;

-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;

select b.name, m.name, m.year, b.discontinued, (b.discontinued - m.year) AS years_until_brand_discontinued 
FROM models as m                              
LEFT JOIN brands as b                                                           
ON m.brand_name = b.name                                                        
WHERE b.discontinued IS NOT NULL;


-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.

select brand_name FROM models GROUP BY brand_name HAVING count(brand_name)  > 5;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

INSERT INTO models (year, name, brand_name) VALUES (2015, 'Chevrolet', 'Malibu');
INSERT INTO models (year, name, brand_name) VALUES (2015, 'Subaru', 'Outback');

-- 2 lines above insert data as requested; however the request is flipped.
-- Elsewhere in the table, name = name of model (Malibu, Outback) and brand_name should contain Chevrolet, Subaru
-- In order to keep this data consistent with other table data, statements should have read:
INSERT INTO models (year, name, brand_name) VALUES (2015, 'Malibu', 'Chevrolet');
INSERT INTO models (year, name, brand_name) VALUES (2015, 'Outback', 'Subaru');


-- 3. Write a SQL statement to crate a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).

CREATE TABLE Awards (name VARCHAR(100) NOT NULL, year INTEGER NOT NULL, winner VARCHAR (50);

-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback

ALTER TABLE awards ADD COLUMN winner_model_id INTEGER;
INSERT INTO awards (name, year, winner_model_id) 
VALUES ('IIHS Safety Award', 2015, 
    (SELECT id FROM models WHERE brand_name = 'Malibu' AND name = 'Chevrolet')),
    ('IIHS Safety Award', 2015, 
    (SELECT id FROM models WHERE brand_name = 'Outback' AND name = 'Subaru'));


-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.

SELECT name FROM models WHERE year IN (SELECT DISTINCT founded FROM brands);




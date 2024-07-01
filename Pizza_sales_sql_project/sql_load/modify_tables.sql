/*
1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy orders_dim FROM '[Insert File Path]/orders_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy pizza_types_dim FROM '[Insert File Path]/pizza_types_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'windows-1252');

\copy pizzas_dim FROM '[Insert File Path]/pizzas_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy order_details_dim FROM '[Insert File Path]/order_details_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
*/
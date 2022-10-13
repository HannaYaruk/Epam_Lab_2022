import mysql.connector
import sys
import boto3
import os

ENDPOINT="dilab-mysql.*.eu-central-1.rds.amazonaws.com"
PORT="3306"
USER="hanna_yaruk"
PASSWD="hanna_yaruk_pass"
REGION="eu-central-1"
DBNAME="hanna_yaruk_schema"
os.environ['LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN'] = '1'

#gets the credentials from .aws/credentials
session = boto3.Session(profile_name='default')
client = session.client('rds')

#token = client.generate_db_auth_token(DBHostname=ENDPOINT, Port=PORT, DBUsername=USER, Region=REGION)

try:
    conn =  mysql.connector.connect(host=ENDPOINT, user=USER, passwd=PASSWD, port=PORT, database=DBNAME, ssl_ca='SSLCERTIFICATE')
    cur = conn.cursor()
    cur.execute("""SELECT now()""")
    query_results = cur.fetchall()
    print(query_results)
except Exception as e:
    print("Database connection failed due to {}".format(e))

#create tables for the database
create_products_query = """
CREATE TABLE IF NOT EXISTS products(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(100),
    price INT
);
"""

#truncate table before inserting new data
truncate_products_query = """
Truncate table products;
"""

#insert data into the table
insert_products_query = """
INSERT INTO products (id, title, category, price)
VALUES
    (1, "Cucumber", "Vegetables", 8),
    (2, "Tomato", "Vegetables", 11),
    (3, "Banana", "Fruit", 6),
    (4, "Strawberry", "Berry", 30),
    (5, "Apple", "Fruit", 3),
    (6, "Avocado", "Fruit", 13);
"""

#create view
create_view_products_query = """
CREATE OR REPLACE VIEW products_view as
SELECT id, title, price
FROM products
"""

drop_procedure_query = """
DROP PROCEDURE IF EXISTS prod_list;
"""

#create procedure for counting products of a category
create_procedure_query = """
CREATE PROCEDURE prod_list (category_insert varchar(64))
BEGIN
   SELECT COUNT(*) FROM products
   WHERE products.category = category_insert;
END;
"""
with conn.cursor() as cursor:
    cursor.execute(create_products_query)
    cursor.execute(truncate_products_query)
    cursor.execute(insert_products_query)
    cursor.execute(create_view_products_query)
    cursor.execute(drop_procedure_query)
    cursor.execute(create_procedure_query)
    conn.commit()

-- CREACION DE TABLAS DE NUEVO

CREATE TABLE credit_card (
    id VARCHAR(20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(34),
    pan VARCHAR(20),
    pin INT,
    cvv INT,
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date DATE
);

CREATE TABLE user (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(150),
    birth_date VARCHAR(10),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255)
);

CREATE TABLE company (
    company_id VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(150),
    phone VARCHAR(50),
    email VARCHAR(150),
    country VARCHAR(100),
    website VARCHAR(255)
);

ALTER TABLE credit_card
ADD CONSTRAINT fk_creditcard_user
FOREIGN KEY (user_id) REFERENCES user(id);


CREATE TABLE transaction (
    id CHAR(36) PRIMARY KEY,
    card_id VARCHAR(10),
    business_id VARCHAR(10),
    timestamp VARCHAR(10),
    amount DECIMAL(10,2),
    declined BOOLEAN,
    product_ids TEXT,
    user_id INT,
    lat DOUBLE,
    longitude DOUBLE,
    
    FOREIGN KEY (card_id) REFERENCES credit_card(id),
    FOREIGN KEY (business_id) REFERENCES company(company_id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

ALTER TABLE user
MODIFY COLUMN birth_date VARCHAR(30);

-- flags para poder importar por consola mysql ya que me iba muy lento con el wizzard del Workbench
SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';



-- NIVELL 1
-- ECERCICI 1


SELECT u.*
FROM user u
WHERE u.id IN (
    SELECT t.user_id
    FROM transaction t
    GROUP BY t.user_id
    HAVING COUNT(*) > 80
);


-- ECERICICI 2

SELECT 
    cc.iban,
    AVG(t.amount) AS average_amount
FROM 
    transaction t
JOIN 
    credit_card cc ON t.card_id = cc.id
JOIN 
    company c ON t.business_id = c.company_id
WHERE 
    c.company_name = 'Donec Ltd'
GROUP BY 
    cc.iban;


-- NIVELL 2
-- EXERCICI 1

CREATE TABLE credit_card_status (
    card_id VARCHAR(50) PRIMARY KEY,
    last_three_declined BOOLEAN NOT NULL
);

-- METEMOS TODAS LAS TARGETAS

INSERT INTO credit_card_status (card_id, last_three_declined)
SELECT DISTINCT id, FALSE
FROM credit_card
ON DUPLICATE KEY UPDATE last_three_declined = FALSE;

-- MODIFICAMOS EL BOOLEANO SEGUN LAS 3 ULTIMAS TRANSACCIONES:

WITH ultimas_transacciones AS (
    SELECT
        t.card_id,
        t.declined,
        ROW_NUMBER() OVER (PARTITION BY t.card_id ORDER BY t.timestamp DESC) AS rn
    FROM transaction t
),
filtradas AS (
    SELECT card_id
    FROM ultimas_transacciones
    WHERE rn <= 3
    GROUP BY card_id
    HAVING SUM(declined) = 3
)
UPDATE credit_card_status
JOIN filtradas USING (card_id)
SET last_three_declined = TRUE;

-- NIVELL3
-- EXERCICI 1



CREATE TABLE product (
    id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2),
    colour VARCHAR(20),
    weight DECIMAL(10, 2),
    warehouse_id VARCHAR(20)
);
ALTER TABLE product MODIFY price VARCHAR(20);

-- CREAMOS TABLA INTERMEDIA

CREATE TABLE transaction_product (
    transaction_id VARCHAR(50),  -- o el tipo que sea id en transaction
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);



-- RELLENAMOS LA TABLA INTERMEDIA A PARTIR DE TRANSACTION
INSERT INTO transaction_product (transaction_id, product_id)
SELECT
    t.id,
    CAST(TRIM(j.value) AS UNSIGNED) AS product_id
FROM
    transaction t,
    JSON_TABLE(
        CONCAT('[', REPLACE(t.product_ids, ',', ','), ']'),
        "$[*]" COLUMNS(value VARCHAR(10) PATH "$")
    ) j;

-- BUSCAMOS EN LA TABLA INTERMEDIA 

SELECT 
    product_id, 
    COUNT(*) AS nombre_vendes
FROM transaction_product
GROUP BY product_id
ORDER BY nombre_vendes DESC;


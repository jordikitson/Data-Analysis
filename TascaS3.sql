-- NIVELL 1
-- EXERCICI 1

CREATE TABLE credit_card (
  id VARCHAR(20) PRIMARY KEY,
  iban VARCHAR(34) NOT NULL UNIQUE,
  pan VARCHAR(19) NOT NULL UNIQUE,
  pin CHAR(4) NOT NULL,
  cvv CHAR(3) NOT NULL,
  expiring_date DATE NOT NULL
);

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(8);

-- INTRODUCIMOS EL DATA DE datos_introducir_sprint3_credit

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

-- EXERCICI 2

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';

-- EXERCICI 3

INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date)
VALUES ('CcU-9999', 'DUMMY_IBAN', '0000000000000000', '0000', '000', '2025-12-31');

INSERT INTO transaction (
  id, credit_card_id, company_id, user_id, lat, longitude, amount, declined, timestamp
)
VALUES (
  '108B1D1D-5B23-A76C-55EF-C568E49A99DD',
  'CcU-9999',
  'b-9999',
  9999,
  829.999,
  -117.999,
  111.11,
  0,
  NOW()
);

-- EXERCICI 4

ALTER TABLE credit_card
DROP COLUMN pan;


-- NIVELL 2
-- EXERCICI 1

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT * FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- EXERCICI 2


CREATE OR REPLACE VIEW VistaMarketing AS
SELECT 
    c.company_name AS nom_empresa,
    c.phone AS telefon,
    c.country AS pais,
    ROUND(AVG(t.amount), 2) AS mitjana_compra
FROM 
    company c
JOIN 
    transaction t ON c.id = t.company_id
GROUP BY 
    c.id, c.company_name, c.phone, c.country
ORDER BY 
    mitjana_compra DESC;


SELECT * FROM VistaMarketing;


-- EXERCICI 3

SELECT *
FROM VistaMarketing
WHERE pais = 'Germany';


-- NIVELL 3
-- EXERCICI 1



ALTER TABLE transaction
MODIFY COLUMN user_id CHAR(10);


ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id) REFERENCES user(id);



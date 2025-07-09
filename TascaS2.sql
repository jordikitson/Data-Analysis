-- NIVELL 1: 
-- Exercici 2

SELECT DISTINCT c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;

SELECT COUNT(DISTINCT c.country)
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE;

SELECT c.company_name, AVG(t.amount) AS mitjana_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.declined = FALSE
GROUP BY c.company_name
ORDER BY mitjana_vendes DESC


-- Exercici 3


SELECT * FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = 'Germany'
);

SELECT *
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (
        SELECT AVG(amount)
        FROM transaction
        WHERE declined = FALSE
    )
);

SELECT *
FROM company
WHERE id NOT IN (
    SELECT DISTINCT company_id
    FROM transaction
);

-- NIVELL 2
-- Exercici 1

SELECT 
    DATE(timestamp) AS data,
    SUM(amount) AS total_vendes
FROM transaction
WHERE declined = FALSE
GROUP BY DATE(timestamp)
ORDER BY total_vendes DESC
LIMIT 5;

-- Exercici 2

SELECT 
	c.country AS count,
	AVG(t.amount) AS total
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY count
ORDER BY total DESC

-- Exercici 3

SELECT t.*
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = (
    SELECT country
    FROM company
    WHERE company_name = 'Non Institute'
    LIMIT 1
);

SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = (
        SELECT country
        FROM company
        WHERE company_name = 'Non Institute'
        LIMIT 1
    )
);

-- Nivell 3

-- EXERCICI 1


SELECT 
    c.company_name AS nom,
    c.phone AS telefon,
    c.country AS pais,
    t.timestamp AS data,
    t.amount
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.amount BETWEEN 350 AND 400
  AND DATE(t.timestamp) IN (
      '2015-04-29',
      '2018-07-20',
      '2024-03-13'
  )
ORDER BY t.amount DESC;




-- EXERCICI 2


SELECT 
    c.company_name,
    COUNT(t.id) AS num_transaccions,
    CASE 
        WHEN COUNT(t.id) > 400 THEN 'Més de 400'
        ELSE 'Menys o igual a 400'
    END AS classificacio
FROM company c
LEFT JOIN transaction t ON c.id = t.company_id
GROUP BY c.id, c.company_name
ORDER BY num_transaccions DESC;


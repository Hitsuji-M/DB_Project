-- Clear all the database rows
DELETE FROM TypeEncombrement;
DELETE FROM TypeStationnementImpacte;
DELETE FROM MOA;
DELETE FROM Chantier;
DELETE FROM Localisation; 
DELETE FROM Encombrement;
DELETE FROM NatureChantier; 
DELETE FROM Entite;
DELETE FROM ImpactStationnement;

-- Selects all possible parking impacts
SELECT TypeStationnement FROM ImpactStationnement;

-- Selects all project owners (MOA)
SELECT DISTINCT NomEntite FROM Entite e INNER JOIN MOA m ON e.IdEntite = m.IdEntite_MOA;

-- Select all project managers (MOE)
SELECT DISTINCT NomEntite FROM Entite e INNER JOIN Chantier c ON e.IdEntite = c.IdEntite_MOE;

-- Number of projects undertaken by the "Ville de Paris" entity
SELECT DISTINCT NomEntite, COUNT(c.IdChantier) AS "Nombre de chantiers"
FROM Entite e INNER JOIN Chantier c ON e.IdEntite = c.IdEntite_MOE
WHERE UPPER(NomEntite) LIKE 'VILLE DE PARIS%';

-- Selects the site number + area + coordinates + dates of all the sites of +100m^2 and that have no impact on parking
SELECT  c.idChantier AS "Num chantier", e.NomEntite, Surface, IdDate_debut AS "Date début", IdDate_fin AS "Date Fin", Latitude, Longitude
FROM Chantier c INNER JOIN Localisation l ON c.IdLocalisation = l.IdLocalisation
                LEFT JOIN TypeStationnementImpacte tsi ON c.IdChantier = tsi.IdChantier
                INNER JOIN MOA m ON c.IdChantier = m.IdChantier
                INNER JOIN Entite e ON m.IdEntite_MOA = e.IdEntite
WHERE tsi.IdChantier IS NULL AND Surface > 100 AND Longitude > 0 AND Latitude > 0
ORDER BY Surface
LIMIT 25;

-- Requetes pour vider les données de la base
DELETE FROM TypeEncombrement;
DELETE FROM TypeStationnementImpacte;
DELETE FROM MOA;
DELETE FROM Chantier;
DELETE FROM Localisation; 
DELETE FROM Encombrement;
DELETE FROM NatureChantier; 
DELETE FROM Entite;
DELETE FROM ImpactStationnement;

-- Selectionne tous les impacts sur stationnement possibles
SELECT TypeEncombrement FROM ImpactStationnement;

-- Sélectionne tous les MOA
SELECT DISTINCT NomEntite FROM Entite e INNER JOIN MOA m ON e.IdEntite = m.IdEntite_MOA;

-- Selectionne tous les MOE
SELECT DISTINCT NomEntite FROM Entite e INNER JOIN Chantier c ON e.IdEntite = c.IdEntite_MOE;

-- Nombre de chantiers entrepris par l'entité "Ville de Paris"
SELECT DISTINCT NomEntite, COUNT(c.IdChantier) AS "Nombre de chantiers"
FROM Entite e INNER JOIN Chantier c ON e.IdEntite = c.IdEntite_MOE
WHERE UPPER(NomEntite) LIKE 'VILLE DE PARIS%';

-- Sélectionne le numéro de chantier + superficie + coordonnées + dates de tous les chantiers de +50m^2
SELECT idChantier AS "Num chantier", Surface, IdDate_debut, IdDate_fin, latitude, longitude
FROM Chantier c INNER JOIN Localisation l ON c.IdLocalisation = l.IdLocalisation
WHERE Surface > 100
ORDER BY Surface
LIMIT 25;

-- Selectionne tous les MOE ayant causé le plus d'encombrements et d'impacts sur le stationnement dans l'ordre décroissant
SELECT NomEntite, COUNT(te.IdEncombrement) AS "Nb Encombrements", COUNT(tsi.IdStationnementImpact) AS "Nb Impact sur stationnement"
FROM Entite e INNER JOIN Chantier c ON e.IdEntite = c.IdEntite_MOE
              INNER JOIN TypeEncombrement te ON c.IdChantier = te.IdChantier
              INNER JOIN TypeStationnementImpacte tsi ON c.IdChantier = tsi.IdChantier
GROUP BY e.NomEntite
ORDER BY 2 DESC,
         3 DESC;
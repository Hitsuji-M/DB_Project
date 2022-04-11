CREATE TABLE NatureChantier(
   IdNatureChantier COUNTER,
   Nature VARCHAR(50),
   PRIMARY KEY(IdNatureChantier)
);

CREATE TABLE Encombrement(
   IdEncombrement COUNTER,
   TypeEncombrement VARCHAR(50),
   PRIMARY KEY(IdEncombrement)
);

CREATE TABLE ImpactStationnement(
   IdStationnementImpact COUNTER,
   TypeEncombrement VARCHAR(50),
   PRIMARY KEY(IdStationnementImpact)
);

CREATE TABLE NatureEntite(
   IdNatureEntite COUNTER,
   LibelleNatureEntite VARCHAR(50) NOT NULL,
   PRIMARY KEY(IdNatureEntite)
);

CREATE TABLE Localisation(
   IdLocalisation COUNTER,
   Longitute DECIMAL(17,15),
   Latitude DECIMAL(17,15),
   PRIMARY KEY(IdLocalisation)
);

CREATE TABLE Entite(
   IdEntite COUNTER,
   NomEntite VARCHAR(50) NOT NULL,
   IdNatureEntite INT NOT NULL,
   PRIMARY KEY(IdEntite),
   FOREIGN KEY(IdNatureEntite) REFERENCES NatureEntite(IdNatureEntite)
);

CREATE TABLE Chantier(
   IdChantier VARCHAR(8),
   Surface DECIMAL(10,6),
   IdDate_fin DATE NOT NULL,
   IdDate_debut DATE NOT NULL,
   IdLocalisation INT NOT NULL,
   IdNatureChantier INT NOT NULL,
   IdEntite_MOE INT NOT NULL,
   PRIMARY KEY(IdChantier),
   FOREIGN KEY(IdLocalisation) REFERENCES Localisation(IdLocalisation),
   FOREIGN KEY(IdNatureChantier) REFERENCES NatureChantier(IdNatureChantier),
   FOREIGN KEY(IdEntite_MOE) REFERENCES Entite(IdEntite)
);

CREATE TABLE MOA(
   IdChantier VARCHAR(8),
   IdEntite_MOA INT,
   PRIMARY KEY(IdChantier, IdEntite_MOA),
   FOREIGN KEY(IdChantier) REFERENCES Chantier(IdChantier),
   FOREIGN KEY(IdEntite_MOA) REFERENCES Entite(IdEntite)
);

CREATE TABLE TypeEncombrement(
   IdChantier VARCHAR(8),
   IdEncombrement INT,
   PRIMARY KEY(IdChantier, IdEncombrement),
   FOREIGN KEY(IdChantier) REFERENCES Chantier(IdChantier),
   FOREIGN KEY(IdEncombrement) REFERENCES Encombrement(IdEncombrement)
);

CREATE TABLE TypeStationnementImpacte(
   IdChantier VARCHAR(8),
   IdStationnementImpact INT,
   PRIMARY KEY(IdChantier, IdStationnementImpact),
   FOREIGN KEY(IdChantier) REFERENCES Chantier(IdChantier),
   FOREIGN KEY(IdStationnementImpact) REFERENCES ImpactStationnement(IdStationnementImpact)
);

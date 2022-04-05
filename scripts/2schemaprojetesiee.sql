CREATE TABLE IF NOT EXISTS Naturechantier
(
    IdNaturechantier INT AUTO_INCREMENT,
    Nature           VARCHAR(50),
    PRIMARY KEY (IdNaturechantier)
);

CREATE TABLE IF NOT EXISTS Encombrement
(
    IdEncombrement   INT AUTO_INCREMENT,
    Typeencombrement VARCHAR(50),
    PRIMARY KEY (IdEncombrement)
);

CREATE TABLE IF NOT EXISTS ImpactStationnement
(
    Idstationnementimpacte INT AUTO_INCREMENT,
    Typestationnement      VARCHAR(50),
    PRIMARY KEY (Idstationnementimpacte)
);

CREATE TABLE IF NOT EXISTS NatureEntite
(
    IDnatureEntite      INT AUTO_INCREMENT,
    libellenatureEntite VARCHAR(50),
    PRIMARY KEY (IDnatureEntite)
);

CREATE TABLE IF NOT EXISTS Localisation
(
    idlocalisation INT AUTO_INCREMENT,
    longitute      DECIMAL(17,15),
    lattitude      DECIMAL(17,15),
    PRIMARY KEY (idlocalisation)
);

CREATE TABLE IF NOT EXISTS Entite
(
    IdEntite       INT AUTO_INCREMENT,
    NomEntite      VARCHAR(50),
    IdNatureEntite INT NOT NULL,
    PRIMARY KEY (IdEntite),
    FOREIGN KEY (IDNatureEntite) REFERENCES NatureEntite (idNatureEntite)
        ON DELETE cascade
        ON UPDATE cascade
);

CREATE TABLE IF NOT EXISTS Chantier
(
    IdChantier       varchar(8),
    Surface          INT,
    idDatefin        DATE NOT NULL,
    idDatedebut      DATE NOT NULL,
    idlocalisation   INT NOT NULL,
    IdNaturechantier INT NOT NULL,
    IdEntite         INT NOT NULL,
    PRIMARY KEY (IdChantier),
    UNIQUE (IdEntite),
    FOREIGN KEY (idlocalisation) REFERENCES Localisation (idlocalisation)
        ON DELETE cascade
        ON UPDATE cascade,
    FOREIGN KEY (IdNaturechantier) REFERENCES Naturechantier (IdNaturechantier)
        ON DELETE cascade
        ON UPDATE cascade,
    FOREIGN KEY (IdEntite) REFERENCES Entite (IdEntite)
        ON DELETE cascade
        ON UPDATE cascade
);

CREATE TABLE IF NOT EXISTS MOA
(
    IdChantier varchar(8),
    IdEntite   INT,
    PRIMARY KEY (IdChantier, IdEntite),
    FOREIGN KEY (IdChantier) REFERENCES Chantier (IdChantier)
        ON DELETE cascade
        ON UPDATE cascade,
    FOREIGN KEY (IdEntite) REFERENCES Entite (IdEntite)
        ON DELETE cascade
        ON UPDATE cascade

);

CREATE TABLE IF NOT EXISTS typedencombrement
(
    IdChantier     varchar(8),
    IdEncombrement INT,
    PRIMARY KEY (IdChantier, IdEncombrement),
    FOREIGN KEY (IdChantier) REFERENCES Chantier (IdChantier)
        ON DELETE cascade
        ON UPDATE cascade,
    FOREIGN KEY (IdEncombrement) REFERENCES Encombrement (IdEncombrement)
        ON DELETE cascade
        ON UPDATE cascade
);

CREATE TABLE IF NOT EXISTS typedestationnementimpacte
(
    IdChantier             varchar(8),
    Idstationnementimpacte INT,
    PRIMARY KEY (IdChantier, Idstationnementimpacte),
    FOREIGN KEY (IdChantier) REFERENCES Chantier (IdChantier)
        ON DELETE cascade
        ON UPDATE cascade,
    FOREIGN KEY (Idstationnementimpacte) REFERENCES ImpactStationnement (Idstationnementimpacte)
        ON DELETE cascade
        ON UPDATE cascade
);

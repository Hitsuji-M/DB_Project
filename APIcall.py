import mariadb
from mariadb import Error as OMGCAMARCHEPAS

import json
import requests
import os
import sys

URL = "https://opendata.paris.fr/api/records/1.0/search/?dataset=chantiers-a-paris&q=&rows=6232&start=0&facet" \
      "=date_debut&facet=date_fin&facet=chantier_categorie&facet=moa_principal&facet=chantier_synthese&facet" \
      "=localisation_detail&facet=localisation_stationnement&facet=surface&facet=geo_point_2d"

class DatabaseHandler:
    def __init__(self, needUpdate=False, show=False):
        file = "error"
        if needUpdate or not os.path.isfile('json_data.json'):
            self.update()
        with open('json_data.json') as json_file:
            file = json.load(json_file)
        if show:
            print(json.dumps(file, indent=4, sort_keys=True))

        try:
            cnx = mariadb.connect(
                user="root",
                password="root",
                host="127.0.0.1",
                port=3306,
                database="IGI-3014-TD9t-GP5"
            )

        except OMGCAMARCHEPAS as e:
            print(f"Error connecting to MariaDB Platform: {e}")
            sys.exit(1)

        self.file = file
        self.cnx = cnx
        self.cur = cnx.cursor()
        self.insertFacets()
        self.insertRecords()

    def update(self) -> None:
        res = requests.get(URL)

        if res.status_code < 200 or res.status_code >= 300:
            print("mauvaise réponse : ", res.status_code)
            sys.exit(1)
            
        print("Requête réalisée avec succès !")
        jsondata = res.json()

        with open('json_data.json', 'w') as outfile:
            json.dump(jsondata, outfile)

        print("Mise à jour finie !")

    def insertFacets(self) -> None:
        moe = self.file["facet_groups"][2]["facets"]
        moa = self.file["facet_groups"][3]["facets"]
        synthese = self.file["facet_groups"][4]["facets"]
        detail = self.file["facet_groups"][5]["facets"]
        impact = self.file["facet_groups"][6]["facets"]   
        
        for facetMOE in moe:
            value = facetMOE["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO Entite VALUES(NULL, '{value}');")
        for facetMOA in moa:
            value = facetMOA["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO Entite VALUES(NULL, '{value}');")
        for facetSyn in synthese:
            value = facetSyn["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO NatureChantier VALUES(NULL, '{value}');")
        for facetDet in detail:
            value = facetDet["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO Encombrement VALUES(NULL, '{value}');")
        for facetImp in impact:
            value = facetImp["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO ImpactStationnement VALUES(NULL, '{value}');")
        self.cnx.commit()

    def insertRecords(self) -> None:
        records = self.file["records"]
        for recordID, record in enumerate(records):
            latitude = record["geometry"]["coordinates"][0]
            longitude = record["geometry"]["coordinates"][1]
            self.cur.execute(f"INSERT INTO Localisation VALUES({recordID}, {longitude}, {latitude});")
            self.cnx.commit()

            fields = record["fields"]
            num = fields["num_emprise"]
            surface = fields["surface"]
            debut, fin = fields["date_debut"], fields["date_fin"]
            chantier = fields["chantier_synthese"].replace("'", "\\'")
            moe = fields["chantier_categorie"].replace("'", "\\'")
            moa = fields["moa_principal"].replace("'", "\\'")
            detail = fields["localisation_detail"].replace("'", "\\'")
            station = fields["localisation_stationnement"].replace("'", "\\'")
        
            self.cur.execute(f"SELECT idLocalisation FROM Localisation WHERE 'Longitude' = {longitude} AND Latitude = {latitude};")
            idLoc = self.cur.fetchone()[0]
            self.cur.execute(f"SELECT idNatureChantier FROM NatureChantier WHERE Nature = {chantier};")
            idNC = self.cur.fetchone()[0]
            self.cur.execute(f"SELECT idEntite FROM Entite WHERE NomEntite = {moe};")
            idMOE = self.cur.fetchone()[0]
            self.cur.execute(f"SELECT idEntite FROM Entite WHERE NomEntite = {moa};")
            idMOA = self.cur.fetchone()[0]
            self.cur.execute(f"SELECT idEncombrement FROM Encombrement WHERE TypeEncombrement = {detail};")
            idEnc = self.cur.fetchone()[0]
            self.cur.execute(f"SELECT idStationnementImpact FROM ImpactStationnement WHERE TypeEncombrement = {station};")
            idIS = self.cur.fetchone()[0]

            self.cur.execute(f"INSERT INTO Chantier VALUES('{num}', {surface}, {debut}, {fin}, {idLoc}, {idNC}, {idMOE});")
            self.cur.execute(f"INSERT INTO MOA VALUES('{num}', {idMOA});")
            self.cur.execute(f"INSERT INTO TypeEncombrement VALUES('{num}', {idEnc});")
            self.cur.execute(f"INSERT INTO TypeStationnementImpacte VALUES('{num}', {idIS});")
            self.cnx.commit()

if __name__ == '__main__':
    DatabaseHandler()

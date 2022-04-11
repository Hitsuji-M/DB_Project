import mariadb

import json
import requests
import os
import sys

URL = "https://opendata.paris.fr/api/records/1.0/search/?dataset=chantiers-a-paris&q=&rows=6232&start=0&facet" \
      "=date_debut&facet=date_fin&facet=chantier_categorie&facet=moa_principal&facet=chantier_synthese&facet" \
      "=localisation_detail&facet=localisation_stationnement&facet=surface&facet=geo_point_2d"

class DatabaseHandler:
    def __init__(self, needUpdate=False,show=False):
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

        except mariadb.Error as e:
            print(f"Error connecting to MariaDB Platform: {e}")
            sys.exit(1)

        self.file = file
        self.cnx = cnx
        self.cur = cnx.cursor()
        self.insertFacets()

    def update(self) -> None:
        res = requests.get(URL)

        if res.status_code < 200 or res.status_code >= 300:
            print("mauvaise réponse : ", res.status_code)
            sys.exit(1)
            
        print("pull successful")
        jsondata = res.json()  # On prend le json de la réponse

        with open('json_data.json', 'w') as outfile:
            json.dump(jsondata, outfile)

        print("Update Done")

    def insertFacets(self) -> None:
        moe = self.file["facet_groups"][2]["facets"]
        moa = self.file["facet_groups"][3]["facets"]   
        tailleStop = len(moe)
        
        for i in range(tailleStop):
            name = moe[i]["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO Entite VALUES(NULL, '{name}');")
        for j in range(len(moa)):
            name = moa[j]["name"].replace("'", "\\'")
            self.cur.execute(f"INSERT INTO Entite VALUES(NULL, '{name}');")
        self.cnx.commit()

if __name__ == '__main__':
    DatabaseHandler()

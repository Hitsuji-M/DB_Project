import json

import requests
import os

URL = "https://opendata.paris.fr/api/records/1.0/search/?dataset=chantiers-a-paris&q=&rows=6232&start=0&facet" \
      "=date_debut&facet=date_fin&facet=chantier_categorie&facet=moa_principal&facet=chantier_synthese&facet" \
      "=localisation_detail&facet=localisation_stationnement&facet=surface&facet=geo_point_2d "


def update():
    res = requests.get(URL)

    if res.status_code < 200 or res.status_code >= 300:
        print("mauvaise réponse : ", res.status_code)
        return
    print("pull successful")
    jsondata = res.json()  # On prend le json de la réponse
    print(jsondata.keys())  # Toutes les clés json
    print(jsondata["parameters"]["rows"])  # Le nombre de lignes (donc de données extraites) du tableau

    with open('json_data.json', 'w') as outfile:
        json.dump(jsondata, outfile)

    print("Update Done")


def main(needupdate=False) -> None:
    file = "error"
    if needupdate or not os.path.isfile('json_data.json'):
        update()
    with open('json_data.json') as json_file:
        file = json.load(json_file)
    print(json.dumps(file, indent=4, sort_keys=True))


if __name__ == '__main__':
    main()

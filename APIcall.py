import requests

URL = "https://opendata.paris.fr/api/records/1.0/search/?dataset=chantiers-a-paris&q=&rows=6232&start=0&facet=date_debut&facet=date_fin&facet=chantier_categorie&facet=moa_principal&facet=chantier_synthese&facet=localisation_detail&facet=localisation_stationnement&facet=surface&facet=geo_point_2d"

def main() -> None:
    res = requests.get(URL)

    if res.status_code < 200 or res.status_code >= 300:
        print("mauvaise réponse : ", res.status_code)
        return

    file = res.json() # On prend le json de la réponse 
    print(file.keys()) # Toutes les clés json 
    print(file["parameters"]["rows"]) # Le nombre de lignes (donc de données extraites) du tableau

if __name__ == '__main__':
    main()
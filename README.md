<p align="center">
A simple data pull and json converter to fully functional database using docker, python and MariaDB<br>
[![Python][python_shield]][python_link] [![MariaDB][mariadb_shield]][mariadb_link]
</p>



# Database Project

Final project for the database unit during my first year in second-cycle degree (engineer degree at ESIEE Paris)

# What is this project ?
The goal of this project was to evaluate what we learned during this unit. We had to create a database (including datas) from open data sheets of the city Paris (check [here](https://opendata.paris.fr/pages/home/)).
<br>
Because we couldn't use scripts on our school's database, we decided to use docker so we could had an exact replication of the school environement and we could use our scripts, making the project funnier and more instructive.

# Requirements
## setup
Use the following commands to use this project :
- `git clone https://github.com/Hitsuji-M/DB_Project.git`
- `cd DB_Project`
- `pip3 install -r requirements.txt`

> The mariadb import may raise an error on Linux. To fix this run these two commands
- `sudo apt-get update -y`
- `sudo apt-get install -y libmariadb-dev`

**Before using the project, make sure you downloaded `docker-compose`**

## Launch
To start the project run the command `sudo docker-compose up`. When the docker is open to connections you can run the main file with `python3 APIcall.py`

### Parameters
The ̀APIcall.py` file has 2 parameters :
- `update` If tou want to pull a new json file from OpenData (and overwrite the old file).
-  `show` If you want to print the file content

# Contributors
This project was made by a group of 4 :
- Erwann "[Hitsuji](https://github.com/Hitsuji-M)" Masson (Developer)
- Loris "[ZEN](https://github.com/Lolozendev)" Pistilli (Developer)
- Franck "Francky" Jiang (Database designer) 
- Elie "Gyoza" Duboux (Databse designer)

<!-- badge links -->
[mariadb_shield]: https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white
[mariadb_link]: https://mariadb.org/

[python_shield]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[python_link]: https://www.python.org/

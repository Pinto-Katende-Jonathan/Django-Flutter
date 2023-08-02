# Backend pour une application pour étudiant
# ----------------------------------------------
## Le nom de l'application safari teke teke, 

<img src="screenshot.jpg" width="1080" height="640"/>

cette application est composée de deux parties:<br/>
    - Le backend ou le server<br/>
    - Le frontend ou le client

Le backend sert d'api simple pour une application développée en flutter

Le back a comme caractéristiquesq :
  - Donne la possibilté de se créer un compte comme :
      - client
      - chauffeur
      - Admin (uniquement par le superUser
  - Donne la possibilité de se connecter
      Le back détermine le rôle en fonction de l'enregistrement dans la bdd.
      Le front affiche les différentes fenêtres selon le rôle.
  
  - Si vous êtes chauffeur, vous pouvez :
    - créer une nouvelle publication
    - Supprimer votre propre publication
    - Editer votre propre publication

  - Si vous êtes client:
    - Vous ne pouvez voir que les publications que vous recherchez en spécifiant :<br/>
        - Le lieu de destination.<br/>
        - Le lieu de départ .<br/>
    - Vous pouvez chatter en socket avec le propriétaire de la publication
  

# Backend pour une application pour étudiant
# ----------------------------------------------
## Le nom de l'application safari teke teke, 

ce backend sert d'api pour une application développée en flutter

Ce back a comme caractéristique :
  - Donne la possibilté de se créer un compte comm
      - client
      - chauffeur
      - Admin (uniquement par le superUser
  - Donne la possibilité de se connecter
      Le back détermine le rôle en fonction de l'enregistrement dans la bdd.
      Le front affiche les différentes fenêtre selon le rôle.
  
  - Si vous êtes chauffeur, vous pouvez :
    - créer une nouvelle publication
    - Supprimer votre propre publication
    - Editer votre propre publication

  - Si vous êtes client:
    - Vous ne pouvez voir que les publications que vous recherchez en spécifiant :<br/>
        - Le lieu de destination.<br/>
        - Le lieu de départ .<br/>
    - Vous pouvez chatter en socket avec le propriétaire de la publication
  
      

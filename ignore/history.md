

build 10 : 
= ajout d'identifiers manquants (pour les tests UI)
= ajout de textContentType pour les textField
= modification des fonctions signIn et SignUp dans AuthViewModel pour ne plus avoir de completion


build 9 : 
= modification des fonctions asynchrones pour utiliser des await/async plutôt que des completion/closures
= logique pour selectedItem du PhotosPickerItem déplacée dans le profile view model
= création d'un enum AccessID pour tous les AccessibilityIdentifiers
= correction eventList view pour que la liste n'empiète pas sur la tabview
= revue de lagestion des erreurs dans AddEvent view et correction de l'upload d'image 

build 8
+ tri par date chronologique/inverse ou par catégorie (=filtrage)
+ ajout validation adresse dans le view model : séparation geocodage en 2 fonctions (coordonnées, visualisation)
+ ajout accessibilité (avec identifiers pour tests UI)
+ tests unitaires view models (sans mock pour les fonctions firebase)


todo :
= tests unitaires avec mock firebase
= tests d'interface





! le système de gestion des invités, la vue "calendrier", le partage via des réseaux sociaux ne seront pas implémentés

! Idem pour les notifications automatiques envoyées aux utilisateurs (clairement indiqué dans le projet) 





# TODO

-   ok prise de photo
-   ok filtrage les événements par catégorie et date
-   ok recherche
-   ok gestion des erreurs
- accessibilité
- tests

+   NON modif style progressview (circular) 
+   OUI modif alerte (circle aved point d'exclamation, floutage et assombrissement du fond...)



Assurer la réactivité de la recherche en filtrant les événements en temps réel, via les méthodes fournit par Firebase directement (ex : ne pas récupérer tous les événements et filtrer ensuite dans votre code).




CdC
Les événements créés seront visibles sous deux formats : une vue en liste et une vue
calendrier. De plus, les utilisateurs pourront filtrer les événements par catégorie et
date, améliorant ainsi leur expérience de navigation.
étape 4
Développez l'écran principal avec une liste des événements, une barre de recherche, une barre de navigation (visible ou non) composée d’une icône de tri et d’un bouton pour créer un événement.



Contraste élevé : 
Pour vérifier et ajuster les contrastes, tu peux :
Utiliser des outils comme le "Digital Color Meter" sur Mac
Tester avec le mode "Augmented Contrast" d'iOS
Suivre les directives WCAG qui recommandent un ratio de contraste minimum de 4.5:1 pour le texte normal et 3:1 pour le grand texte

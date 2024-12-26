build 8
+ tri par date chronologique/inverse ou par catégorie (=filtrage)
+ ajout validation adresse dans le view model : séparation geocodage en 2 fonctions (coordonnées, visualisation)
+ ajout accessibilité (avec identifiers pour tests UI)
+ tests unitaires view models (sans mock pour les fonctions firebase)


bugs : 
= ajout image new event
= revoir addeEvent et addEventWithImage ??
= revoir upload image event et toutes les images du profil ne s'affichent pas toujours





Un système de gestion des invités sera également intégré pour faciliter le suivi des participations.

Vue calendrier en plus de la vue en liste ?

Des notifications automatiques seront envoyées aux utilisateurs 

La fonctionnalité de partage pour diffuser des événements via des applications de messagerie et des réseaux sociaux




# TODO

-   ok prise de photo
-   ok filtrage les événements par catégorie et date
-   ok recherche
-   ok gestion des erreurs
- accessibilité
- tests

+   NON modif style progressview (circular) 
+   OUI modif alerte (circle aved point d'exclamation, floutage et assombrissement du fond...)



TODO
- faire tests unitaires
- faire accesiibilité
- faire tests UI
- revoir code



Des mesures d'accessibilité seront mises en oeuvre, telles que le contraste élevé des couleurs et les descriptions audio pour les éléments interactifs

Assurer la réactivité de la recherche en filtrant les événements en temps réel, via les méthodes fournit par Firebase directement (ex : ne pas récupérer tous les événements et filtrer ensuite dans votre code).




Un système de gestion des invités sera également intégré pour faciliter le suivi des participations

// 
Des notifications automatiques seront envoyées aux utilisateurs pour les informerdes événements à venir et des mises à jour importantes, renforçant l'interaction utilisateur.
// NE PAS FAIRE

La fonctionnalité de partage permettra aux utilisateurs de diffuser des événements via des applications de messagerie et des réseaux sociaux, augmentant ainsi la portée et la visibilité de leurs événements.



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

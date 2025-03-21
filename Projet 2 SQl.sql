-- Création de la table Commentaire
CREATE TABLE commentaire (
    id_commentaire SERIAL PRIMARY KEY,
    id_visiteur INT REFERENCES visiteur(id_visiteur),
    id_exposition INT REFERENCES exposition(id_exposition),
    note INT CHECK (note >= 1 AND note <= 5),
    commentaire TEXT,
    date_commentaire DATE
);

-- Réinitialisation de la séquence
SELECT setval('commentaire_id_commentaire_seq', 1, false);

-- Insertion de données dans la table Commentaire
INSERT INTO commentaire (id_visiteur, id_exposition, note, commentaire, date_commentaire) VALUES
(1, 1, 5, 'Une exposition magnifique, à ne pas manquer!', '2023-06-01'),
(2, 2, 4, 'Très intéressant, j''ai adoré les détails.', '2023-07-15'),
(3, 3, 3, 'Belle exposition, mais un peu courte.', '2023-08-20'),
(4, 4, 5, 'Incroyable! Les œuvres sont fascinantes.', '2023-09-10'),
(5, 5, 2, 'Décevant, je m''attendais à mieux.', '2023-10-05'),
(6, 6, 4, 'Très enrichissant, j''ai appris beaucoup.', '2023-11-12'),
(7, 7, 5, 'Superbe exposition, les photos sont magnifiques.', '2023-12-18'),
(8, 8, 3, 'Correct, mais pas exceptionnel.', '2024-01-03'),
(9, 9, 4, 'Très créatif, j''ai beaucoup aimé.', '2024-02-15'),
(10, 10, 5, 'Excellente exposition, très bien organisée.', '2024-03-01');

-- 1. Requêtes de jointure
SELECT o.titre AS oeuvre, a.nom AS artiste, e.titre AS exposition
FROM oeuvre o
JOIN artiste a ON o.id_artiste = a.id_artiste
JOIN exposition e ON o.id_exposition = e.id_exposition;

SELECT v.nom, v.prenom, e.titre AS exposition
FROM visiteur v
JOIN visite vis ON v.id_visiteur = vis.id_visiteur
JOIN exposition e ON vis.id_exposition = e.id_exposition;

SELECT m.nom AS musee, e.titre AS exposition
FROM musee m
JOIN exposition e ON m.id_musee = e.id_musee;

-- 2. Requêtes avec champs calculés
SELECT id_artiste, COUNT(id_oeuvre) * 1000 AS revenu_total
FROM oeuvre
GROUP BY id_artiste;

SELECT id_exposition, COUNT(id_visite) * 20 AS valeur_totale
FROM visite
GROUP BY id_exposition;

SELECT id_exposition, AVG(nb_oeuvres) AS moyenne_oeuvres
FROM (
    SELECT id_exposition, COUNT(id_oeuvre) AS nb_oeuvres
    FROM oeuvre
    GROUP BY id_exposition
) AS subquery

SELECT id_exposition, (date_fin - date_debut) AS duree
FROM exposition;

-- Exercices bonus
SELECT m.nom AS musee, COUNT(v.id_visite) * 15 AS revenu_total
FROM musee m
JOIN exposition e ON m.id_musee = e.id_musee
JOIN visite v ON e.id_exposition = v.id_exposition
GROUP BY m.nom;

SELECT o.titre AS oeuvre, a.nom, a.prenom, (o.annee_creation - a.annee_naissance) AS age_creation
FROM oeuvre o
JOIN artiste a ON o.id_artiste = a.id_artiste;

-- 3. Requêtes de jointure avec champs calculés
SELECT m.nom AS musee, e.titre AS exposition, COUNT(o.id_oeuvre) AS nb_oeuvres
FROM musee m
JOIN exposition e ON m.id_musee = e.id_musee
JOIN oeuvre o ON e.id_exposition = o.id_exposition
GROUP BY m.nom, e.titre;

SELECT AVG(nb_visites) AS moyenne_visites
FROM (
    SELECT id_exposition, COUNT(id_visite) AS nb_visites
    FROM visite
    GROUP BY id_exposition
) AS subquery;

-- bonus
SELECT e.titre AS exposition, COUNT(v.id_visite) * 20 AS revenu_total
FROM exposition e
JOIN visite v ON e.id_exposition = v.id_exposition
GROUP BY e.titre;

-- Requêtes sur la table Commentaire
SELECT * FROM commentaire WHERE id_exposition = 1;

SELECT id_exposition, AVG(note) AS note_moyenne
FROM commentaire
GROUP BY id_exposition;

SELECT DISTINCT v.nom, v.prenom
FROM visiteur v
JOIN commentaire c ON v.id_visiteur = c.id_visiteur
WHERE c.note = 5;

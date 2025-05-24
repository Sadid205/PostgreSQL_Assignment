-- Active: 1747413813562@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name      VARCHAR(50),
    region    VARCHAR(50)
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date  DATE,
    conservation_status VARCHAR(50)
);



CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INT,
    FOREIGN KEY (species_id) REFERENCES species(species_id) ON DELETE CASCADE,
    ranger_id   INT,
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    location VARCHAR(50),
    sighting_time TIMESTAMP,
    notes VARCHAR(50)
);

INSERT INTO rangers(name,region)VALUES
('Alice Green','Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range');

INSERT INTO species (common_name,scientific_name,discovery_date,conservation_status) VALUES
('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),
('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),
('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');


INSERT INTO sightings(species_id,ranger_id,location,sighting_time,notes)VALUES
(1,1,'Peak Ridge','2024-05-10 07:45:00','Camera trap image captured'),
(2,2,'Bankwood Area','2024-05-12 16:20:00','Juvenile seen'),
(3,3,'Bamboo Grove East','2024-05-15 09:10:00','Feeding observed '),
(1,2,'Snowfall Pass','2024-05-18 18:30:00',NULL);


-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers(name,region)VALUES
('Derek Fox','Coastal Plains');

-- 2️⃣ Count unique species ever sighted.
SELECT count(DISTINCT species_id)as unique_species_count  FROM sightings;


-- 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- 4️⃣ List each ranger's name and their total number of sightings.
SELECT name,count(*) FROM rangers as r
JOIN sightings as s ON r.ranger_id = s.ranger_id
GROUP BY name
ORDER BY name;

-- 5️⃣ List species that have never been sighted.
SELECT sp.common_name FROM species as sp
left JOIN sightings as si ON sp.species_id = si.species_id
WHERE si.species_id is NULL;

-- 6️⃣ Show the most recent 2 sightings.
SELECT sp.common_name,si.sighting_time,r.name FROM sightings as si
JOIN species as sp ON si.species_id = sp.species_id 
JOIN rangers as r ON si.ranger_id = r.ranger_id
ORDER BY sighting_time DESC LIMIT 2;

-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
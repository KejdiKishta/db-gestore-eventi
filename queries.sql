-- 1. Selezionare tutti gli eventi gratis, cioè con prezzo nullo (19)

SELECT *
FROM events
WHERE price IS NULL;

-- 2. Selezionare tutte le location in ordine alfabetico (82)

SELECT *
FROM locations
ORDER BY name ASC;

-- 3.Selezionare tutti gli eventi che costano meno di 20 euro e durano meno di 3 ore (38)

SELECT *
FROM events
WHERE price < 20
AND duration < '03:00:00';

-- 4. Selezionare tutti gli eventi di dicembre 2023 (25)

SELECT *
FROM events
WHERE start
LIKE "2023-12-%";

-- 5. Selezionare tutti gli eventi con una durata maggiore alle 2 ore (823)

SELECT *
FROM events
WHERE duration >= "03:00:00";

-- 6. Selezionare tutti gli eventi, mostrando nome, data di inizio, ora di inizio, ora di fine e durata totale (1040)

SELECT name, DATE(start) AS 'date_start', TIME(start) AS 'time_start', ADDTIME (TIME(start), duration) AS 'time_end', duration
FROM events;

-- 7. Selezionare tutti gli eventi aggiunti da “Fabiano Lombardo” (id: 1202) (132)

SELECT *
FROM events
WHERE user_id = 1202;

-- 8. Selezionare il numero totale di eventi per ogni fascia di prezzo (81)

SELECT price, COUNT(id) AS 'total_events'
FROM events
GROUP BY price  
ORDER BY `events`.`price` ASC;

-- 9. Selezionare tutti gli utenti admin ed editor (9)

SELECT *
FROM users
WHERE role_id = 1
OR role_id = 2;

-- 10. Selezionare tutti i concerti (eventi con il tag “concerti”) (72)

SELECT *
FROM events
INNER JOIN event_tag
ON events.id = event_tag.tag_id
WHERE event_tag.tag_id = 1;

-- 11. Selezionare tutti i tag e il prezzo medio degli eventi a loro collegati (11)

SELECT tags.name, COUNT(events.id) AS 'num_eventi', AVG(events.price) AS 'costo_medio'
FROM tags
INNER JOIN event_tag
ON tags.id = event_tag.tag_id
INNER JOIN events
ON event_tag.event_id = events.id
GROUP BY tags.name;

-- 12. Selezionare tutte le location e mostrare quanti eventi si sono tenute in ognuna di esse (82)

SELECT locations.id, locations.name, COUNT(events.id) AS 'num_events'
FROM locations
INNER JOIN events
ON locations.id = events.location_id
GROUP BY locations.id;

-- 13. Selezionare tutti i partecipanti per l’evento “Concerto Classico Serale” (slug: concerto-classico-serale, id: 34) (30)

SELECT users.first_name, users.last_name 
FROM bookings
INNER JOIN users
ON bookings.user_id = users.id
INNER JOIN events
ON events.id = bookings.event_id
WHERE events.slug = "concerto-classico-serale";

-- 14. Selezionare tutti i partecipanti all’evento “Festival Jazz Estivo” (slug: festival-jazz-estivo, id: 2) specificando nome e cognome (13)

SELECT users.first_name, users.last_name 
FROM bookings
INNER JOIN users
ON bookings.user_id = users.id
INNER JOIN events
ON events.id = bookings.event_id
WHERE events.slug = "festival-jazz-estivo";

-- 15. Selezionare tutti gli eventi sold out (dove il totale delle prenotazioni è uguale ai biglietti totali per l’evento) (18)

SELECT events.name, events.total_tickets, COUNT(bookings.event_id) AS 'bookings'
FROM events
INNER JOIN bookings
WHERE events.id = bookings.event_id
GROUP BY events.name
HAVING events.total_tickets = bookings;

-- 16. Selezionare tutte le location in ordine per chi ha ospitato più eventi (82)

SELECT locations.name, COUNT(events.location_id) AS 'num_events'
FROM locations
INNER JOIN events
ON locations.id = events.location_id
GROUP BY locations.name  
ORDER BY num_events DESC;

-- 17. Selezionare tutti gli utenti che si sono prenotati a più di 70 eventi (74)

SELECT users.first_name, users.last_name, COUNT(bookings.id) AS 'total_bookings' 
FROM users
INNER JOIN bookings
ON users.id = bookings.user_id
GROUP BY users.id
HAVING COUNT(bookings.id) > 70  
ORDER BY total_bookings DESC;

-- 18. Selezionare tutti gli eventi, mostrando il nome dell’evento, il nome della location, il numero di prenotazioni e il totale di biglietti ancora disponibili per l’evento (1040)

SELECT events.name AS 'event', locations.name AS 'location', events.total_tickets AS 'total_tickets', COUNT(bookings.id) AS 'bookings', events.total_tickets - COUNT(bookings.id) AS 'remaining_tickets'
FROM events
INNER JOIN locations
ON events.location_id = locations.id
INNER JOIN bookings
ON bookings.event_id = events.id
GROUP BY event  
ORDER BY remaining_tickets DESC;
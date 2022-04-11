SELECT a.Stadt, Count(a.Stadt) AS "Anzahl FW"
FROM FerienWhng f, Adresse a
WHERE f.AdrId = a.AdrID
GROUP BY a.Stadt;



SELECT f.fwname, Avg(b.anzsterne) AS "Durschnittliche Bewertung"
FROM FerienWhng f, Buchung b
WHERE f.fwid = b.fwid
GROUP BY f.fwname;



SELECT COUNT(*) AS "Anz. nie gebucht"
FROM FerienWhng f
FULL OUTER JOIN Buchung b
ON f.fwid = b.fwid
WHERE b.fwid IS NULL;



CREATE or replace VIEW cool(FwName, AnzAusstattungen) AS
SELECT f.fwname, COUNT(ba.ausstattungname) AS "AnzAusstattungen"
FROM Besitztausstattung ba
INNER JOIN FerienWhng f
ON ba.fwid = f.fwid 
GROUP BY f.fwname
ORDER BY COUNT(ba.ausstattungname) desc;

SELECT FwName, AnzAusstattungen
FROM cool
WHERE AnzAusstattungen = (SELECT MAX(AnzAusstattungen) FROM cool);



SELECT l.landname, NVL(Count(b.buchungsnr), 0) AS "AnzBuchungen"
FROM Land l
LEFT JOIN Adresse a ON a.landname = l.landname
LEFT JOIN Ferienwhng fw ON a.adrid = fw.adrid
LEFT JOIN Buchung b ON b.fwid = fw.fwid
GROUP BY l.landname
ORDER BY  NVL(Count(b.buchungsnr), 0) desc;



SELECT f.FwName, AVG(b.AnzSterne) AS "durchschnittliche Bewertung"
FROM Buchung b
INNER JOIN Ferienwhng f ON b.Fwid = f.Fwid
INNER JOIN Adresse a ON f.AdrID = a.AdrID
WHERE a.Landname = 'Spanien' AND f.Fwid NOT IN 
    (SELECT f.Fwid
     FROM Buchung b 
     WHERE b.Anrdatum BETWEEN '01/11/2019' AND  '21/11/2019'
     OR b.Abrdatum BETWEEN '01/11/2019' AND '21/11/2019'
     OR b.Anrdatum < '01/11/2019' AND b.Abrdatum > '21/11/2019'
    )
AND f.Fwid IN (SELECT fw.Fwid FROM Besitztausstattung fw WHERE fw.Ausstattungname = 'Sauna')
GROUP BY f.Fwname
ORDER BY AVG(b.AnzSterne) DESC;



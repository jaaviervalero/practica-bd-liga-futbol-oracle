WITH
PartidosPrimera AS (
    SELECT id_temporada, juegaLocal, JuegaVisitante, goles_local, goles_visitante
    FROM PARTIDO
    WHERE id_division = '1'
),  

-- 1. Sacamos las veces que un equipo ha jugado en 1ª División 
-- (Basta con mirar los partidos locales, todos juegan en casa 1 vez al año)
Participaciones AS (
    SELECT DISTINCT id_temporada, juegaLocal AS equipo
    FROM PartidosPrimera
),

-- 2. Filtramos solo los equipos que llevan 25 o más temporadas
EquiposMas25Part AS (
    SELECT equipo
    FROM Participaciones
    GROUP BY equipo
    HAVING COUNT(*) >= 25   
),

-- 3. CALCULAMOS LOS PUNTOS DE CADA PARTIDO (Sin usar CASE)
PuntosPartido AS (
    -- 3 puntos por victoria local
    SELECT id_temporada, juegaLocal AS equipo, 3 AS ptos 
    FROM PartidosPrimera WHERE goles_local > goles_visitante
    UNION ALL
    -- 1 punto por empate local
    SELECT id_temporada, juegaLocal AS equipo, 1 AS ptos 
    FROM PartidosPrimera WHERE goles_local = goles_visitante
    UNION ALL
    -- 3 puntos por victoria visitante
    SELECT id_temporada, juegaVisitante AS equipo, 3 AS ptos 
    FROM PartidosPrimera WHERE goles_visitante > goles_local
    UNION ALL
    -- 1 punto por empate visitante
    SELECT id_temporada, juegaVisitante AS equipo, 1 AS ptos 
    FROM PartidosPrimera WHERE goles_visitante = goles_local
),

-- 4. Sumamos los puntos totales de cada equipo en cada temporada
Clasificacion AS (
    SELECT id_temporada, equipo, SUM(ptos) AS puntos_totales
    FROM PuntosPartido
    GROUP BY id_temporada, equipo
),

-- 5. Buscamos cuál fue la puntuación máxima (el récord) de cada año
MaxPuntosPorTemporada AS (
    SELECT id_temporada, MAX(puntos_totales) AS max_ptos
    FROM Clasificacion
    GROUP BY id_temporada
),

-- 6. Obtenemos la lista de los equipos campeones históricos
Campeones AS (
    SELECT DISTINCT c.equipo
    FROM Clasificacion c
    JOIN MaxPuntosPorTemporada m 
      ON c.id_temporada = m.id_temporada AND c.puntos_totales = m.max_ptos
)

-- 7. TU LÓGICA FINAL: Equipos veteranos donde NO EXISTE victoria en liga
SELECT e.equipo 
FROM EquiposMas25Part e
WHERE NOT EXISTS (
    SELECT 1
    FROM Campeones c
    WHERE c.equipo = e.equipo
)
ORDER BY e.equipo;
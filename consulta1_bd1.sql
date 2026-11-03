WITH 

-- 1 EXTRAER LOS IDENTIFICADORES DE TODAS LS TEMPORADAS

Temp2Div AS (
    SELECT DISTINCT id_temporada
    FROM PARTIDO
    WHERE id_division = '2'
),


-- 2. EXTRAER LAS 5 TEMPORADAS MÁS RECIENTES

Ultimas5Temp AS (
    SELECT t1.id_temporada
    FROM Temp2Div t1
    WHERE (
            SELECT COUNT(*)
            FROM Temp2Div t2
            WHERE t2.id_temporada > t1.id_temporada
    ) < 5
),


-- 3. EXTRAER LOS GOLES MARCADOS EN CADA JORNADA DE LAS Ultimas5Temp.

GolesPorJornada AS (
    SELECT id_temporada, num_jornada, SUM(goles_local + goles_visitante) AS golesTotal
    FROM PARTIDO
    WHERE id_division = '2'AND id_temporada IN (SELECT id_temporada FROM Ultimas5Temp)
    GROUP BY id_temporada, num_jornada
),


-- 4. BUSCAR EL RECORD DE GOLES EN UNA JORNADA EN CADA JORNADA DE LAS Ultimas5Temp

MaxPorTemporada AS (
    SELECT id_temporada, MAX(golesTotal) AS maxGoles
    FROM GolesPorJornada
    GROUP BY id_temporada
)


-- 5. EXTRAER EL NÚMERO DE LA JORNADA GANADOR Y MOSTRAR LOS RESULTADOS ORDENADOS DESDE EL AÑO MÁS RECIENTE AL MÁS ANTIGUO.

SELECT G.id_temporada, G.num_jornada, G.golesTotal
FROM GolesPorJornada G
JOIN MaxPorTemporada M
    ON G.id_temporada = M.id_temporada AND G.golesTotal = M.maxGoles
    
ORDER BY G.id_temporada DESC, G.num_jornada;
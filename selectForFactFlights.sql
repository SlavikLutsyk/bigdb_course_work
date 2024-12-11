SELECT 
    CAST(FORMAT(f.departure_time, 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS departure_time,
    CAST(FORMAT(f.arrival_time, 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS arrival_time,
    f.pilot_id AS pilot_id,
    f.commander_id AS commander_id,
    f.plane_id AS plane_id,
    f.stewardess_1_id AS stewardess_1_id,
    f.stewardess_2_id AS stewardess_2_id,
    f.sold_tickets AS tickets_sold
FROM Flight AS f
-- Зв'язок із таблицею літаків
INNER JOIN Plane AS p
    ON f.plane_id = p.plane_id
-- Зв'язок із таблицею моделей літаків
INNER JOIN Model AS m
    ON p.model_id = m.model_id
-- Зв'язок із таблицею дозволених моделей для пілотів
LEFT JOIN Pilot_Model AS pm
    ON f.pilot_id = pm.pilot_id
    AND pm.model_id = p.model_id
WHERE
    -- Перевірка: квитки продані більше половини місць
    f.sold_tickets > (m.number_seats / 2)
    -- Перевірка: пілот не має рейсів, які перекриваються
    AND NOT EXISTS (
        SELECT 1
        FROM Flight AS overlap
        WHERE overlap.pilot_id = f.pilot_id
          AND overlap.flight_id != f.flight_id
          AND (overlap.departure_time < f.arrival_time AND overlap.arrival_time > f.departure_time)
    )
    -- Перевірка: командир не має рейсів, які перекриваються
    AND NOT EXISTS (
        SELECT 1
        FROM Flight AS overlap
        WHERE overlap.commander_id = f.commander_id
          AND overlap.flight_id != f.flight_id
          AND (overlap.departure_time < f.arrival_time AND overlap.arrival_time > f.departure_time)
    )
    -- Перевірка: літак не використовується на інших рейсах у цей час
    AND NOT EXISTS (
        SELECT 1
        FROM Flight AS overlap
        WHERE overlap.plane_id = f.plane_id
          AND overlap.flight_id != f.flight_id
          AND (overlap.departure_time < f.arrival_time AND overlap.arrival_time > f.departure_time)
    )
    -- Перевірка: пілот має перерву між рейсами не менше 3 днів
    AND NOT EXISTS (
        SELECT 1
        FROM Flight AS prev_flight
        WHERE prev_flight.pilot_id = f.pilot_id
          AND prev_flight.flight_id != f.flight_id
          AND DATEDIFF(DAY, prev_flight.arrival_time, f.departure_time) < 3
    )
    ---- Перевірка: стюардеси не зайняті на інших рейсах у цей час
    --AND NOT EXISTS (
    --    SELECT 1
    --    FROM Flight AS overlap
    --    WHERE overlap.flight_id != f.flight_id
    --      AND (
    --          overlap.stewardess_1_id = f.stewardess_1_id
    --          OR overlap.stewardess_2_id = f.stewardess_1_id
    --          OR overlap.stewardess_1_id = f.stewardess_2_id
    --          OR overlap.stewardess_2_id = f.stewardess_2_id
    --      )
    --      AND (overlap.departure_time < f.arrival_time AND overlap.arrival_time > f.departure_time)
    --);

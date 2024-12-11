(
    SELECT DISTINCT
        CAST(FORMAT(departure_time, 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS date,
        YEAR(departure_time) AS year,
        MONTH(departure_time) AS month,
        DAY(departure_time) AS day,
        DATEPART(HOUR, departure_time) AS hour,
        DATEPART(MINUTE, departure_time) AS minute,
        DATEPART(SECOND, departure_time) AS second
    FROM dbo.Flight
    UNION
    SELECT DISTINCT
        CAST(FORMAT(arrival_time, 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS date,
        YEAR(arrival_time) AS year,
        MONTH(arrival_time) AS month,
        DAY(arrival_time) AS day,
        DATEPART(HOUR, arrival_time) AS hour,
        DATEPART(MINUTE, arrival_time) AS minute,
        DATEPART(SECOND, arrival_time) AS second
    FROM dbo.Flight
)

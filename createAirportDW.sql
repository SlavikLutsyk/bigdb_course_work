IF DB_ID('AirportDW') IS NOT NULL
    DROP DATABASE AirportDW;
GO

-- ��������� ���� �����
CREATE DATABASE AirportDW;
GO

USE AirportDW;
GO

-- ������� ����� ������ (Dim_Crew)
CREATE TABLE Dim_Crew (
    crew_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    birth_date DATE NULL,
    address NVARCHAR(255) NULL,
    role NVARCHAR(50) NULL, -- ����: 'Commander', 'Pilot', 'Stewardess'
	crew_key INT NULL
);

-- ������� ����� ������� ����� (Dim_Model)
CREATE TABLE Dim_Model (
    model_id INT IDENTITY(1,1) PRIMARY KEY,
    number_seats INT NULL,
    carrying_capacity INT NULL,
	model_key INT NULL
);

-- ������� ����� ����� (Dim_Plane)
CREATE TABLE Dim_Plane (
    plane_id INT IDENTITY(1,1) PRIMARY KEY,
    model_id INT NULL,
    hours_worked INT NULL,
	plane_key INT NULL,
    FOREIGN KEY (model_id) REFERENCES Dim_Model(model_id)
);

-- ������� ����� ���� (Dim_Time)
CREATE TABLE Dim_Time (
    time_id INT IDENTITY(1,1) PRIMARY KEY,
    date DATETIME NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL
);

-- ��������� ������� Fact_Flights
CREATE TABLE Fact_Flights (
    flight_id INT IDENTITY(1,1) PRIMARY KEY, -- ������������� �����
    departure_time_id INT NOT NULL,         -- ID ���� �������
    arrival_time_id INT NOT NULL,           -- ID ���� ��������
    pilot_id INT NOT NULL,                  -- ID �����
    commander_id INT NOT NULL,              -- ID ���������
    plane_id INT NOT NULL,                  -- ID �����
    stewardess_1_id INT NOT NULL,           -- ID ����� ���������
    stewardess_2_id INT NOT NULL,           -- ID ����� ���������
    tickets_sold INT NOT NULL,              -- ʳ������ �������� ������
    FOREIGN KEY (departure_time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (arrival_time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (pilot_id) REFERENCES Dim_Crew(crew_id),
    FOREIGN KEY (commander_id) REFERENCES Dim_Crew(crew_id),
    FOREIGN KEY (plane_id) REFERENCES Dim_Plane(plane_id),
    FOREIGN KEY (stewardess_1_id) REFERENCES Dim_Crew(crew_id),
    FOREIGN KEY (stewardess_2_id) REFERENCES Dim_Crew(crew_id)
);
GO


-- ������� ������ ����� � �������� ����� (Bridge_Pilot_Model)
CREATE TABLE Bridge_Pilot_Model (
    pilot_id INT NOT NULL,
    model_id INT NOT NULL,
    PRIMARY KEY (pilot_id, model_id),
    FOREIGN KEY (pilot_id) REFERENCES Dim_Crew(crew_id),
    FOREIGN KEY (model_id) REFERENCES Dim_Model(model_id)
);

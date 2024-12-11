-- ��������� ���� �����
CREATE DATABASE Airport;
GO

USE Airport;
GO

-- ������� ��� ������ (� ���� �������)
CREATE TABLE Crew (
    crew_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    address NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL -- ����: 'Commander', 'Pilot', 'Stewardess'
);

-- ������� ��� ������� �����
CREATE TABLE Model (
    model_id INT IDENTITY(1,1) PRIMARY KEY,
    number_seats INT NOT NULL,
    carrying_capacity INT NOT NULL
);

-- ������� ��� �����
CREATE TABLE Plane (
    plane_id INT IDENTITY(1,1) PRIMARY KEY,
    model_id INT NOT NULL,
    hours_worked INT NOT NULL,
    FOREIGN KEY (model_id) REFERENCES Model(model_id)
);

-- ������� ��� �����
CREATE TABLE Flight (
    flight_id INT IDENTITY(1,1) PRIMARY KEY,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    pilot_id INT NOT NULL,
    commander_id INT NOT NULL,
	stewardess_1_id INT NOT NULL,           -- ID ����� ���������
    stewardess_2_id INT NOT NULL,           -- ID ����� ���������
    plane_id INT NOT NULL,
	sold_tickets INT NOT NULL CHECK (sold_tickets >= 0),
    FOREIGN KEY (pilot_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (commander_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (plane_id) REFERENCES Plane(plane_id),
	FOREIGN KEY (stewardess_1_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (stewardess_2_id) REFERENCES Crew(crew_id)
);

-- ��'���� ����� � �������� �����
CREATE TABLE Pilot_Model (
    pilot_id INT NOT NULL,
    model_id INT NOT NULL,
    PRIMARY KEY (pilot_id, model_id),
    FOREIGN KEY (pilot_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (model_id) REFERENCES Model(model_id)
);

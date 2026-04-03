USE HospitalAppointmentDB;
GO

-- ============================================================
-- TABLO 1: Departments (Bölümler / Poliklinikler)
-- En baðýmsýz tablo — hiçbir FK içermez.
-- ============================================================
CREATE TABLE Departments (
    DepartmentID   INT           IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,  -- Kardiyoloji, Ortopedi vb.
    Floor          INT           NULL              -- Kaçýncý katta?
);
GO
PRINT 'Departments tablosu oluþturuldu.';

-- ============================================================
-- TABLO 2: Doctors (Doktorlar)
-- Departments tablosuna N-1 ile baðlý.
-- Bir departmanýn birden fazla doktoru olur.
-- ============================================================
CREATE TABLE Doctors (
    DoctorID      INT           IDENTITY(1,1) PRIMARY KEY,
    FirstName     NVARCHAR(50)  NOT NULL,
    LastName      NVARCHAR(50)  NOT NULL,
    Title         NVARCHAR(30)  NOT NULL DEFAULT 'Dr.',  -- Dr., Prof. Dr., Doç. Dr.
    DepartmentID  INT           NOT NULL,
    PhoneNumber   VARCHAR(15)   NULL,
    Email         NVARCHAR(100) NULL UNIQUE,
    IsActive      BIT           NOT NULL DEFAULT 1,      -- 1: Aktif, 0: Pasif

    CONSTRAINT FK_Doctors_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO
PRINT 'Doctors tablosu oluþturuldu.';

-- ============================================================
-- TABLO 3: Patients (Hastalar)
-- Baðýmsýz tablo — hasta bilgileri.
-- ============================================================
CREATE TABLE Patients (
    PatientID    INT           IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(50)  NOT NULL,
    LastName     NVARCHAR(50)  NOT NULL,
    TCNumber     CHAR(11)      NOT NULL UNIQUE,   -- TC Kimlik No: tam 11 karakter
    BirthDate    DATE          NOT NULL,
    Gender       CHAR(1)       NOT NULL CHECK (Gender IN ('E', 'K')),  -- E: Erkek, K: Kadýn
    PhoneNumber  VARCHAR(15)   NULL,
    Email        NVARCHAR(100) NULL UNIQUE,
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);
GO
PRINT 'Patients tablosu oluþturuldu.';


CREATE TABLE Appointments (
    AppointmentID   INT           IDENTITY(1,1) PRIMARY KEY,
    PatientID       INT           NOT NULL,
    DoctorID        INT           NOT NULL,
    AppointmentDate DATE          NOT NULL,
    AppointmentTime TIME(0)       NOT NULL,   
    Status          VARCHAR(20)   NOT NULL DEFAULT 'Scheduled'
                                  CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')),
    Notes           NVARCHAR(500) NULL,
    CreatedAt       DATETIME      NOT NULL DEFAULT GETDATE(),

 
    CONSTRAINT FK_Appointments_Patients
        FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_Appointments_Doctors
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),

    
    CONSTRAINT UQ_Doctor_DateTime
        UNIQUE (DoctorID, AppointmentDate, AppointmentTime),

   
    CONSTRAINT CHK_FutureDate
        CHECK (AppointmentDate >= CAST(GETDATE() AS DATE))
);
GO
PRINT 'Appointments tablosu oluþturuldu.';
PRINT '>>> Tüm tablolar baþarýyla oluþturuldu!';
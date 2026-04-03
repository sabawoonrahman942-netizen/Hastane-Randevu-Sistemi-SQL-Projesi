USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'HospitalAppointmentDB')
BEGIN
    ALTER DATABASE HospitalAppointmentDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HospitalAppointmentDB;
END
GO

CREATE DATABASE HospitalAppointmentDB
COLLATE Turkish_CI_AS;
GO

USE HospitalAppointmentDB;
GO

PRINT 'HospitalAppointmentDB baþarýyla oluþturuldu!';
GO
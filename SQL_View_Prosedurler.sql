USE HospitalAppointmentDB;
GO

-- ============================================================

CREATE VIEW vw_RandevuDetaylari AS
SELECT
    a.AppointmentID,
    p.FirstName + ' ' + p.LastName              AS Hasta,
    p.TCNumber                                   AS TcNo,
    d.Title + ' ' + d.FirstName + ' ' + d.LastName AS Doktor,
    dep.DepartmentName                           AS Bolum,
    a.AppointmentDate                            AS RandevuTarihi,
    a.AppointmentTime                            AS RandevuSaati,
    a.Status                                     AS Durum,
    a.Notes                                      AS Notlar
FROM Appointments a
INNER JOIN Patients    p   ON a.PatientID    = p.PatientID
INNER JOIN Doctors     d   ON a.DoctorID     = d.DoctorID
INNER JOIN Departments dep ON d.DepartmentID = dep.DepartmentID;
GO
PRINT 'vw_RandevuDetaylari view oluþturuldu.';

-- ============================================================

CREATE VIEW vw_BosRandevular AS
SELECT
    d.DoctorID,
    d.Title + ' ' + d.FirstName + ' ' + d.LastName AS Doktor,
    dep.DepartmentName                              AS Bolum,
    a.AppointmentDate                               AS Tarih,
    a.AppointmentTime                               AS Saat
FROM Doctors d
INNER JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
LEFT  JOIN Appointments a  ON d.DoctorID     = a.DoctorID
                           AND a.Status = 'Scheduled'
                           AND a.AppointmentDate >= CAST(GETDATE() AS DATE)
WHERE a.AppointmentID IS NULL  
   OR a.AppointmentDate IS NULL;
GO
PRINT 'vw_BosRandevular view oluþturuldu.';

-- ============================================================

CREATE PROCEDURE sp_RandevuOlustur
    @PatientID       INT,
    @DoctorID        INT,
    @AppointmentDate DATE,
    @AppointmentTime TIME(0),
    @Notes           NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Doctors WHERE DoctorID = @DoctorID AND IsActive = 1)
        BEGIN
            RAISERROR('HATA: Bu doktor aktif deðil veya bulunamadý!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

     
        IF NOT EXISTS (SELECT 1 FROM Patients WHERE PatientID = @PatientID)
        BEGIN
            RAISERROR('HATA: Hasta bulunamadý!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM Appointments
            WHERE DoctorID        = @DoctorID
              AND AppointmentDate = @AppointmentDate
              AND AppointmentTime = @AppointmentTime
              AND Status          = 'Scheduled'
        )
        BEGIN
            RAISERROR('HATA: Bu doktorun belirtilen tarih ve saatte zaten bir randevusu var!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

     
        IF EXISTS (
            SELECT 1 FROM Appointments
            WHERE PatientID      = @PatientID
              AND DoctorID       = @DoctorID
              AND AppointmentDate = @AppointmentDate
              AND Status         = 'Scheduled'
        )
        BEGIN
            RAISERROR('HATA: Bu hasta ayný gün bu doktora zaten randevu almýþ!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

     
        INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Notes)
        VALUES (@PatientID, @DoctorID, @AppointmentDate, @AppointmentTime, @Notes);

        COMMIT TRANSACTION;
        PRINT 'Randevu baþarýyla oluþturuldu!';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO
PRINT 'sp_RandevuOlustur prosedürü oluþturuldu.';

-- ============================================================

CREATE PROCEDURE sp_RandevuIptal
    @AppointmentID INT,
    @PatientID     INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1 FROM Appointments
            WHERE AppointmentID = @AppointmentID
              AND PatientID     = @PatientID
              AND Status        = 'Scheduled'
        )
        BEGIN
            RAISERROR('HATA: Ýptal edilecek aktif randevu bulunamadý!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Appointments
        SET Status = 'Cancelled'
        WHERE AppointmentID = @AppointmentID;

        COMMIT TRANSACTION;
        PRINT 'Randevu baþarýyla iptal edildi!';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO
PRINT '>>> Tüm VIEW ve Stored Procedure''ler oluþturuldu!';
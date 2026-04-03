USE HospitalAppointmentDB;
GO

-- =====================================================

SELECT * FROM vw_RandevuDetaylari
ORDER BY RandevuTarihi, RandevuSaati;

-- =====================================================

SELECT
    p.FirstName + ' ' + p.LastName   AS Hasta,
    p.TCNumber                        AS TcNo,
    p.PhoneNumber                     AS Telefon,
    a.AppointmentDate                 AS RandevuTarihi,
    a.AppointmentTime                 AS RandevuSaati,
    a.Status                          AS Durum
FROM Appointments a
INNER JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.DoctorID = 1
ORDER BY a.AppointmentDate, a.AppointmentTime;

-- =====================================================

SELECT
    d.Title + ' ' + d.FirstName + ' ' + d.LastName AS Doktor,
    dep.DepartmentName                              AS Bolum
FROM Doctors d
INNER JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE d.DoctorID NOT IN (
    SELECT DISTINCT DoctorID FROM Appointments
    WHERE Status = 'Scheduled'
      AND AppointmentDate >= CAST(GETDATE() AS DATE)
)
AND d.IsActive = 1;

-- =====================================================


EXEC sp_RandevuOlustur
    @PatientID       = 3,
    @DoctorID        = 3,
    @AppointmentDate = '2026-05-15',
    @AppointmentTime = '10:30',
    @Notes           = 'Diz aðrýsý þikayeti';

-- =====================================================

EXEC sp_RandevuOlustur
    @PatientID       = 4,
    @DoctorID        = 1,
    @AppointmentDate = '2026-05-10',
    @AppointmentTime = '09:00';


EXEC sp_RandevuIptal @AppointmentID = 1, @PatientID = 1;

-- =====================================================

SELECT
    dep.DepartmentName              AS Bolum,
    COUNT(a.AppointmentID)          AS ToplamRandevu,
    SUM(CASE WHEN a.Status = 'Scheduled'  THEN 1 ELSE 0 END) AS Planli,
    SUM(CASE WHEN a.Status = 'Completed'  THEN 1 ELSE 0 END) AS Tamamlanan,
    SUM(CASE WHEN a.Status = 'Cancelled'  THEN 1 ELSE 0 END) AS Iptal
FROM Departments dep
LEFT JOIN Doctors      d ON dep.DepartmentID = d.DepartmentID
LEFT JOIN Appointments a ON d.DoctorID       = a.DoctorID
GROUP BY dep.DepartmentID, dep.DepartmentName
ORDER BY ToplamRandevu DESC;

-- =====================================================

SELECT TOP 3
    d.Title + ' ' + d.FirstName + ' ' + d.LastName AS Doktor,
    dep.DepartmentName                              AS Bolum,
    COUNT(a.AppointmentID)                          AS RandevuSayisi
FROM Doctors d
INNER JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
LEFT  JOIN Appointments a  ON d.DoctorID     = a.DoctorID
                           AND a.Status = 'Scheduled'
GROUP BY d.DoctorID, d.Title, d.FirstName, d.LastName, dep.DepartmentName
ORDER BY RandevuSayisi DESC;

-- =====================================================

SELECT * FROM vw_RandevuDetaylari
WHERE RandevuTarihi = '2026-05-10'
ORDER BY RandevuSaati;
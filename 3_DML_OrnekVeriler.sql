USE HospitalAppointmentDB;
GO

-- Departments
INSERT INTO Departments (DepartmentName, Floor) VALUES
('Kardiyoloji',      3),
('Ortopedi',         2),
('Nöroloji',         4),
('Dahiliye',         1),
('Göz Hastalıkları', 2);
GO

-- Doctors (Her departmana 1-2 doktor)
INSERT INTO Doctors (FirstName, LastName, Title, DepartmentID, PhoneNumber, Email) VALUES
('Ahmet',   'Yılmaz',  'Prof. Dr.', 1, '05551110001', 'ahmet.yilmaz@hastane.com'),
('Ayşe',    'Kara',    'Dr.',       1, '05551110002', 'ayse.kara@hastane.com'),
('Mehmet',  'Demir',   'Doç. Dr.', 2, '05551110003', 'mehmet.demir@hastane.com'),
('Fatma',   'Şahin',   'Dr.',       3, '05551110004', 'fatma.sahin@hastane.com'),
('Ali',     'Çelik',   'Prof. Dr.', 4, '05551110005', 'ali.celik@hastane.com');
GO

-- Patients
INSERT INTO Patients (FirstName, LastName, TCNumber, BirthDate, Gender, PhoneNumber, Email) VALUES
('Zeynep',  'Aydın',   '12345678901', '1990-05-15', 'K', '05559990001', 'zeynep@mail.com'),
('Burak',   'Koç',     '23456789012', '1985-08-22', 'E', '05559990002', 'burak@mail.com'),
('Selin',   'Arslan',  '34567890123', '1995-03-10', 'K', '05559990003', 'selin@mail.com'),
('Emre',    'Güneş',   '45678901234', '1978-11-30', 'E', '05559990004', 'emre@mail.com'),
('Merve',   'Yıldız',  '56789012345', '2000-07-07', 'K', '05559990005', NULL);
GO

-- Appointments
-- NOT: CHK_FutureDate kısıtı nedeniyle tarihler gelecekte olmalıdır.
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status) VALUES
(1, 1, '2026-05-10', '09:00', 'Scheduled'),   -- Zeynep → Prof.Dr. Ahmet, 09:00
(2, 1, '2026-05-10', '09:30', 'Scheduled'),   -- Burak  → Prof.Dr. Ahmet, 09:30
(3, 2, '2026-05-10', '10:00', 'Scheduled'),   -- Selin  → Dr. Ayşe, 10:00
(4, 3, '2026-05-11', '11:00', 'Scheduled'),   -- Emre   → Doç.Dr. Mehmet, 11:00
(5, 4, '2026-05-11', '14:00', 'Scheduled'),   -- Merve  → Dr. Fatma, 14:00
(1, 5, '2026-05-12', '08:30', 'Scheduled');   -- Zeynep → Prof.Dr. Ali, 08:30
GO

PRINT '>>> Tüm örnek veriler başarıyla eklendi!';
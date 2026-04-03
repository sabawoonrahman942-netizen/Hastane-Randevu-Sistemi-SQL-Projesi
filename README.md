<div align="center">

# 🏥 Hastane Randevu Sistemi
### SQL Server 2025 | T-SQL | Stored Procedures | Transaction

![SQL Server](https://img.shields.io/badge/SQL%20Server-2025%20Express-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-Transact--SQL-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Windows](https://img.shields.io/badge/Windows%2010-x64-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

> T-SQL ile geliştirilmiş, doktor-hasta randevu çakışma kontrolü içeren tam işlevsel hastane veritabanı projesi.

</div>

---

## 🛠️ Teknolojiler

| Teknoloji | Detay |
|:---:|:---|
| **Veritabanı** | Microsoft SQL Server 2025 Express Edition |
| **Sürüm** | `17.0.1000.7 (X64)` — RTM, Oct 21 2025 |
| **İşletim Sistemi** | Windows 10 Home x64 (Build 26200) |
| **SQL Dili** | T-SQL (Transact-SQL) |
| **Yönetim Aracı** | SSMS (SQL Server Management Studio) |

---

## 🗃️ Veritabanı Mimarisi
Departments ──< Doctors ──< Appointments >── Patients

| Tablo | Açıklama | İlişki |
|---|---|---|
| `Departments` | Bölümler (Kardiyoloji, Ortopedi...) | Bağımsız |
| `Doctors` | Doktor bilgileri + unvan | N → 1 Departments |
| `Patients` | Hasta bilgileri + TC Kimlik | Bağımsız |
| `Appointments` | Randevular | N → 1 Doctors, N → 1 Patients |

---

## ⭐ Öne Çıkan Özellikler

### 🔐 Çakışma & Bütünlük Kontrolleri
- ✅ **Composite UNIQUE Constraint** (`DoctorID + AppointmentDate + AppointmentTime`) — Aynı doktor aynı saatte iki randevu alamaz
- ✅ **4 katmanlı kontrol** — Aktif doktor mu? Kayıtlı hasta mı? Saat çakışıyor mu? Aynı gün aynı doktora randevu var mı?
- ✅ **Transaction + TRY-CATCH + ROLLBACK** — Hata durumunda işlem tamamen geri alınır
- ✅ **CHECK Constraint** — Randevu tarihi geçmişte olamaz

### ⚙️ Stored Procedures
| Prosedür | Açıklama |
|---|---|
| `sp_RandevuOlustur` | 4 kontrol + güvenli randevu oluşturma |
| `sp_RandevuIptal` | Hasta doğrulama + iptal işlemi |

### 📊 Sorgular & Raporlama
- ✅ **Boş randevuları listele** — Randevusu olmayan aktif doktorlar
- ✅ **Bir doktorun tüm hastaları** — JOIN ile detaylı hasta listesi
- ✅ **Departman bazlı randevu raporu** — CASE WHEN + GROUP BY
- ✅ **En yoğun doktor** — TOP + ORDER BY

---

## 📁 Dosya Yapısı
📦 hospital-appointment-system-sql

┣ 📜 1_DDL_Veritabani.sql

┣ 📜 2_DDL_Tablolar.sql

┣ 📜 3_DML_OrnekVeriler.sql

┣ 📜 4_T-SQL_View_Prosedurler.sql

┣ 📜 5_Test_Sorgulari.sql

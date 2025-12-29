# Smart Presence - Sistem Absensi Pintar

![Smart Presence](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Laravel](https://img.shields.io/badge/Laravel-10.x-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 📖 Deskripsi

**Smart Presence** adalah aplikasi sistem absensi modern berbasis mobile yang dirancang untuk memudahkan proses pencatatan kehadiran di lingkungan pendidikan. Aplikasi ini menggunakan teknologi **Face Recognition**, **QR Code**, dan **PIN** untuk memberikan fleksibilitas dalam metode absensi.

### 🎯 Tujuan Aplikasi

- Mempermudah proses absensi mahasiswa dengan metode yang modern dan efisien
- Memberikan transparansi data kehadiran real-time untuk dosen dan mahasiswa
- Menyediakan analitik dan statistik kehadiran yang komprehensif
- Mengurangi kecurangan dalam proses absensi dengan teknologi face recognition

## ✨ Fitur Utama

### 👨‍🎓 Fitur Mahasiswa

#### 1. **Multi-Method Attendance**
- **Face Recognition**: Absensi menggunakan pengenalan wajah
- **QR Code Scanner**: Scan QR code yang ditampilkan dosen
- **PIN Code**: Input PIN yang diberikan dosen
- Validasi lokasi dan waktu untuk mencegah kecurangan

#### 2. **Class Management**
- Melihat daftar kelas yang diikuti
- Detail kelas dengan informasi lengkap
- Join kelas baru dengan kode kelas
- Informasi jadwal pertemuan

#### 3. **Attendance History**
- Riwayat absensi lengkap dengan status (Hadir, Izin, Sakit, Alpha)
- Filter berdasarkan tanggal dan kelas
- Detail setiap absensi (waktu, metode, lokasi)
- Status kehadiran dengan visual yang jelas

#### 4. **Dashboard & Statistics**
- Ringkasan kehadiran hari ini
- Statistik kehadiran (Hadir, Terlambat, Izin, Sakit, Alpha)
- Notifikasi sesi absensi aktif
- Quick access ke fitur utama

#### 5. **Profile Management**
- Edit profil (nama, foto, bio)
- Ubah password
- Pengaturan aplikasi
- Informasi akademik

### 👨‍🏫 Fitur Dosen

#### 1. **Class Management**
- Buat kelas baru dengan detail lengkap
- Edit dan hapus kelas
- Lihat daftar mahasiswa per kelas
- Generate kode kelas untuk mahasiswa

#### 2. **Session Control**
- Mulai sesi absensi dengan pilihan metode
- Monitor kehadiran real-time
- Tutup sesi absensi
- Lihat detail mahasiswa yang sudah absen

#### 3. **Attendance Monitoring**
- Monitor kehadiran mahasiswa secara real-time
- Lihat metode absensi yang digunakan
- Validasi kehadiran mahasiswa
- Export data kehadiran

#### 4. **Statistics & Analytics**
- **Attendance Trends**: Grafik tren kehadiran mingguan
- **Class Comparison**: Perbandingan kehadiran antar kelas
- **Student Distribution**: Distribusi kehadiran mahasiswa
- **Attendance Methods**: Statistik metode absensi yang digunakan

#### 5. **Reports**
- Laporan kehadiran per kelas
- Laporan kehadiran per mahasiswa
- Export laporan ke berbagai format
- Statistik kehadiran semester

#### 6. **Dashboard**
- Overview kelas yang diampu
- Sesi absensi aktif
- Statistik kehadiran keseluruhan
- Quick access ke fitur utama

## 🏗️ Arsitektur Aplikasi

### Frontend (Flutter)

```
smart_presence_app/
├── lib/
│   ├── core/                    # Core utilities
│   │   ├── constants/          # API URLs, constants
│   │   ├── models/             # Shared models
│   │   ├── services/           # API services
│   │   └── widgets/            # Shared widgets
│   ├── features/               # Feature modules
│   │   ├── auth/              # Authentication
│   │   ├── home/              # Student home
│   │   ├── classes/           # Class management
│   │   ├── attendance/        # Attendance features
│   │   ├── lecturer/          # Lecturer features
│   │   ├── profile/           # Profile management
│   │   └── notification/      # Notifications
│   ├── routes/                # App routing
│   └── main.dart              # Entry point
```

### Backend (Laravel)

```
smart-presence-backend/
├── app/
│   ├── Http/
│   │   └── Controllers/       # API Controllers
│   │       ├── AuthController.php
│   │       ├── ClassController.php
│   │       ├── AttendanceController.php
│   │       ├── LecturerStatsController.php
│   │       └── ...
│   └── Models/                # Eloquent Models
│       ├── User.php
│       ├── ClassRoom.php
│       ├── Attendance.php
│       └── ...
├── database/
│   ├── migrations/            # Database migrations
│   └── seeders/              # Database seeders
└── routes/
    └── api.php               # API routes
```

## 🛠️ Teknologi yang Digunakan

### Frontend
- **Flutter 3.0+**: Framework mobile cross-platform
- **Provider**: State management
- **fl_chart**: Visualisasi data dengan charts
- **image_picker**: Upload foto profil
- **qr_code_scanner**: Scan QR code
- **shared_preferences**: Local storage
- **http**: HTTP client

### Backend
- **Laravel 10.x**: PHP framework
- **MySQL**: Database
- **JWT**: Authentication
- **Laravel Sanctum**: API authentication
- **Carbon**: Date/time manipulation

## 📱 Screenshots

### Login & Register
- Modern glassmorphism design
- Role selector (Mahasiswa/Dosen)
- Gradient backgrounds
- Form validation

### Student Dashboard
- Today's attendance status
- Quick access menu
- Class list
- Statistics overview

### Lecturer Dashboard
- Active session monitoring
- Class management
- Statistics and reports
- Quick actions

### Attendance Features
- Face recognition interface
- QR code scanner
- PIN input
- Success confirmation

## 🚀 Instalasi

### Prerequisites
- Flutter SDK (3.0+)
- PHP (8.1+)
- Composer
- MySQL
- Android Studio / Xcode (untuk development)

### Backend Setup

```bash
# Clone repository
cd smart-presence-backend

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate app key
php artisan key:generate

# Configure database di .env
DB_DATABASE=smart_presence
DB_USERNAME=root
DB_PASSWORD=

# Run migrations
php artisan migrate

# Seed database (optional)
php artisan db:seed

# Start server
php artisan serve
```

### Frontend Setup

```bash
# Clone repository
cd smart_presence_app

# Install dependencies
flutter pub get

# Configure API URL di lib/core/constants/api_url.dart
# Update baseUrl sesuai server backend Anda

# Run app
flutter run
```

## 🔐 Authentication & Authorization

### User Roles
1. **Mahasiswa**: Akses ke fitur absensi, kelas, dan statistik pribadi
2. **Dosen**: Akses ke manajemen kelas, monitoring, dan statistik kelas

### API Authentication
- Menggunakan Laravel Sanctum untuk token-based authentication
- Token disimpan di SharedPreferences
- Auto-refresh token untuk session management

## 📊 Database Schema

### Users
- id, name, email, password, role, nim, faculty, major

### ClassRooms
- id, name, code, description, lecturer_id, schedule

### ClassSessions
- id, class_id, start_time, end_time, qr_code, pin_code

### Attendances
- id, user_id, session_id, status, method, timestamp, location

## 🎨 Design System

### Colors
- **Primary**: #2563EB (Blue)
- **Secondary**: #6366F1 (Indigo)
- **Success**: #10B981 (Green)
- **Warning**: #F59E0B (Orange)
- **Error**: #EF4444 (Red)

### Typography
- **Font Family**: Poppins, Inter
- **Headings**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Captions**: Medium, 12-14px

### Components
- Glassmorphism cards
- Gradient buttons
- Modern input fields
- Bottom navigation
- Custom charts

## 🔄 API Endpoints

### Authentication
- `POST /api/register` - Register user
- `POST /api/login` - Login user
- `POST /api/logout` - Logout user
- `GET /api/user` - Get current user

### Classes
- `GET /api/classes` - Get user classes
- `POST /api/classes` - Create class (Lecturer)
- `GET /api/classes/{id}` - Get class detail
- `PUT /api/classes/{id}` - Update class (Lecturer)
- `DELETE /api/classes/{id}` - Delete class (Lecturer)

### Attendance
- `POST /api/attendance` - Submit attendance
- `GET /api/attendance/history` - Get attendance history
- `GET /api/attendance/today` - Get today's attendance
- `GET /api/attendance/statistics` - Get attendance stats

### Lecturer
- `POST /api/session/start` - Start session
- `POST /api/session/stop` - Stop session
- `GET /api/session/{id}/attendances` - Monitor session
- `GET /api/lecturer/stats/*` - Get statistics
- `GET /api/lecturer/reports/*` - Get reports

## 🧪 Testing

```bash
# Run Flutter tests
flutter test

# Run Laravel tests
php artisan test
```

## 📈 Roadmap

- [ ] Implementasi Student Statistics Page
- [ ] Push notifications untuk sesi absensi
- [ ] Export laporan ke PDF/Excel
- [ ] Integrasi dengan sistem akademik
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Offline mode untuk absensi

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

- **Developer**: [Your Name]
- **University**: [Your University]
- **Semester**: 7

## 📞 Contact

For any inquiries, please contact:
- Email: [your-email@example.com]
- GitHub: [your-github-username]

---

**Smart Presence** - Making attendance smart and simple! 🎓✨

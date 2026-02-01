# HƯỚNG DẪN CHI TIẾT: Deploy VPS & Build APK

## PHẦN 1: DEPLOY LÊN VPS

### Bước 1: Chuẩn bị VPS
SSH vào VPS và cài Docker:
```bash
# Kết nối SSH
ssh root@103.77.172.239

# Cài Docker (nếu chưa có)
curl -fsSL https://get.docker.com | sh
systemctl start docker
systemctl enable docker

# Cài Docker Compose
apt install docker-compose-plugin -y
# hoặc: apt install docker-compose -y

# Tạo thư mục
mkdir -p /opt/pcm-app
```

### Bước 2: Upload files (3 cách)

#### Cách 1: Dùng FileZilla (DỄ NHẤT)
1. Mở FileZilla
2. Host: `sftp://103.77.172.239`
3. User: `root`, Password: [mật khẩu VPS]
4. Port: `22`
5. Kéo thả các thư mục sau lên `/opt/pcm-app/`:
   - `C:\Users\Admin\Desktop\pcm-app\backend\`
   - `C:\Users\Admin\Desktop\pcm-app\deploy\`
   - `C:\Users\Admin\Desktop\pcm-app\docker-compose.yml`

#### Cách 2: Dùng SCP (PowerShell)
```powershell
# Dừng backend đang chạy trước (Ctrl+C)
cd C:\Users\Admin\Desktop\pcm-app

scp -r backend root@103.77.172.239:/opt/pcm-app/
scp -r deploy root@103.77.172.239:/opt/pcm-app/
scp docker-compose.yml root@103.77.172.239:/opt/pcm-app/
```

#### Cách 3: Dùng Git
```bash
# Trên VPS
cd /opt/pcm-app
git clone https://github.com/your-repo/pcm-app.git .
```

### Bước 3: Chạy deployment trên VPS
```bash
ssh root@103.77.172.239
cd /opt/pcm-app
chmod +x deploy/deploy.sh
./deploy/deploy.sh

# Hoặc chạy manual:
docker-compose up -d
```

### Bước 4: Kiểm tra
```bash
# Xem containers
docker-compose ps

# Xem logs
docker-compose logs -f

# Test API
curl http://localhost:5000/api/courts
```

---

## PHẦN 2: BUILD APK ANDROID

### Yêu cầu: Cài Java 17
APK yêu cầu Java 11+, nhưng hệ thống bạn có Java 8.

#### Cách cài Java 17:
1. Tải từ: https://adoptium.net/temurin/releases/
   - Chọn: Windows x64, JDK, version 17
2. Cài đặt và restart máy
3. Kiểm tra: `java -version` (phải hiện 17.x.x)

### Build APK sau khi có Java 17:
```powershell
cd C:\Users\Admin\Desktop\pcm-app\mobile

# Build APK release
flutter build apk --release

# Output tại: build\app\outputs\flutter-apk\app-release.apk
```

### Copy APK lên VPS:
```powershell
# Copy APK vào thư mục downloads
scp build\app\outputs\flutter-apk\app-release.apk root@103.77.172.239:/opt/pcm-app/deploy/downloads/pcm.apk
```

### Link tải APK:
```
http://caothuvot.duckdns.org/download/pcm.apk
```

---

## PHẦN 3: URLS SAU KHI DEPLOY

| Dịch vụ | URL |
|---------|-----|
| Web App | http://caothuvot.duckdns.org |
| API | http://caothuvot.duckdns.org/api |
| Swagger | http://caothuvot.duckdns.org/swagger |
| Download APK | http://caothuvot.duckdns.org/download/pcm.apk |

---

## TROUBLESHOOTING

### SSH Connection Timeout
```bash
# Kiểm tra VPS có online không
ping 103.77.172.239

# Nếu bị block port 22, dùng VPS console từ provider
```

### Docker not starting
```bash
systemctl start docker
docker-compose up -d
```

### Database error
```bash
# Đợi SQL Server khởi động (30-60s)
docker-compose logs sqlserver
docker-compose restart pcm-api
```

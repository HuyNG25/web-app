# 🟦 CHƯƠNG 27
# **XUẤT BẢN APP LÊN WEB (FLUTTER WEB)**
*(Firebase Hosting – GitHub Pages – Vercel)*

Flutter không chỉ chạy trên điện thoại. Với **1 câu lệnh**, bạn có thể biến app của mình thành một trang web.
Chương này hướng dẫn bạn cách build và đưa app lên Internet để ai cũng có thể truy cập.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Build được bản release cho Web.
- Deploy lên **Firebase Hosting** (Chuẩn Google, tốc độ cao).
- Deploy lên **GitHub Pages** (Miễn phí, tiện lợi).
- Deploy lên **Vercel** (Kéo thả siêu nhanh).
- Hiểu về 2 chế độ render: **CanvasKit** vs **HTML**.
- Nắm được **quy trình xuất bản** lên Google Play Store và Apple App Store.
- Hiểu rõ **chi phí** và **thời gian duyệt** của từng nền tảng.

---

# 1. **Build bản Web Release**

Mặc định khi tạo dự án Flutter mới, Web đã được hỗ trợ sẵn.

Lệnh build cơ bản:

```bash
flutter build web --release
```

Kết quả sẽ nằm trong thư mục: `build/web/`.
Đây là toàn bộ source code trang web của bạn (HTML, JS, CSS, Assets). Bạn có thể copy thư mục này bỏ vào bất kỳ Web Server nào là chạy được.

---

# 2. **Deploy lên Firebase Hosting (Khuyên dùng)**

Đây là cách chuyên nghiệp và ổn định nhất.

### Bước 1: Cài đặt Firebase CLI (nếu chưa có)

```bash
npm install -g firebase-tools
```

### Bước 2: Đăng nhập & Khởi tạo

Tại thư mục gốc dự án Flutter:

```bash
firebase login
firebase init hosting
```

Chọn các tùy chọn sau:
1. **What do you want to use as your public directory?**
   👉 Gõ: `build/web` (Quan trọng!)
2. **Configure as a single-page app?**
   👉 Chọn: `Yes` (Để hỗ trợ routing của Flutter)
3. **Set up automatic builds and deploys with GitHub?**
   👉 Chọn: `No` (Làm sau nếu cần)

### Bước 3: Build & Deploy

Chạy lệnh sau mỗi khi muốn cập nhật web:

```bash
flutter build web --release
firebase deploy
```

Kết quả: Bạn sẽ nhận được link dạng `https://your-project.web.app`.

---

# 3. **Deploy lên GitHub Pages (Miễn phí)**

Phù hợp để demo, portfolio cá nhân.

### Bước 1: Build với base-href

Vì GitHub Pages thường có dạng `user.github.io/repo-name/`, nên bạn cần chỉ định đường dẫn gốc.

```bash
# Thay 'ten-repo' bằng tên repository của bạn
flutter build web --base-href "/ten-repo/" --release
```

### Bước 2: Upload lên nhánh gh-pages

Cách dễ nhất là dùng thư viện `gh-pages` (cần cài Node.js):

1. Vào thư mục `build/web`:
   ```bash
   cd build/web
   ```
2. Khởi tạo git và push (nếu làm thủ công):
   ```bash
   git init
   git remote add origin https://github.com/user/ten-repo.git
   git add .
   git commit -m "Deploy"
   git branch -M main
   git push -u origin main --force
   ```
   *(Lưu ý: Git Pages cần được bật trong Settings của repo, trỏ vào nhánh bạn vừa push)*.

---

# 4. **Deploy lên Vercel (Siêu nhanh - Kéo thả)**

Cách này nhanh nhất, không cần lệnh dòng lệnh phức tạp.

1. Chạy `flutter build web --release`.
2. Vào [vercel.com](https://vercel.com) đăng nhập.
3. Chọn "Add New Project".
4. Kéo thả thư mục `build/web` vào màn hình.
5. Bấm Deploy. Xong!

---

# 5. **Tối ưu hiệu năng: HTML vs CanvasKit**

Flutter Web có 2 chế độ render:

### 1. **CanvasKit (Mặc định trên Desktop)**
- **Ưu điểm**: Giống hệt app mobile, font chữ chuẩn, hiệu năng cao.
- **Nhược điểm**: Tải file `canvaskit.wasm` nặng (~2MB) lúc đầu → Web load chậm lần đầu.

### 2. **HTML Renderer (Mặc định trên Mobile)**
- **Ưu điểm**: File siêu nhẹ, load nhanh.
- **Nhược điểm**: Có thể bị lệch font, một số hiệu ứng không mượt bằng CanvasKit.

### 🧠 Cách ép dùng HTML để load nhanh (khuyên dùng cho Web đơn giản):

```bash
flutter build web --web-renderer html --release
```

Nếu muốn đẹp nhất (mặc định):
```bash
flutter build web --web-renderer canvaskit --release
```

Hoặc tự động (HTML cho mobile, CanvasKit cho PC):
```bash
flutter build web --web-renderer auto --release
```

---

# 6. **Lỗi thường gặp (CORS)**

Khi chạy Web, nếu bạn load ảnh từ server khác (ví dụ `picsum.photos` hay API riêng), bạn có thể gặp lỗi không hiện ảnh.
Đó là lỗi **CORS** (Cross-Origin Resource Sharing).

**Cách sửa:**
- **Cách 1**: Dùng thẻ `HTML Renderer` (thường ít bị hơn).
- **Cách 2**: Cấu hình server API cho phép CORS (Access-Control-Allow-Origin: *).
- **Cách 3**: Khi debug, chạy lệnh:
  ```bash
  flutter run -d chrome --web-browser-flag "--disable-web-security"
  ```
  *(Lưu ý: Cách 3 chỉ dùng để debug, không dùng cho production)*.

---

# 7. **Xuất bản ứng dụng lên App Store**

Sau khi phát triển xong app, bạn cần đưa nó lên **Google Play Store** (Android) và **Apple App Store** (iOS) để người dùng có thể tải về.

---

## 📱 **7.1. Xuất bản lên Google Play Store**

### 💰 **Chi phí:**
- **Phí đăng ký tài khoản Developer**: **$25 USD một lần duy nhất** (trả một lần, không phải hàng năm)
- **Phí duy trì**: Không có (miễn phí vĩnh viễn sau khi đăng ký)
- **Phí cho mỗi app**: Miễn phí (không giới hạn số lượng app)

### 📋 **Quy trình chi tiết:**

#### **Bước 1: Tạo tài khoản Google Play Developer**

1. Truy cập: https://play.google.com/console
2. Đăng nhập bằng tài khoản Google
3. Thanh toán **$25 USD** (một lần duy nhất)
4. Điền thông tin cá nhân/công ty (tên, địa chỉ, số điện thoại)
5. Chấp nhận điều khoản

**⏱️ Thời gian xử lý**: 1-2 ngày làm việc

#### **Bước 2: Chuẩn bị ứng dụng Android**

1. **Build APK/AAB (Android App Bundle - khuyên dùng):**
   ```bash
   flutter build appbundle --release
   ```
   File sẽ nằm tại: `build/app/outputs/bundle/release/app-release.aab`

2. **Cấu hình `android/app/build.gradle`:**
   - Đảm bảo `versionCode` và `versionName` đã được set
   - Kiểm tra `applicationId` (package name) là duy nhất

3. **Tạo icon và ảnh mô tả:**
   - Icon app: 512x512 px (PNG, không trong suốt)
   - Screenshots: Tối thiểu 2 ảnh (tối đa 8 ảnh)
   - Feature graphic: 1024x500 px (banner quảng cáo)

#### **Bước 3: Tạo ứng dụng trên Google Play Console**

1. Vào **Play Console** → **Tạo ứng dụng**
2. Điền thông tin:
   - **Tên ứng dụng** (tối đa 50 ký tự)
   - **Ngôn ngữ mặc định**
   - **Loại ứng dụng** (App hoặc Game)
   - **Miễn phí hay trả phí**

#### **Bước 4: Điền thông tin chi tiết**

1. **Nội dung ứng dụng:**
   - Mô tả ngắn (80 ký tự)
   - Mô tả đầy đủ (4000 ký tự)
   - Screenshots (tối thiểu 2 ảnh)
   - Icon và Feature graphic

2. **Phân loại và thông tin:**
   - Chọn danh mục (Ví dụ: Education, Entertainment...)
   - Đánh giá nội dung (PEGI, ESRB...)
   - Website và email hỗ trợ

3. **Giá và phân phối:**
   - Chọn quốc gia phân phối
   - Chọn miễn phí hoặc đặt giá

#### **Bước 5: Tải file AAB lên**

1. Vào **Sản xuất** → **Phát hành** → **Tạo phiên bản mới**
2. Tải file `app-release.aab` lên
3. Điền **Ghi chú phát hành** (mô tả những gì mới trong phiên bản này)
4. Bấm **Lưu**

#### **Bước 6: Xem xét và phát hành**

1. Google sẽ **tự động kiểm tra** app (thường 1-3 ngày)
2. Nếu có vấn đề, Google sẽ gửi email yêu cầu sửa
3. Sau khi duyệt xong, app sẽ **tự động xuất hiện trên Play Store**

**⏱️ Thời gian duyệt**: 1-7 ngày (thường 1-3 ngày)

---

## 🍎 **7.2. Xuất bản lên Apple App Store**

### 💰 **Chi phí:**
- **Phí đăng ký tài khoản Developer**: **$99 USD/năm** (phải gia hạn hàng năm)
- **Phí duy trì**: $99 USD/năm (nếu không gia hạn, app sẽ bị gỡ)
- **Phí cho mỗi app**: Miễn phí (không giới hạn số lượng app)

**⚠️ Lưu ý**: Cần có **Mac** để build iOS (hoặc dùng dịch vụ cloud build như Codemagic, AppCircle)

### 📋 **Quy trình chi tiết:**

#### **Bước 1: Tạo tài khoản Apple Developer**

1. Truy cập: https://developer.apple.com/programs/
2. Đăng nhập bằng Apple ID
3. Thanh toán **$99 USD/năm**
4. Điền thông tin cá nhân/công ty
5. Chấp nhận điều khoản

**⏱️ Thời gian xử lý**: 1-2 ngày làm việc

#### **Bước 2: Cài đặt Xcode (chỉ trên macOS)**

1. Tải Xcode từ **App Store** (miễn phí, nhưng nặng ~15GB)
2. Mở Xcode → **Preferences → Accounts**
3. Thêm Apple ID của bạn
4. Chọn team Developer

#### **Bước 3: Cấu hình iOS trong Flutter**

1. **Mở file `ios/Runner.xcworkspace` trong Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Cấu hình Bundle Identifier:**
   - Chọn **Runner** → **Signing & Capabilities**
   - Đặt **Bundle Identifier** (ví dụ: `com.yourcompany.appname`)
   - Chọn **Team** (tài khoản Developer của bạn)
   - Xcode sẽ tự tạo **Provisioning Profile**

3. **Tăng version:**
   - **Version**: 1.0.0 (hiển thị cho người dùng)
   - **Build**: 1 (số tăng dần mỗi lần upload)

#### **Bước 4: Build IPA (iOS App Archive)**

1. **Build release:**
   ```bash
   flutter build ios --release
   ```

2. **Tạo Archive trong Xcode:**
   - Mở `ios/Runner.xcworkspace` trong Xcode
   - Chọn **Product → Archive**
   - Đợi build xong (5-10 phút)

3. **Upload lên App Store Connect:**
   - Trong cửa sổ **Organizer** (hiện tự động sau khi Archive)
   - Chọn Archive vừa tạo → **Distribute App**
   - Chọn **App Store Connect** → **Upload**
   - Điền thông tin → **Upload**

**⏱️ Thời gian upload**: 10-30 phút (tùy kích thước app)

#### **Bước 5: Tạo ứng dụng trên App Store Connect**

1. Truy cập: https://appstoreconnect.apple.com
2. Vào **My Apps** → **+** (Tạo app mới)
3. Điền thông tin:
   - **Tên** (tối đa 30 ký tự)
   - **Ngôn ngữ chính**
   - **Bundle ID** (phải khớp với Bundle Identifier trong Xcode)
   - **SKU** (mã định danh nội bộ, không hiển thị công khai)

#### **Bước 6: Điền thông tin chi tiết**

1. **Thông tin ứng dụng:**
   - Mô tả ngắn (170 ký tự)
   - Mô tả đầy đủ (4000 ký tự)
   - Keywords (100 ký tự, dùng dấu phẩy)
   - Website và email hỗ trợ

2. **Ảnh và video:**
   - Icon app: 1024x1024 px (PNG, không trong suốt)
   - Screenshots: Tối thiểu 1 ảnh cho mỗi kích thước thiết bị
     - iPhone 6.7" (1290x2796)
     - iPhone 6.5" (1242x2688)
     - iPad Pro 12.9" (2048x2732)
   - Video preview (tùy chọn, tối đa 30 giây)

3. **Giá và tính khả dụng:**
   - Chọn **Miễn phí** hoặc đặt giá
   - Chọn quốc gia phân phối

#### **Bước 7: Gửi để xem xét**

1. Vào **TestFlight** (nếu muốn test trước) hoặc **App Store** tab
2. Chọn **+ Version or Platform**
3. Chọn build đã upload (sau khi xử lý xong)
4. Điền **Ghi chú cho người xem xét** (mô tả app, tài khoản test nếu cần)
5. Bấm **Gửi để xem xét**

#### **Bước 8: Chờ duyệt**

1. Apple sẽ **kiểm tra thủ công** (thường 1-7 ngày)
2. Nếu có vấn đề, Apple sẽ gửi email yêu cầu sửa
3. Sau khi duyệt, app sẽ **tự động xuất hiện trên App Store**

**⏱️ Thời gian duyệt**: 1-7 ngày (thường 2-3 ngày)

---

## 📊 **7.3. So sánh chi phí và thời gian**

| Tiêu chí | Google Play Store | Apple App Store |
|----------|-------------------|-----------------|
| **Phí đăng ký** | $25 USD (một lần) | $99 USD/năm |
| **Phí duy trì** | Miễn phí | $99 USD/năm |
| **Thời gian duyệt** | 1-3 ngày | 2-7 ngày |
| **Yêu cầu thiết bị** | Windows/Mac/Linux | Mac (bắt buộc) |
| **Độ khó** | Dễ | Khó hơn (cần Mac) |
| **Tỷ lệ từ chối** | Thấp | Cao hơn (yêu cầu nghiêm ngặt) |

---

## 💡 **7.4. Mẹo và lưu ý**

### **Cho Google Play Store:**
- ✅ Dùng **AAB** thay vì APK (nhẹ hơn, tối ưu hơn)
- ✅ Test app trên nhiều thiết bị trước khi submit
- ✅ Chuẩn bị đầy đủ ảnh mô tả (screenshots, icon)
- ✅ Đọc kỹ [Chính sách nội dung](https://play.google.com/about/developer-content-policy/) của Google

### **Cho Apple App Store:**
- ✅ Test kỹ trên **TestFlight** trước khi submit
- ✅ Đảm bảo app tuân thủ [Hướng dẫn xem xét](https://developer.apple.com/app-store/review/guidelines/)
- ✅ Chuẩn bị ảnh cho **nhiều kích thước màn hình** (iPhone, iPad)
- ✅ Nếu app cần quyền đặc biệt (camera, location...), giải thích rõ trong mô tả

### **Chung:**
- ✅ **Version code/version name** phải tăng dần mỗi lần update
- ✅ **Bundle ID/Package name** không thể thay đổi sau khi publish
- ✅ Chuẩn bị **Privacy Policy** (bắt buộc nếu app thu thập dữ liệu)
- ✅ Cập nhật app thường xuyên để giữ người dùng

---

# 🧠 Tổng kết

## **Cho Web:**
- Dùng **Firebase Hosting** cho sản phẩm thật (Production).
- Dùng **GitHub Pages** cho demo miễn phí.
- Dùng **`--web-renderer html`** nếu muốn web load nhanh.
- Luôn nhớ lệnh thần thánh: `flutter build web --release`.

## **Cho App Store:**
- **Google Play**: $25 một lần, dễ hơn, duyệt nhanh hơn.
- **Apple App Store**: $99/năm, cần Mac, duyệt lâu hơn nhưng chất lượng cao.
- Luôn test kỹ trước khi submit, chuẩn bị đầy đủ ảnh và mô tả.
- Build release: `flutter build appbundle` (Android) và `flutter build ios --release` (iOS).

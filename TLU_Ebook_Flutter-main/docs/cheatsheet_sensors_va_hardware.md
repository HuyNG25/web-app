# 📄 CHEATSHEET: CÁC LOẠI CẢM BIẾN (MOBILE & IOT)

Tài liệu này tổng hợp danh sách các loại cảm biến phổ biến nhất mà lập trình viên Mobile có thể tiếp cận để xây dựng ứng dụng thông minh.

---

## 📱 PHẦN 1: CẢM BIẾN TÍCH HỢP TRÊN ĐIỆN THOẠI (INTERNAL SENSORS)

Đây là các cảm biến có sẵn trên smartphone. Bạn có thể dùng ngay mà không tốn chi phí phần cứng.

| Tên Cảm Biến | Loại | Nguyên Lý Hoạt Động (Cơ bản) | Thư viện Flutter | Ý Tưởng Ứng Dụng (App Idea) |
| :--- | :--- | :--- | :--- | :--- |
| **Accelerometer** (Gia tốc kế) | Motion | Đo lực quán tính tác động lên vật thể theo 3 trục (X,Y,Z). Sử dụng cơ chế khối nặng treo (MEMS) thay đổi điện dung khi di chuyển. | `sensors_plus` | 1. Đếm bước chân (Step Counter).<br>2. Phát hiện ngã (Fall Detection) cho người già.<br>3. Game lắc điện thoại. |
| **Gyroscope** (Con quay hồi chuyển) | Motion | Đo tốc độ góc (độ xoay) dựa trên lực Coriolis. Nhạy hơn Accelerometer khi xác định hướng xoay. | `sensors_plus` | 1. Game đua xe (nghiêng máy lái xe).<br>2. Xem ảnh 360 độ / VR.<br>3. Chống rung Camera. |
| **Magnetometer** (Từ kế) | Position | Đo từ trường Trái đất dựa trên hiệu ứng Hall. | `sensors_plus` | 1. La bàn số (Digital Compass).<br>2. Máy dò kim loại (Metal Detector).<br>3. Bản đồ chỉ đường AR. |
| **GPS / GNSS** | Position | Tính toán thời gian tín hiệu từ >4 vệ tinh để suy ra tọa độ (Kinh độ, Vĩ độ). | `geolocator` | 1. Ứng dụng chạy bộ (Tracking Route).<br>2. Tìm quán ăn gần đây.<br>3. Điểm danh theo vị trí. |
| **Light Sensor** | Env | Sử dụng Photodiode chuyển ánh sáng thành dòng điện. | `light_sensor` | 1. Tự động bật Dark Mode khi trời tối.<br>2. Đo cường độ sáng phòng học. |
| **Proximity** (Tiệm cận) | Env | Phát tia hồng ngoại (IR) và đo tín hiệu phản xạ để biết có vật cản gần màn hình hay không. | `proximity_sensor` | 1. Tự tắt màn hình khi áp tai nghe gọi.<br>2. Chống chạm nhầm khi bỏ túi (`Pocket Mode`). |
| **Biometric** (Vân tay/FaceID) | Security | Quét mẫu vân tay hoặc geometry khuôn mặt 3D. | `local_auth` | 1. Đăng nhập ngân hàng.<br>2. Khóa ghi chú bí mật. |
| **Barometer** (Áp kế) | Env | Đo áp suất khí quyển. Áp suất giảm thì độ cao tăng. | `sensors_plus` | 1. Đo độ cao leo núi (Altimeter).<br>2. Dự báo thời tiết (áp suất giảm nhanh = bão). |

---

## 🛠️ PHẦN 2: CẢM BIẾN IOT NGOẠI VI (EXTERNAL SENSORS)

Dành cho các ứng dụng kết nối phần cứng. Yêu cầu mua thêm module và vi điều khiển (ESP8266/ESP32).

> **Lưu ý:** Giá tham khảo là giá thị trường VN (Shopee/Linhkien), có thể thay đổi.
> **Cách kết nối:** Sensor -> ESP8266/32 -> Firebase/MQTT -> Mobile App.

### 2.1. Nhóm Môi trường (Environment) - Giá Rẻ

| Tên Module | Chức năng | Nguyên lý | Giá Tham Khảo | Thư viện Flutter (Kết nối) | Ứng dụng |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **DHT11 / DHT22** | Nhiệt độ & Độ ẩm | Dùng điện trở nhiệt (Thermistor) để đo nhiệt. | **~25k - 70k** | `mqtt_client` / `firebase_database` | 1. Theo dõi nhiệt độ phòng server.<br>2. Vườn lan tự động. |
| **Soil Moisture** | Độ ẩm đất | Đo độ dẫn điện của đất (Đất ẩm dẫn điện tốt hơn đất khô). | **~15k** | (nt) | 1. Tưới cây tự động khi đất khô. |
| **Rain Sensor** | Cảm biến mưa | Mạch in zíc-zắc, khi có nước mưa dính vào sẽ dẫn điện. | **~15k** | (nt) | 1. Tự động đóng rèm/cửa sổ khi mưa. |
| **LDR (Quang trở)** | Ánh sáng | Điện trở thay đổi theo ánh sáng (Sáng mạnh -> Trở kháng giảm). | **~5k** | (nt) | 1. Đèn đường tự bật ban đêm. |

### 2.2. Nhóm An ninh & An toàn (Security & Safety)

| Tên Module | Chức năng | Nguyên lý | Giá Tham Khảo | Thư viện Flutter | Ứng dụng |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **PIR (HC-SR501)** | Chuyển động người | Phát hiện sự thay đổi bức xạ hồng ngoại tỏa ra từ cơ thể người. | **~25k** | `firebase_messaging` (Push Noti) | 1. Báo trộm đột nhập.<br>2. Đèn cầu thang thông minh. |
| **HC-SR04** | Siêu âm (Khoảng cách) | Phát sóng siêu âm và đo thời gian sóng phản xạ về ($d = v \times t / 2$). | **~20k** | (nt) | 1. Cảnh báo lùi xe.<br>2. Thùng rác thông minh. |
| **MQ-2** | Khói & Gas | Dùng chất bán dẫn thiếc oxit (SnO2), độ dẫn điện tăng khi có khí gas/khói. | **~35k** | (nt) | 1. Cảnh báo cháy sớm.<br>2. Cảnh báo rò rỉ gas. |
| **Reed Switch** | Cảm biến từ cửa | Công tắc lưỡi gà đóng/mở khi có nam châm lại gần. | **~15k** | (nt) | 1. Báo đóng/mở cửa (Door Sensor). |

### 2.3. Nhóm Y tế (Health) - Giá Trung Bình

| Tên Module | Chức năng | Nguyên lý | Giá Tham Khảo | Ứng dụng |
| :--- | :--- | :--- | :--- | :--- |
| **MAX30100/30102** | Nhịp tim & Oxy máu (SpO2) | Chiếu tia LED đỏ và hồng ngoại qua ngón tay, đo độ hấp thụ ánh sáng của máu. | **~70k - 150k** | 1. Máy đo sức khỏe cá nhân.<br>2. Cảnh báo COVID (SpO2 thấp). |
| **Mạch EMG (MyoWare)** | Điện cơ bắp | Đo tín hiệu điện sinh ra khi cơ bắp co giãn. | **~800k (Đắt)** | 1. Điều khiển cánh tay robot bằng cơ bắp.<br>2. Game tập thể dục. |

---

## 📡 PHẦN 3: GIAO THỨC KẾT NỐI (CONNECTIVITY CHEATSHEET)

Chọn giao thức nào cho App của bạn?

| Giao thức | Khoảng cách | Tốc độ | Pin (Thiết bị) | Thư viện Flutter | Khi nào dùng? |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Wifi (HTTP/MQTT)** | Không giới hạn (qua Internet) | Cao | Tốn pin | `http` / `mqtt_client` | Điều khiển Smart Home từ xa, Camera, Truyền dữ liệu lớn. |
| **Bluetooth (BLE)** | Gần (< 10-20m) | Thấp | Rất ít pin | `flutter_blue_plus` | Khóa cửa, Smartwatch, Cảm biến sức khỏe đeo tay. |
| **NFC** | Rất gần (< 4cm) | Thấp | Không tốn pin (Passive tag) | `nfc_manager` | Thanh toán, Check-in vé điện tử, Quẹt thẻ thông minh. |

---

## 💡 PHẦN 4: Ý TƯỞNG CẤP ĐỘ CAO - SỰ KẾT HỢP (SENSOR FUSION)

Các ứng dụng "triệu đô" thường không chỉ dùng 1 cảm biến, mà kết hợp nhiều loại để giải quyết bài toán phức tạp.

### 4.1. Hệ thống Chăm sóc Người cao tuổi (Elderly Care System)
*   **Vấn đề:** Người già ở một mình, dễ bị ngã hoặc đột quỵ không ai biết.
*   **Combo Cảm biến:**
    1.  **Accelerometer (Trên điện thoại/Đồng hồ):** Phát hiện cú ngã (Gia tốc biến thiên đột ngột > 3G).
    2.  **Heart Rate (MAX30102 - Đeo tay):** Đo nhịp tim bất thường.
    3.  **GPS (Điện thoại):** Xác định vị trí nếu họ đi lạc (bệnh Alzheimer).
    4.  **SOS Button (Nút cứng):** Gửi cảnh báo khẩn cấp.
*   **Logic App:**
    > IF (Gia tốc > Ngưỡng Ngã) AND (Nhịp tim > 120 hoặc < 50) 
    > THEN -> Gửi SMS + Tọa độ GPS cho người thân + Gọi cấp cứu.

### 4.2. Hộp Giao hàng Thông minh (Smart Logistics Box)
*   **Vấn đề:** Giao hàng dễ bị vỡ (do quăng quật), bị mất trộm hoặc bị mở xem trộm.
*   **Combo Cảm biến:**
    1.  **Shock Sensor (Rung):** Ghi lại log những lần thùng hàng bị ném mạnh.
    2.  **Light Sensor (LDR):** Đặt trong hộp kín. Nếu cảm biến thấy ánh sáng -> Hộp đã bị mở trái phép.
    3.  **GPS:** Theo dõi lộ trình xe hàng.
    4.  **DHT11:** Đảm bảo thực phẩm/vac-xin không bị quá nóng.
*   **Logic App:**
    > Khách hàng mở App quét QR -> Xem lịch sử hành trình.
    > App báo đỏ: "Cảnh báo! Hàng đã bị mở lúc 14:00 tại vị trí X, và bị ném mạnh 3 lần."

### 4.3. Nông nghiệp 4.0 (Smart Farm)
*   **Vấn đề:** Tối ưu năng suất cây trồng, giảm công chăm sóc.
*   **Combo Cảm biến:**
    1.  **Soil Moisture:** Đo độ ẩm đất.
    2.  **Rain Sensor:** Phát hiện trời mưa.
    3.  **Light Sensor:** Đo cường độ nắng.
    4.  **Relay:** Điều khiển máy bơm và motor mái che.
*   **Logic App:**
    > IF (Đất khô) AND (Không mưa) -> Bật máy bơm.
    > IF (Trời quá nắng) -> Kéo mái che râm mát.
    > IF (Trời mưa to) -> Đóng mái che để tránh úng.

### 4.4. Phòng học/Văn phòng Thông minh (Smart Office)
*   **Vấn đề:** Tiết kiệm điện năng lãng phí.
*   **Combo Cảm biến:**
    1.  **PIR Motion:** Phát hiện có người trong phòng không.
    2.  **Light Sensor:** Đo ánh sáng tự nhiên.
    3.  **DHT11:** Đo nhiệt độ.
    4.  **Relay:** Điều khiển đèn/điều hòa.
*   **Logic App:**
    > IF (Không có chuyển động trong 15p) -> Tắt hết đèn + Máy lạnh.
    > IF (Có người) AND (Trời sáng) -> Tắt đèn, mở rèm.
    > IF (Có người) AND (Trời tối) -> Bật đèn.
    > IF (Nhiệt độ > 28 độ) -> Bật điều hòa 25 độ.

---
> *   Để làm đồ án rẻ nhất: Chọn **Wifi (ESP8266) + Firebase Realtime DB**. (Dễ code, không cần cấu hình Server riêng).
> *   Để làm đồ án "ngầu" nhất: Chọn **Xử lý ảnh AI (ESP32-CAM)** hoặc **Điều khiển bằng giọng nói** (kết hợp Google Assistant).


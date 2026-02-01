# 🟦 CHƯƠNG 23: LẬP TRÌNH MOBILE APP VỚI IOT (INTERNET OF THINGS)

> **Mục tiêu:**
> 1. Hiểu cách Mobile App kết nối với thế giới vật lý (Phần cứng).
> 2. Nắm được các linh kiện IoT "ngon-bổ-rẻ" để sinh viên có thể tự mua và thực hành.
> 3. Lên ý tưởng cho các dự án IoT thực tế (Smart Home, Nông nghiệp thông minh).

---

## 23.1. Mobile App trong hệ sinh thái IoT

Trong một hệ thống IoT, Mobile App đóng vai trò là **Dashboard (Bảng điều khiển)** và **Controller (Bộ điều khiển)**.

**Mô hình kết nối phổ biến:**
1.  **Kết nối trực tiếp (Direct Connection):**
    *   *Giao thức:* Bluetooth Low Energy (BLE).
    *   *Ứng dụng:* Điều khiển khóa cửa, cấu hình thiết bị (như cài Wifi cho camera), đồng hồ thông minh.
    *   *Ưu điểm:* Không cần Internet, bảo mật tốt.
    *   *Nhược điểm:* Phải đứng gần (< 10m).
2.  **Kết nối qua Cloud (Cloud Connection):**
    *   *Giao thức:* MQTT, HTTP, WebSocket.
    *   *Mô hình:* Thiết bị -> Wifi -> Cloud Server (Firebase/MQTT Broker) -> Mobile App.
    *   *Ứng dụng:* Nhà thông minh (điều khiển từ xa), Giám sát vườn cây.
    *   *Ưu điểm:* Điều khiển từ bất cứ đâu.

---

## 23.2. "Shopping List" - Linh kiện IoT Giá Rẻ cho Sinh Viên

Để bắt đầu, bạn không cần thiết bị đắt tiền. Dưới đây là danh sách các module phổ biến, giá cực rẻ (tính theo giá thị trường Việt Nam) để làm đồ án.

### 1. "Bộ não" - Vi điều khiển (Microcontroller)
Thay vì dùng Arduino (cũ, không có Wifi), hãy dùng dòng **ESP**.

| Tên linh kiện | Đặc điểm | Giá tham khảo | Ứng dụng |
| :--- | :--- | :--- | :--- |
| **ESP8266 (NodeMCU)** | Có sẵn Wifi. Code dễ như Arduino. Nhỏ gọn. | **~80.000đ** | Công tắt Wifi, Cảm biến đơn giản. |
| **ESP32** | Có cả **Wifi + Bluetooth**. Mạnh hơn ESP8266 (2 nhân). | **~120.000đ** | Xử lý Camera, Stream video, BLE App. |

### 2. Các loại Cảm biến (Input Sensors)

| Tên linh kiện | Chức năng | Giá tham khảo | Ứng dụng thực tế |
| :--- | :--- | :--- | :--- |
| **DHT11 / DHT22** | Đo nhiệt độ & Độ ẩm không khí. | **~25.000đ** | Trạm khí tượng mini, kho lạnh. |
| **HC-SR04** | Cảm biến siêu âm (đo khoảng cách). | **~20.000đ** | Thùng rác thông minh (tự mở nắp), Cảnh báo chống trộm, Đo mực nước. |
| **MQ-2 / MQ-135** | Cảm biến Khí Gas, Khói, Chất lượng không khí. | **~35.000đ** | Báo cháy, Báo rò rỉ Gas nhà bếp. |
| **Moisture Sensor** | Cảm biến độ ẩm đất. | **~15.000đ** | Hệ thống tưới cây tự động. |
| **PIR (HC-SR501)** | Cảm biến hồng ngoại (phát hiện người). | **~25.000đ** | Đèn cầu thang tự bật khi có người. |
| **LDR (Quang trở)** | Cảm biến ánh sáng. | **~5.000đ** | Đèn đường tự bật khi trời tối. |

### 3. Thiết bị Chấp hành (Output Actuators)

| Tên linh kiện | Chức năng | Giá tham khảo | Ứng dụng thực tế |
| :--- | :--- | :--- | :--- |
| **Module Relay** | Công tắc điện tử (đóng ngắt dòng điện 220V). | **~15.000đ** | Bật tắt đèn, quạt, máy bơm qua App. |
| **Servo Motor (SG90)** | Động cơ bước nhỏ (quay góc 0-180 độ). | **~35.000đ** | Khóa cửa thông minh, Cánh tay robot. |
| **Buzzer** | Còi chíp báo động. | **~5.000đ** | Còi báo trộm, báo cháy. |

> **Tổng chi phí:** Chỉ với khoảng **200.000đ - 300.000đ**, bạn đã có trọn bộ Combo (ESP + Cảm biến + Dây cắm) để làm Đồ án Mobile IoT xịn xò.

---

## 23.3. Các Dự án Gợi ý (App Ideas)

### Dự án 1: Vườn Cây Thông Minh (Smart Garden)
*   **Phần cứng:** ESP8266 + Cảm biến độ ẩm đất + Relay (nối máy bơm mini).
*   **Mobile App:**
    *   Hiển thị biểu đồ độ ẩm đất theo thời gian thực (Realtime Chart).
    *   Nút "Tưới Ngay" (Gửi lệnh xuống ESP để đóng Relay).
    *   Cài đặt lịch tưới tự động.

### Dự án 2: Nhà Bếp An Toàn (Gas Safety)
*   **Phần cứng:** ESP8266 + Cảm biến Gas (MQ-2) + Còi (Buzzer).
*   **Mobile App:**
    *   Nhận thông báo Push Notification (FCM) ngay lập tức khi phát hiện rò khí Gas.
    *   Hiển thị nồng độ khí Gas hiện tại.

### Dự án 3: Khóa Cửa Bluetooth (Smart Lock)
*   **Phần cứng:** ESP32 (dùng Bluetooth) + Động cơ Servo (gạt chốt cửa).
*   **Mobile App:**
    *   Tự động kết nối khi điện thoại đến gần cửa (< 2m).
    *   Mở khóa bằng Vân tay (Biometric) trên điện thoại -> Gửi lệnh mở khóa xuống ESP32.

---

## 23.4. Giao thức kết nối & Thư viện Flutter

### 1. MQTT (Message Queuing Telemetry Transport)
Đây là "ngôn ngữ chung" của IoT. Nhẹ, nhanh, tiết kiệm băng thông.
*   **Cơ chế:** Publish/Subscribe (Xuất bản/Đăng ký).
*   Thư viện Flutter: `mqtt_client`.
*   Broker miễn phí để test: `test.mosquitto.org` hoặc `hivemq`.

### 2. Firebase Realtime Database
Cách dễ nhất cho sinh viên Mobile (vì đã quen Firebase).
*   **Cơ chế:** ESP8266 dùng thư viện `Firebase-ESP8266` để ghi dữ liệu lên Realtime DB. App Flutter lắng nghe `Stream` từ DB đó.
*   **Độ trễ:** Thấp (< 1s), chấp nhận được cho Smart Home cơ bản.

### 3. Bluetooth Low Energy (BLE)
*   Thư viện Flutter: `flutter_blue_plus`.
*   Khó lập trình hơn Wifi một chút (xử lý Service, Characteristic, UUID).

---

## 23.5. Kết luận

Lập trình Mobile ngày nay không chỉ gói gọn trong màn hình cảm ứng. Việc mở rộng kết nối ra thế giới vật lý qua IoT giúp ứng dụng của bạn có giá trị thực tiễn cực cao và rất dễ gây ấn tượng trong các buổi bảo vệ đồ án hoặc xin việc.

Hãy thử mua một con **ESP8266** và bắt đầu vọc vạch ngay hôm nay!

> 📖 **Tham khảo:** [Xem Bảng tra cứu (Cheatsheet) chi tiết các loại Cảm biến & Giá thành](cheatsheet_sensors.md)

---
[< Bài trước](22_firefoo.md) | [Kết thúc Lộ trình >](EShop_Roadmap.md)

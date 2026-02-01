# 🟦 CHƯƠNG 19
# **ĐỒ ÁN NGHIÊN CỨU: XÂY DỰNG ỨNG DỤNG QUẢN LÝ BÁN HÀNG (MINI SHOP)**
*(Dành cho sinh viên khá giỏi - Yêu cầu xử lý CSDL phức tạp và Quan hệ dữ liệu)*

---

# 1. Giới thiệu bài toán

Khác với Todo App (chỉ có 1 bảng dữ liệu đơn giản), các ứng dụng thực tế luôn có nhiều bảng dữ liệu quan hệ chặt chẽ với nhau.
Đồ án này yêu cầu sinh viên xây dựng **Ứng dụng Quản lý Bán hàng (Mini Shop)** với các nghiệp vụ phức tạp hơn.

**Mục tiêu**:
1.  Xử lý dữ liệu có quan hệ (1-N, N-N).
2.  Hiểu sự khác biệt tư duy giữa SQL (Relational) và NoSQL (Document).
3.  Xử lý bài toán giao dịch (Transaction) - ví dụ: khi tạo đơn hàng phải trừ tồn kho.

---

# 2. Phân tích Dữ liệu (Database Schema)

Ứng dụng cần quản lý 4 thực thể chính:

1.  **Products (Sản phẩm)**:
    *   `id`, `name`, `price`, `description`, `imageUrl`, `stock` (tồn kho).
2.  **Customers (Khách hàng)**:
    *   `id`, `name`, `phone`, `address`.
3.  **Orders (Đơn hàng)**:
    *   `id`, `customerId`, `totalAmount` (tổng tiền), `status` (Mới/Đang giao/Hoàn thành), `createdAt`.
4.  **OrderDetails (Chi tiết đơn hàng)**:
    *   `orderId`, `productId`, `quantity` (số lượng mua), `price` (giá tại thời điểm mua).

---

# 3. Yêu cầu triển khai (Sinh viên chọn 1 trong 2 cách)

Sinh viên có thể chọn **Path A (Firebase)** hoặc **Path B (Self-hosted API)**.

## 🅰️ PATH A: Sử dụng Firebase (NoSQL)

**Thách thức**: Firestore là NoSQL, không có Joins (kết bảng). Bạn phải thiết kế dữ liệu sao cho tối ưu việc đọc.

### Gợi ý thiết kế Firestore:
*   **Collection `products`**: Chứa thông tin sản phẩm.
*   **Collection `customers`**: Chứa thông tin khách hàng.
*   **Collection `orders`**:
    *   Mỗi document Order nên chứa luôn thông tin cơ bản của Customer (để đỡ phải query lại).
    *   **Sub-collection `items`**: Chứa danh sách sản phẩm trong đơn hàng đó.

**Cấu trúc JSON mẫu cho Order:**
```json
// orders/order_id_123
{
  "totalAmount": 500000,
  "status": "pending",
  "createdAt": "2023-10-20...",
  "customer": { // Sao chép dữ liệu customer vào đây (Denormalization)
    "id": "cust_01",
    "name": "Nguyen Van A",
    "phone": "0987..."
  }
}

// orders/order_id_123/items/item_abc
{
  "productId": "prod_01",
  "productName": "Ao Thun", // Sao chép tên để lỡ Product bị xóa thì Order vẫn còn
  "price": 100000,
  "quantity": 2
}
```

**Yêu cầu kỹ thuật Firebase:**
*   Dùng **StreamBuilder** để hiển thị đơn hàng realtime.
*   Dùng **Transaction** (Batch Write): Khi tạo đơn hàng thành công thì phải đồng thời giảm `stock` bên collection `products`. Nếu 1 trong 2 lỗi thì rollback hết.

---

## 🅱️ PATH B: Xây dựng Web API (Laravel/NodeJS + MySQL)

**Thách thức**: Phải tự thiết kế Database chuẩn hóa (Normalization 3NF) và viết API Query phức tạp.

### Gợi ý thiết kế MySQL:
*   Bảng `products`: `id, name, price, stock...`
*   Bảng `customers`: `id, name, phone...`
*   Bảng `orders`: `id, customer_id, total_amount, status...` (Khóa ngoại `customer_id` -> `customers.id`)
*   Bảng `order_details`: `id, order_id, product_id, quantity, price` (Khóa ngoại trỏ về `orders` và `products`).

**Yêu cầu API Endpoints:**

1.  `GET /api/products`: Lấy danh sách sản phẩm (có phân trang Paging).
2.  `GET /api/orders`: Lấy danh sách đơn hàng (kèm thông tin Customer).
    *   *Gợi ý Laravel*: `Order::with('customer')->get()`.
3.  `GET /api/orders/{id}`: Lấy chi tiết đơn hàng (kèm danh sách items).
    *   *Gợi ý Laravel*: `Order::with(['customer', 'items.product'])->find($id)`.
4.  `POST /api/orders`: Tạo đơn hàng mới.
    *   **Logic Backend**: Nhận vào cục JSON bự (thông tin khách + list sản phẩm). Backend phải dùng **Database Transaction** để insert vào bảng `orders`, sau đó loop insert vào `order_details`, và update trừ `stock` bảng `products`.

---

# 4. Yêu cầu về Ứng dụng Flutter (Client)

Dù chọn Backend nào, App Flutter phải có các chức năng sau:

1.  **Màn Home**: Hiển thị lưới sản phẩm (Grid Products).
2.  **Màn Cart (Giỏ hàng)**:
    *   Lưu tạm các món đã chọn (dùng Provider/Bloc).
    *   Cho phép tăng giảm số lượng.
3.  **Màn Checkout (Thanh toán)**:
    *   Nhập thông tin khách hàng.
    *   Bấm "Đặt hàng" -> Gọi API/Firebase để lưu đơn.
4.  **Màn Order History**:
    *   Xem lại lịch sử đơn hàng.
    *   Bấm vào xem chi tiết các món đã mua.

---

# 5. Tiêu chí chấm điểm nghiên cứu

*   **Logic (40%)**: Trừ tồn kho đúng không? Tính tổng tiền đúng không?
*   **Kiến trúc (30%)**:
    *   Firebase: Thiết kế NoSQL hợp lý, không bị lồng quá sâu.
    *   API: Thiết kế Database chuẩn, API trả về JSON sạch sẽ.
*   **UI/UX (30%)**: Giao diện đẹp, thao tác mượt mà, có Loading/Error state đầy đủ.

---

# 📝 Gợi ý mở rộng (Advanced)

*   **Admin App**: Làm thêm 1 app (hoặc phân quyền) cho Admin vào xem đơn hàng và đổi trạng thái từ "Mới" -> "Đang giao".
*   **Push Notification**: Khi Admin đổi trạng thái đơn hàng, điện thoại của khách nhận được thông báo (dùng FCM).
*   **Search**: Tìm kiếm sản phẩm (Firebase dùng Algolia/Text Search, SQL dùng `LIKE`).

---

[< Bài trước](18_bai_tap_tong_hop.md) | [Bài tiếp theo >](20_sensors.md)


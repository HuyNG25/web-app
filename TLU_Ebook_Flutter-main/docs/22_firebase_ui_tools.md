# 🟦 CHƯƠNG 22: FIREFOO - CÔNG CỤ QUẢN TRỊ FIRESTORE MẠNH MẼ

> **Mục tiêu:**
> 1. Sử dụng **Firefoo** để quản lý dữ liệu Firestore hiệu quả hơn gấp 10 lần so với Firebase Console.
> 2. Thực hành **Import/Export** dữ liệu JSON/CSV.
> 3. Viết script **JavaScript** để xử lý dữ liệu hàng loạt (Bulk Update).

---

## 22.1. Tại sao cần Firefoo?

Firebase Console mặc định tuy ổn nhưng rất hạn chế khi dự án phình to:
*   ❌ Không thể lọc dữ liệu với nhiều điều kiện phức tạp.
*   ❌ Không có chế độ xem dạng Bảng (Table View) để so sánh các dòng.
*   ❌ Không thể Import/Export JSON nếu không dùng dòng lệnh.
*   ❌ Không thể sửa dữ liệu hàng loạt (Ví dụ: Đổi tên trường `price` thành `cost` cho 1000 sản phẩm).

**Firefoo** (https://firefoo.app/) giải quyết tất cả vấn đề này. Nó là một ứng dụng Desktop (Windows/Mac/Linux) chuyên dụng cho Firestore.

---

## 22.2. Cài đặt và Kết nối

1.  **Tải xuống:** Truy cập trang chủ Firefoo, tải và cài đặt bản Community (Miễn phí cơ bản) hoặc bản Trial.
2.  **Đăng nhập:** Mở ứng dụng, chọn "Sign in with Google".
3.  **Chọn Project:** Firefoo sẽ tự động liệt kê tất cả Firebase Project của bạn. Chọn dự án "Mini Shop" hoặc "Clinic" để bắt đầu.

---

## 22.3. Các tính năng "Thần thánh"

### 1. Table View & Tree View
*   **Tree View:** Giống console mặc định.
*   **Table View:** Hiển thị Collection như một bảng Excel. Bạn có thể ẩn/hiện cột, kéo thả độ rộng. Rất hữu ích để phát hiện document nào bị thiếu trường dữ liệu.

### 2. Bộ lọc Mạnh mẽ (Where & Order By)
Firefoo cho phép thêm nhiều điều kiện `Where` và `Order By` cùng lúc mà không cần tạo Index thủ công ngay lập tức (nó sẽ nhắc bạn nếu thiếu).
*   Ví dụ: Lọc `price > 100000` VÀ `category == 'Electronics'` VÀ sắp xếp theo `created_at`.

### 3. Import / Export Data
*   **Export:** Chuột phải vào Collection -> Export. Chọn định dạng JSON hoặc CSV.
    *   *Ứng dụng:* Backup dữ liệu định kỳ hoặc gửi dữ liệu mẫu cho team.
*   **Import:** Chuột phải vào Collection -> Import.
    *   Firefoo tự động map (ánh xạ) các cột trong CSV vào các trường Firestore.
    *   Tự động nhận diện kiểu dữ liệu (Số, Chuỗi, Boolean).

---

## 22.4. Thực hành 1: Migrate Dữ liệu (JSON Import)

Giả sử bạn có danh sách sản phẩm mẫu từ file `products.json` và muốn đưa lên Firestore.

**File `products.json`:**
```json
[
  { "name": "Laptop Dell", "price": 15000000, "stock": 10 },
  { "name": "Chuột Logitech", "price": 250000, "stock": 50 }
]
```

**Thao tác:**
1.  Mở Firefoo, chọn Collection `products`.
2.  Menu: **File > Import > JSON**.
3.  Chọn file. Firefoo sẽ hiện bảng Preview.
4.  Bấm **Import**. 
    *   *Kết quả:* Dữ liệu lên Cloud trong nháy mắt, nhanh hơn viết script Dart rất nhiều.

---

## 22.5. Thực hành 2: Scripting (JavaScript Shell) - Sức mạnh thực sự

Đây là tính năng "ăn tiền" nhất. Firefoo tích hợp một môi trường Node.js nhỏ để bạn chạy script trực tiếp lên Database (sử dụng Firebase Admin SDK).

**Bài toán:** Bạn lỡ tay nhập giá tiền (`price`) của 500 sản phẩm là đơn vị USD (Ví dụ: 10, 20), giờ muốn nhân tất cả lên 25000 để ra VND.

**Cách làm thủ công:** Sửa từng dòng -> Mất cả ngày.
**Cách làm với Firefoo Script:** Mất 1 phút.

1.  Bấm vào tab **Script** (biểu tượng `JS`).
2.  Nhập đoạn code sau:

```javascript
// Lấy tất cả documents trong collection 'products'
const products = await db.collection('products').get();

// Duyệt qua từng doc
for (const doc of products.docs) {
    const data = doc.data();
    
    // Kiểm tra logic: Nếu giá nhỏ hơn 1000 (tức là đang để USD)
    if (data.price < 1000) {
        const newPrice = data.price * 25000;
        
        // Cập nhật lại
        await doc.ref.update({
            price: newPrice
        });
        
        console.log(`Updated ${data.name}: ${data.price} -> ${newPrice}`);
    }
}

console.log('Xong! Đã chuyển đổi tiền tệ thành công.');
```

3.  Bấm **Run**.
4.  Ngồi xem log chạy và dữ liệu được cập nhật realtime.

> **Cảnh báo:** Script chạy với quyền Admin, có thể xóa sạch database. Hãy **Backup (Export)** trước khi chạy script sửa/xóa.

---

## 22.6. Bài tập về nhà

1.  **Cài đặt:** Cài Firefoo và kết nối vào Project thi thử của bạn.
2.  **Tạo dữ liệu:** Sử dụng tính năng Import để nạp 20 sản phẩm mẫu vào bảng `products` từ một file Excel/CSV tự chế.
3.  **Scripting:**
    *   Thêm một trường `is_active: true` cho **tất cả** sản phẩm bằng Script.
    *   Viết script xóa tất cả các đơn hàng (`orders`) có trạng thái là `cancelled` để dọn dẹp database.

> **Tổng kết:** Firefoo là cánh tay phải đắc lực cho Backend Developer dùng Firebase. Nó giúp bạn thao tác dữ liệu thô (Raw Data) nhanh chóng, chính xác và chuyên nghiệp.

---
[< Bài trước](21_firebase_studio.md) | [Bài tiếp theo >](23_iot_basics.md)

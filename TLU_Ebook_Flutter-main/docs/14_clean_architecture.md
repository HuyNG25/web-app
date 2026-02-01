# 🟦 CHƯƠNG 14  
# **GESTURE & INTERACTION TRONG FLUTTER**  
*(Tap – Double Tap – Long Press – Drag – GestureDetector – InkWell)*

App không chỉ để xem — mà phải **chạm được**, **kéo được**, **vuốt được**, **giữ được**, **nhấn được**, **phóng to/thu nhỏ được**.

Chương này giúp bạn tạo ra ứng dụng tương tác mềm mại và tự nhiên.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Sử dụng GestureDetector để bắt các thao tác chạm.  
- Tạo hiệu ứng tap như ứng dụng thật bằng InkWell.  
- Xử lý các tương tác: tap, double tap, long press, drag.  
- Tạo UI kéo thả (drag & drop).  
- Tạo vùng chạm "mở rộng" cho button nhỏ.  
- Biết lỗi thường gặp và cách tránh.

---

# 1. **GestureDetector – widget bắt mọi loại tương tác**

GestureDetector giống như "cảm biến chạm" của widget.

### Ví dụ đơn giản:

```dart
GestureDetector(
  onTap: () {
    print("Bạn đã chạm!");
  },
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
);
```

---

### 🧠 Giảng giải chi tiết: GestureDetector là gì?

**GestureDetector là gì?**

- Widget **bắt mọi loại tương tác** của user
- Không hiển thị gì (invisible)
- Chỉ lắng nghe và xử lý gesture
- Rất mạnh mẽ và linh hoạt

**Cấu trúc GestureDetector:**

```
GestureDetector
├── onTap - Chạm 1 lần
├── onDoubleTap - Chạm 2 lần
├── onLongPress - Nhấn giữ
├── onPanUpdate - Kéo (drag)
├── onTapDown - Chạm xuống
├── onTapUp - Nhả tay
└── child - Widget cần bắt gesture
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Tạo GestureDetector
GestureDetector(
  // BƯỚC 2: Xử lý các gesture
  onTap: () {
    print("Đã chạm!");
  },
  
  onDoubleTap: () {
    print("Đã chạm 2 lần!");
  },
  
  onLongPress: () {
    print("Đã nhấn giữ!");
  },
  
  // BƯỚC 3: Child widget cần bắt gesture
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
)
```

**Các loại gesture phổ biến:**

```dart
GestureDetector(
  // 1. Tap - Chạm 1 lần
  onTap: () {
    print("Tap");
  },
  
  // 2. Double Tap - Chạm 2 lần nhanh
  onDoubleTap: () {
    print("Double Tap");
  },
  
  // 3. Long Press - Nhấn giữ (>500ms)
  onLongPress: () {
    print("Long Press");
  },
  
  // 4. Tap Down - Chạm xuống (chưa nhả)
  onTapDown: (TapDownDetails details) {
    print("Tap Down tại: ${details.globalPosition}");
  },
  
  // 5. Tap Up - Nhả tay
  onTapUp: (TapUpDetails details) {
    print("Tap Up tại: ${details.globalPosition}");
  },
  
  // 6. Tap Cancel - Hủy tap (ví dụ: kéo ra ngoài)
  onTapCancel: () {
    print("Tap Cancel");
  },
  
  // 7. Pan Update - Kéo (drag)
  onPanUpdate: (DragUpdateDetails details) {
    print("Kéo: dx=${details.delta.dx}, dy=${details.delta.dy}");
  },
  
  child: Container(...),
)
```

**Ví dụ minh họa: GestureDetector với các biến thể**

```dart
// 1. GestureDetector đơn giản
GestureDetector(
  onTap: () => print("Tap"),
  child: Container(width: 100, height: 100, color: Colors.blue),
)

// 2. GestureDetector với nhiều gesture
GestureDetector(
  onTap: () => print("Tap"),
  onDoubleTap: () => print("Double Tap"),
  onLongPress: () => print("Long Press"),
  child: Container(...),
)

// 3. GestureDetector với behavior
GestureDetector(
  behavior: HitTestBehavior.opaque,  // Mở rộng vùng chạm
  onTap: () => print("Tap"),
  child: Icon(Icons.close, size: 20),
)
```

---

# 2. **Các loại gesture thường dùng**

### 1. onTap – chạm 1 lần

```dart
onTap: () => print("Tap"),
```

---

### 🧠 Giảng giải chi tiết: onTap

**onTap là gì?**

- Kích hoạt khi user **chạm và nhả tay** nhanh
- Không phải double tap hoặc long press
- Rất phổ biến cho button, card, item

**Ví dụ minh họa:**

```dart
GestureDetector(
  onTap: () {
    print("Đã tap!");
    // Navigate, show dialog, update state...
  },
  child: Container(
    width: 200,
    height: 50,
    color: Colors.blue,
    child: Center(child: Text("Tap me")),
  ),
)
```

---

### 2. onDoubleTap – chạm 2 lần

```dart
onDoubleTap: () => print("Double Tap"),
```

---

### 🧠 Giảng giải chi tiết: onDoubleTap

**onDoubleTap là gì?**

- Kích hoạt khi user **chạm 2 lần nhanh** (trong khoảng thời gian ngắn)
- Thường dùng để zoom, like, favorite
- Phải chạm 2 lần liên tiếp

**Ví dụ minh họa:**

```dart
GestureDetector(
  onDoubleTap: () {
    print("Double tap!");
    // Zoom image, like post...
  },
  child: Image.network("https://..."),
)
```

**Lưu ý:** onTap và onDoubleTap có thể xung đột. Nếu cần cả 2, dùng Timer để phân biệt.

---

### 3. onLongPress – nhấn giữ

```dart
onLongPress: () => print("Long Press"),
```

---

### 🧠 Giảng giải chi tiết: onLongPress

**onLongPress là gì?**

- Kích hoạt khi user **nhấn giữ** (>500ms)
- Thường dùng cho context menu, delete, edit
- Rất phổ biến trong mobile apps

**Ví dụ minh họa:**

```dart
GestureDetector(
  onLongPress: () {
    print("Long press!");
    // Show context menu, delete dialog...
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            ListTile(title: Text("Chỉnh sửa")),
            ListTile(title: Text("Xóa")),
          ],
        ),
      ),
    );
  },
  child: ListTile(title: Text("Nhấn giữ tôi")),
)
```

---

### 4. onPanUpdate – kéo (drag)

```dart
onPanUpdate: (details) {
  print("dx: ${details.delta.dx}, dy: ${details.delta.dy}");
}
```

---

### 🧠 Giảng giải chi tiết: onPanUpdate

**onPanUpdate là gì?**

- Kích hoạt khi user **kéo** (drag) widget
- Cung cấp thông tin về **vị trí** và **khoảng cách di chuyển**
- Rất hữu ích cho drag & drop, slider

**Ví dụ minh họa:**

```dart
class DraggableBox extends StatefulWidget {
  @override
  State<DraggableBox> createState() => _DraggableBoxState();
}

class _DraggableBoxState extends State<DraggableBox> {
  double x = 100;
  double y = 100;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        // details.delta.dx: Khoảng cách di chuyển theo trục X
        // details.delta.dy: Khoảng cách di chuyển theo trục Y
        setState(() {
          x += details.delta.dx;  // Cập nhật vị trí X
          y += details.delta.dy;  // Cập nhật vị trí Y
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Các thuộc tính của DragUpdateDetails:**

```dart
onPanUpdate: (DragUpdateDetails details) {
  details.delta.dx      // Khoảng cách X (có thể âm/dương)
  details.delta.dy      // Khoảng cách Y (có thể âm/dương)
  details.globalPosition // Vị trí toàn cục
  details.localPosition  // Vị trí local
}
```

**Các callback liên quan:**

```dart
GestureDetector(
  // Bắt đầu kéo
  onPanStart: (DragStartDetails details) {
    print("Bắt đầu kéo tại: ${details.globalPosition}");
  },
  
  // Đang kéo
  onPanUpdate: (DragUpdateDetails details) {
    // Cập nhật vị trí
  },
  
  // Kết thúc kéo
  onPanEnd: (DragEndDetails details) {
    print("Kết thúc kéo");
    // Xử lý sau khi kéo xong
  },
  
  child: Container(...),
)
```

---

### 5. onTapDown – chạm xuống (nhưng chưa nhả)

```dart
onTapDown: (_) => print("Down"),
```

---

### 🧠 Giảng giải chi tiết: onTapDown

**onTapDown là gì?**

- Kích hoạt **ngay khi chạm xuống** (chưa nhả)
- Khác với onTap (chỉ kích hoạt khi nhả)
- Hữu ích cho feedback tức thì

**Ví dụ minh họa:**

```dart
class PressFeedback extends StatefulWidget {
  @override
  State<PressFeedback> createState() => _PressFeedbackState();
}

class _PressFeedbackState extends State<PressFeedback> {
  bool isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;  // Feedback ngay khi chạm
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;  // Nhả khi thả tay
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;  // Hủy nếu kéo ra ngoài
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        child: Container(
          width: 200,
          height: 50,
          color: isPressed ? Colors.blue[700] : Colors.blue,
          child: Center(child: Text("Press me")),
        ),
      ),
    );
  }
}
```

---

### 🎒 Ví dụ đời sống  
GestureDetector giống như **cái công tắc cảm ứng**:  
bạn chạm nhẹ – nó biết, nhấn giữ – nó biết, vuốt – nó biết luôn.

---

# 3. **InkWell – hiệu ứng ripple (gợn sóng) khi bấm**

InkWell là button *ngầm*, hiển thị hiệu ứng "sóng nước" khi bấm, rất đẹp.

### Ví dụ:

```dart
InkWell(
  onTap: () => print("Pressed"),
  child: Container(
    padding: const EdgeInsets.all(16),
    child: const Text("InkWell Button"),
  ),
);
```

---

### 🧠 Giảng giải chi tiết: InkWell là gì?

**InkWell là gì?**

- Widget có **hiệu ứng ripple** (gợn sóng) khi bấm
- Rất đẹp và chuyên nghiệp
- Chỉ hỗ trợ tap (không hỗ trợ drag, long press phức tạp)
- Phải có Material widget làm parent

**Cơ chế hoạt động:**

```
User tap vào InkWell
    ↓
Hiệu ứng ripple xuất hiện từ điểm tap
    ↓
Ripple lan rộng ra ngoài
    ↓
Ripple mờ dần và biến mất
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Phải có Material widget làm parent
Material(
  color: Colors.transparent,  // Hoặc màu cụ thể
  child: InkWell(
    // BƯỚC 2: Xử lý tap
    onTap: () {
      print("Đã tap!");
    },
    
    // BƯỚC 3: Tùy chỉnh màu ripple
    splashColor: Colors.blue[200],  // Màu ripple
    highlightColor: Colors.blue[100],  // Màu khi giữ
    
    // BƯỚC 4: Hình dạng ripple
    borderRadius: BorderRadius.circular(12),  // Bo góc
    
    // BƯỚC 5: Child widget
    child: Container(
      padding: EdgeInsets.all(16),
      child: Text("InkWell Button"),
    ),
  ),
)
```

**Các thuộc tính quan trọng:**

```dart
InkWell(
  onTap: () {},                    // Xử lý tap
  onLongPress: () {},              // Long press (tùy chọn)
  splashColor: Colors.blue[200],   // Màu ripple
  highlightColor: Colors.blue[100], // Màu khi giữ
  borderRadius: BorderRadius.circular(12), // Hình dạng
  child: Widget(),                 // Nội dung
)
```

**Ví dụ minh họa: InkWell với các biến thể**

```dart
// 1. InkWell đơn giản
Material(
  child: InkWell(
    onTap: () => print("Tap"),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text("Button"),
    ),
  ),
)

// 2. InkWell với màu tùy chỉnh
Material(
  color: Colors.white,
  child: InkWell(
    onTap: () => print("Tap"),
    splashColor: Colors.blue[200],
    highlightColor: Colors.blue[100],
    child: Container(
      padding: EdgeInsets.all(16),
      child: Text("Colored Button"),
    ),
  ),
)

// 3. InkWell với border radius
Material(
  child: InkWell(
    onTap: () => print("Tap"),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("Rounded Button"),
    ),
  ),
)

// 4. InkWell trong Card
Card(
  child: InkWell(
    onTap: () => print("Tap card"),
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text("Card Button"),
    ),
  ),
)
```

---

# 4. **InkResponse – phiên bản nâng cấp của InkWell**

Hỗ trợ hiệu ứng bo tròn tốt hơn:

```dart
InkResponse(
  onTap: () {},
  splashColor: Colors.red,
  child: const Icon(Icons.favorite),
);
```

---

### 🧠 Giảng giải chi tiết: InkResponse là gì?

**InkResponse là gì?**

- **Nâng cấp** của InkWell
- Hỗ trợ **bo tròn** tốt hơn (phù hợp cho icon tròn)
- Có thêm các callback: onTapDown, onTapUp, onTapCancel
- Phù hợp cho icon button

**So sánh InkWell vs InkResponse:**

| Đặc điểm | InkWell | InkResponse |
|----------|---------|-------------|
| **Bo tròn** | Hỗ trợ cơ bản | Hỗ trợ tốt hơn |
| **Icon button** | OK | Tốt hơn |
| **Callback** | onTap, onLongPress | Thêm onTapDown, onTapUp |
| **Performance** | Tốt | Tốt |

**Ví dụ minh họa:**

```dart
// ✅ ĐÚNG: InkResponse cho icon tròn
Material(
  color: Colors.transparent,
  child: InkResponse(
    onTap: () => print("Tap icon"),
    splashColor: Colors.red[200],
    highlightColor: Colors.red[100],
    borderRadius: BorderRadius.circular(24),  // Bo tròn hoàn hảo
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Icon(Icons.favorite, size: 24),
    ),
  ),
)
```

---

# 5. **GestureDetector vs InkWell – nên dùng cái nào?**

| Tiêu chí | GestureDetector | InkWell |
|---------|------------------|---------|
| Bắt nhiều loại gesture | ✔ Rất mạnh | ✘ chỉ tap |
| Hiệu ứng ripple | ✘ Không có | ✔ Có |
| Hình dáng button | tự custom | dễ dùng |
| Dùng trong MaterialApp | được | ✔ đẹp hơn |

👉 **Nếu chỉ muốn “bấm + hiệu ứng” → dùng InkWell.**  
👉 **Nếu muốn bắt nhiều gesture → dùng GestureDetector.**

---

# 6. **Làm nút bấm có vùng chạm lớn hơn (dành cho nút nhỏ)**

```dart
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => print("tap"),
  child: const Padding(
    padding: EdgeInsets.all(20),
    child: Icon(Icons.close),
  ),
);
```

→ tránh lỗi tap “khó bấm”.

---

# 7. **Tạo hiệu ứng kéo (drag) để di chuyển widget**

### Ví dụ: kéo một hình tròn theo tay

```dart
class DragBall extends StatefulWidget {
  const DragBall({super.key});

  @override
  State<DragBall> createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  double x = 100;
  double y = 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          x += details.delta.dx;
          y += details.delta.dy;
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: const CircleAvatar(radius: 40),
          ),
        ],
      ),
    );
  }
}
```

---

### 🧠 Giảng giải chi tiết: Drag & Drop là gì?

**Drag là gì?**

- User **kéo** widget từ vị trí này sang vị trí khác
- Widget **di chuyển theo** ngón tay
- Rất phổ biến cho game, slider, reorder list

**Cơ chế hoạt động:**

```
User chạm và kéo
    ↓
onPanStart được gọi (bắt đầu)
    ↓
onPanUpdate được gọi nhiều lần (đang kéo)
    ├── details.delta.dx: Khoảng cách X
    └── details.delta.dy: Khoảng cách Y
    ↓
Cập nhật vị trí widget
    ↓
onPanEnd được gọi (kết thúc)
```

**Ví dụ minh họa từng bước:**

```dart
class DragBall extends StatefulWidget {
  @override
  State<DragBall> createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  // BƯỚC 1: State lưu vị trí
  double x = 100;
  double y = 100;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // BƯỚC 2: Bắt đầu kéo
      onPanStart: (DragStartDetails details) {
        print("Bắt đầu kéo tại: ${details.globalPosition}");
      },
      
      // BƯỚC 3: Đang kéo (quan trọng nhất)
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          // Cập nhật vị trí dựa trên khoảng cách di chuyển
          x += details.delta.dx;  // Di chuyển theo trục X
          y += details.delta.dy;  // Di chuyển theo trục Y
        });
      },
      
      // BƯỚC 4: Kết thúc kéo
      onPanEnd: (DragEndDetails details) {
        print("Kết thúc kéo");
        // Có thể thêm animation bounce, snap...
      },
      
      // BƯỚC 5: Widget có thể kéo
      child: Stack(
        children: [
          Positioned(
            left: x,  // Vị trí X
            top: y,   // Vị trí Y
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Ví dụ minh họa: Drag với giới hạn**

```dart
class ConstrainedDrag extends StatefulWidget {
  @override
  State<ConstrainedDrag> createState() => _ConstrainedDragState();
}

class _ConstrainedDragState extends State<ConstrainedDrag> {
  double x = 100;
  double y = 100;
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Giới hạn trong màn hình
          x = (x + details.delta.dx).clamp(0.0, screenWidth - 80);
          y = (y + details.delta.dy).clamp(0.0, screenHeight - 80);
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: CircleAvatar(radius: 40),
          ),
        ],
      ),
    );
  }
}
```

**Ví dụ minh họa: Drag với snap (bám vào vị trí)**

```dart
class SnapDrag extends StatefulWidget {
  @override
  State<SnapDrag> createState() => _SnapDragState();
}

class _SnapDragState extends State<SnapDrag> {
  double x = 100;
  double y = 100;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          x += details.delta.dx;
          y += details.delta.dy;
        });
      },
      onPanEnd: (details) {
        // Snap về vị trí gần nhất
        final snapX = (x / 100).round() * 100.0;
        final snapY = (y / 100).round() * 100.0;
        
        setState(() {
          x = snapX;
          y = snapY;
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: CircleAvatar(radius: 40),
          ),
        ],
      ),
    );
  }
}
```

---

# 8. **Gesture conflict – khi nhiều widget chồng lên nhau**

Sinh viên hay gặp lỗi:

- gesture không hoạt động  
- onTap bị nuốt bởi widget bên dưới  

⚠ Để tránh:

- kiểm tra `behavior: HitTestBehavior.translucent`  
- không lồng nhiều GestureDetector không cần thiết  
- ưu tiên InkWell nếu chỉ cần onTap  

---

# 9. **Sai vs Đúng (lỗi thực tế của sinh viên)**

## ❌ Sai: InkWell không có hiệu ứng  
→ vì widget cha không phải Material

```dart
InkWell(child: Text("Tap"));  // Không ripple
```

---

### 🔍 Giảng giải chi tiết: Tại sao InkWell cần Material?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: InkWell không có Material parent
InkWell(
  onTap: () => print("Tap"),
  child: Text("Tap me"),
)
// → Không có hiệu ứng ripple!

// Vấn đề:
// - InkWell cần Material để vẽ ripple effect
// - Không có Material → không vẽ được ripple
// - Chỉ có tap, không có visual feedback
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có Material parent
Material(
  color: Colors.transparent,  // Hoặc màu cụ thể
  child: InkWell(
    onTap: () => print("Tap"),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text("Tap me"),
    ),
  ),
)

// Hoặc dùng Card (có Material bên trong)
Card(
  child: InkWell(
    onTap: () => print("Tap"),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text("Tap me"),
    ),
  ),
)
```

---

## ✔ Đúng:

```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () {},
    child: const Text("Tap"),
  ),
);
```

---

## ❌ Sai: GestureDetector bọc Container nhưng không bắt tap  
→ quên set màu hoặc không dùng behavior

```dart
GestureDetector(
  onTap: () {},
  child: Container(),  // quá nhỏ, không có màu
)
```

---

### 🔍 Giảng giải chi tiết: Tại sao GestureDetector không bắt tap?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Container quá nhỏ hoặc không có màu
GestureDetector(
  onTap: () => print("Tap"),
  child: Container(),  // ← Không có size, không có màu
)
// → Không bắt được tap!

// ❌ SAI: Icon quá nhỏ
GestureDetector(
  onTap: () => print("Tap"),
  child: Icon(Icons.close, size: 20),  // ← Quá nhỏ, khó tap
)
// → Khó bấm, dễ miss
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Dùng behavior để mở rộng vùng chạm
GestureDetector(
  behavior: HitTestBehavior.opaque,  // ← QUAN TRỌNG!
  onTap: () => print("Tap"),
  child: Container(
    height: 50,  // Có size
    color: Colors.blue,  // Có màu (tùy chọn)
    child: Icon(Icons.close),
  ),
)

// ✅ ĐÚNG: Dùng Padding để mở rộng vùng chạm
GestureDetector(
  onTap: () => print("Tap"),
  child: Padding(
    padding: EdgeInsets.all(20),  // ← Mở rộng vùng chạm
    child: Icon(Icons.close, size: 20),
  ),
)
```

**Các loại HitTestBehavior:**

```dart
// 1. deferToChild - Chỉ bắt tap trong child (mặc định)
behavior: HitTestBehavior.deferToChild

// 2. opaque - Bắt tap trong toàn bộ vùng (khuyến nghị)
behavior: HitTestBehavior.opaque

// 3. translucent - Bắt tap và cho phép tap xuyên qua
behavior: HitTestBehavior.translucent
```

---

## ✔ Đúng:

```dart
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {},
  child: Container(height: 50),
)
```

---

## ❌ Sai: đặt GestureDetector trong ListView → gesture delay  
→ do ListView ưu tiên cuộn

---

### 🔍 Giảng giải chi tiết: Vấn đề GestureDetector trong ListView

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: GestureDetector với drag trong ListView
ListView(
  children: [
    GestureDetector(
      onPanUpdate: (details) {
        // Xử lý drag
      },
      child: ListTile(...),
    ),
  ],
)

// Vấn đề:
// - ListView ưu tiên scroll gesture
// - onPanUpdate có thể bị conflict với scroll
// - Gesture delay, không mượt
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Dùng onTap hoặc InkWell
ListView(
  children: [
    InkWell(
      onTap: () => print("Tap"),
      child: ListTile(...),
    ),
  ],
)

// ✅ ĐÚNG: Dùng ListTile.onTap
ListView(
  children: [
    ListTile(
      title: Text("Item"),
      onTap: () => print("Tap"),  // ← Built-in tap
    ),
  ],
)
```

---

## ✔ Đúng  
dùng `onTap` hoặc `InkWell` thay vì drag gesture.

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: onTap và onDoubleTap xung đột

#### ❌ Vấn đề:

```dart
GestureDetector(
  onTap: () => print("Tap"),  // ← Chạy trước
  onDoubleTap: () => print("Double Tap"),  // ← Chạy sau
  child: Container(...),
)
// → onTap chạy trước onDoubleTap → Xung đột!
```

#### ✅ Giải pháp:

```dart
class SmartTap extends StatefulWidget {
  @override
  State<SmartTap> createState() => _SmartTapState();
}

class _SmartTapState extends State<SmartTap> {
  Timer? _tapTimer;
  
  void _handleTap() {
    _tapTimer?.cancel();
    _tapTimer = Timer(Duration(milliseconds: 300), () {
      // Single tap
      print("Single Tap");
    });
  }
  
  void _handleDoubleTap() {
    _tapTimer?.cancel();
    print("Double Tap");
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      child: Container(...),
    );
  }
  
  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }
}
```

---

### Case Study 2: GestureDetector không bắt tap ở vùng trống

#### ❌ Vấn đề:

```dart
GestureDetector(
  onTap: () => print("Tap"),
  child: Column(
    children: [
      Text("A"),
      SizedBox(height: 100),  // ← Vùng trống
      Text("B"),
    ],
  ),
)
// → Tap vào vùng trống không bắt được!
```

#### ✅ Giải pháp:

```dart
GestureDetector(
  behavior: HitTestBehavior.opaque,  // ← Bắt tap ở vùng trống
  onTap: () => print("Tap"),
  child: Container(
    color: Colors.transparent,  // Hoặc màu cụ thể
    child: Column(...),
  ),
)
```

---

### Case Study 3: Long press không hoạt động

#### ❌ Vấn đề:

```dart
GestureDetector(
  onLongPress: () => print("Long Press"),
  onPanUpdate: (details) {
    // Xử lý drag
  },
  child: Container(...),
)
// → onPanUpdate có thể "ăn" long press!
```

#### ✅ Giải pháp:

```dart
// Tách riêng: Dùng GestureDetector riêng cho long press
Stack(
  children: [
    GestureDetector(
      onPanUpdate: (details) {
        // Drag
      },
      child: Container(...),
    ),
    Positioned.fill(
      child: GestureDetector(
        onLongPress: () => print("Long Press"),
        child: Container(color: Colors.transparent),
      ),
    ),
  ],
)
```

---

# 10. **Các ví dụ thực tế đa dạng**

## 10.1. **Ví dụ: Card có thể nhấn + ripple + long press**

```dart
Card(
  child: InkWell(
    onTap: () => print("Tap card"),
    onLongPress: () {
      print("Long press");
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          child: Column(
            children: [
              ListTile(title: Text("Chỉnh sửa")),
              ListTile(title: Text("Xóa")),
            ],
          ),
        ),
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: const [
          Icon(Icons.star),
          SizedBox(width: 10),
          Text("Card có tương tác"),
        ],
      ),
    ),
  ),
);
```

---

## 10.2. **Ví dụ: Icon button với InkResponse**

```dart
Material(
  color: Colors.transparent,
  child: InkResponse(
    onTap: () => print("Tap icon"),
    splashColor: Colors.blue[200],
    highlightColor: Colors.blue[100],
    borderRadius: BorderRadius.circular(24),
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Icon(Icons.favorite, size: 24),
    ),
  ),
)
```

---

## 10.3. **Ví dụ: Drag & Drop game đơn giản**

```dart
class DragGame extends StatefulWidget {
  @override
  State<DragGame> createState() => _DragGameState();
}

class _DragGameState extends State<DragGame> {
  double ballX = 100;
  double ballY = 100;
  double targetX = 200;
  double targetY = 300;
  bool isWin = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drag Game")),
      body: Stack(
        children: [
          // Target
          Positioned(
            left: targetX,
            top: targetY,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Draggable ball
          Positioned(
            left: ballX,
            top: ballY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  ballX += details.delta.dx;
                  ballY += details.delta.dy;
                  
                  // Kiểm tra win
                  final distance = 
                    sqrt(pow(ballX - targetX, 2) + pow(ballY - targetY, 2));
                  if (distance < 50 && !isWin) {
                    isWin = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Bạn thắng!")),
                    );
                  }
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 10.4. **Ví dụ: Button với press feedback**

```dart
class PressButton extends StatefulWidget {
  @override
  State<PressButton> createState() => _PressButtonState();
}

class _PressButtonState extends State<PressButton> {
  bool isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isPressed ? Colors.blue[700] : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Press me",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
```

---

## 10.5. **Ví dụ: Swipe to delete**

```dart
class SwipeableTile extends StatefulWidget {
  final String title;
  final VoidCallback onDelete;
  
  SwipeableTile({required this.title, required this.onDelete});
  
  @override
  State<SwipeableTile> createState() => _SwipeableTileState();
}

class _SwipeableTileState extends State<SwipeableTile> {
  double dragOffset = 0;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          dragOffset += details.delta.dx;
          // Chỉ cho phép kéo sang trái (âm)
          if (dragOffset > 0) dragOffset = 0;
        });
      },
      onPanEnd: (details) {
        if (dragOffset < -100) {
          // Swipe đủ xa → Xóa
          widget.onDelete();
        } else {
          // Không đủ xa → Về lại
          setState(() {
            dragOffset = 0;
          });
        }
      },
      child: Stack(
        children: [
          // Delete button (ẩn)
          Positioned.fill(
            child: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          
          // ListTile (có thể kéo)
          Transform.translate(
            offset: Offset(dragOffset, 0),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(widget.title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 10.6. **Ví dụ: Pinch to zoom (scale)**

```dart
class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  
  ZoomableImage({required this.imageUrl});
  
  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  double scale = 1.0;
  double previousScale = 1.0;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        previousScale = scale;
      },
      onScaleUpdate: (details) {
        setState(() {
          scale = previousScale * details.scale;
          // Giới hạn scale
          scale = scale.clamp(1.0, 4.0);
        });
      },
      child: Transform.scale(
        scale: scale,
        child: Image.network(widget.imageUrl),
      ),
    );
  }
}
```

---

# 11. **Best Practices**

## 11.1. **Khi nào dùng widget nào?**

| Widget | Khi nào dùng | Ví dụ |
|--------|-------------|-------|
| **GestureDetector** | Cần nhiều gesture, tùy chỉnh | Drag, long press, custom |
| **InkWell** | Chỉ cần tap + ripple | Button, card, list item |
| **InkResponse** | Icon button, cần bo tròn tốt | Icon button, favorite |
| **ListTile.onTap** | List item đơn giản | Menu, settings |

## 11.2. **Best Practices**

### 1. Luôn dùng Material cho InkWell

```dart
// ✅ ĐÚNG
Material(
  child: InkWell(
    onTap: () {},
    child: Text("Button"),
  ),
)

// ❌ SAI
InkWell(
  onTap: () {},
  child: Text("Button"),  // Không có ripple!
)
```

### 2. Mở rộng vùng chạm cho button nhỏ

```dart
// ✅ ĐÚNG
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {},
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Icon(Icons.close, size: 20),
  ),
)

// ❌ SAI
GestureDetector(
  onTap: () {},
  child: Icon(Icons.close, size: 20),  // Quá nhỏ, khó tap
)
```

### 3. Tránh gesture conflict

```dart
// ✅ ĐÚNG: Dùng onTap trong ListView
ListTile(
  title: Text("Item"),
  onTap: () => print("Tap"),
)

// ❌ SAI: GestureDetector với drag trong ListView
GestureDetector(
  onPanUpdate: (details) {...},  // Conflict với scroll
  child: ListTile(...),
)
```

### 4. Xử lý onTap và onDoubleTap riêng biệt

```dart
// ✅ ĐÚNG: Dùng Timer để phân biệt
Timer? _tapTimer;

void _handleTap() {
  _tapTimer?.cancel();
  _tapTimer = Timer(Duration(milliseconds: 300), () {
    // Single tap
  });
}

void _handleDoubleTap() {
  _tapTimer?.cancel();
  // Double tap
}
```

### 5. Giới hạn vùng drag

```dart
// ✅ ĐÚNG: Giới hạn trong màn hình
onPanUpdate: (details) {
  setState(() {
    x = (x + details.delta.dx).clamp(0.0, screenWidth - widgetWidth);
    y = (y + details.delta.dy).clamp(0.0, screenHeight - widgetHeight);
  });
}
```

---

# 12. Bài tập thực hành

1. Tạo button tùy chỉnh dùng InkWell (ripple).  
2. Tạo widget có thể nhấn giữ (long press) để đổi màu.  
3. Làm widget drag-and-drop (kéo icon trên màn hình).  
4. Tạo danh sách ListTile nhưng mỗi tile có InkWell bao ngoài.  
5. Làm mini game "kéo bóng" bằng GestureDetector.
6. Tạo swipe to delete cho ListTile.
7. Tạo image có thể pinch to zoom.
8. Tạo toggle switch với AnimatedAlign + GestureDetector.

---

# 13. Mini Test cuối chương

**Câu 1:** GestureDetector dùng để làm gì?  
→ bắt các thao tác chạm, kéo, giữ…

**Câu 2:** InkWell có gì đặc biệt?  
→ hiệu ứng ripple đẹp.

**Câu 3:** Làm sao mở rộng vùng chạm?  
→ dùng `behavior: HitTestBehavior.opaque`.

**Câu 4:** onDoubleTap khác gì onTap?  
→ onDoubleTap kích hoạt khi nhấn nhanh 2 lần.

**Câu 5:** onPanUpdate dùng cho loại gesture nào?  
→ drag (kéo).

**Câu 6:** Tại sao InkWell cần Material widget làm parent?  
→ Material cung cấp canvas để vẽ ripple effect.

**Câu 7:** HitTestBehavior.opaque khác gì HitTestBehavior.deferToChild?  
→ opaque bắt tap trong toàn bộ vùng, deferToChild chỉ trong child.

**Câu 8:** onTapDown khác gì onTap?  
→ onTapDown kích hoạt ngay khi chạm xuống, onTap chỉ khi nhả tay.

**Câu 9:** Tại sao không nên dùng GestureDetector với drag trong ListView?  
→ Conflict với scroll gesture, gây delay.

**Câu 10:** InkResponse khác gì InkWell?  
→ InkResponse hỗ trợ bo tròn tốt hơn, phù hợp cho icon button.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **GestureDetector** = bắt mọi gesture (tap, drag, long press...).  
- **InkWell** = tap đẹp + ripple (cần Material parent).  
- **InkResponse** = nâng cấp InkWell, tốt cho icon button.  
- **onTap** = chạm và nhả tay.  
- **onDoubleTap** = chạm 2 lần nhanh.  
- **onLongPress** = nhấn giữ (>500ms).  
- **onPanUpdate** = kéo (drag), cung cấp delta.dx, delta.dy.  
- **behavior: HitTestBehavior.opaque** = mở rộng vùng chạm.  
- **Luôn dùng Material** cho InkWell để có ripple effect.  
- **Tránh gesture conflict** trong ListView (dùng onTap thay vì drag).  

---

# 🎉 Kết thúc chương 14  
Tiếp theo chúng ta sẽ học **chương 15 – Navigation nâng cao với BottomSheet, Dialog, và Routing 2.0 (Giới thiệu)**  
hoặc bạn có thể chuyển sang **chương 15 – Responsive Layout** tuỳ theo giáo trình bạn muốn.


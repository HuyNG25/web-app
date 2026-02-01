# 🟦 CHƯƠNG 13  
# **ANIMATION CƠ BẢN TRONG FLUTTER**  
*(AnimatedContainer – AnimatedOpacity – Tween – Curves – AnimatedAlign – AnimatedDefaultTextStyle)*

Animation giúp ứng dụng cảm giác **mượt – sống – chuyên nghiệp**.  
Không cần kiến thức khó, chỉ cần nắm đúng các widget animation tích hợp sẵn của Flutter.

Chương này dành cho người mới: chỉ dùng “animation đơn giản nhưng hiệu quả cao”.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Hiểu nguyên lý animation trong Flutter.  
- Dùng AnimatedContainer để animate kích thước, màu sắc, bo góc.  
- Dùng AnimatedOpacity để làm hiệu ứng fade in/out.  
- Dùng Tween animation với AnimationController.  
- Hiểu về Curves (độ mượt của animation).  
- Dùng các AnimatedWidget phổ biến trong UI thực tế.  
- Tạo hiệu ứng nhỏ nhanh và đẹp mắt.

---

# 1. **Animation trong Flutter hoạt động như thế nào?**

Flutter làm animation bằng cách:

1. Thay đổi giá trị nào đó theo thời gian  
2. Vẽ lại UI rất nhanh  
3. Mắt người thấy nó chuyển động mượt mà  

Animation = thay đổi từ *trạng thái A* → *trạng thái B* trong một khoảng thời gian.

---

### 🧠 Giảng giải chi tiết: Animation là gì?

**Animation là gì?**

- Quá trình **thay đổi giá trị** theo thời gian
- Flutter vẽ lại UI **nhiều lần** với giá trị khác nhau
- Mắt người thấy chuyển động **mượt mà** (60 FPS)

**Cơ chế hoạt động:**

```
Trạng thái ban đầu: width = 100
    ↓
setState() → Thay đổi state
    ↓
AnimatedContainer nhận giá trị mới: width = 200
    ↓
Flutter tự động tạo các frame trung gian:
  - Frame 1: width = 100
  - Frame 2: width = 120
  - Frame 3: width = 140
  - ...
  - Frame N: width = 200
    ↓
Vẽ lại UI 60 lần/giây
    ↓
Mắt người thấy chuyển động mượt
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Khởi tạo state
bool isBig = false;  // Trạng thái ban đầu

// BƯỚC 2: Widget phụ thuộc vào state
AnimatedContainer(
  duration: Duration(milliseconds: 500),  // Thời gian animation
  width: isBig ? 200 : 100,  // Giá trị thay đổi
  height: isBig ? 200 : 100,
)

// BƯỚC 3: Thay đổi state
setState(() {
  isBig = !isBig;  // isBig: false → true
})

// BƯỚC 4: Flutter tự động animate
// width: 100 → 120 → 140 → ... → 200 (trong 500ms)
```

**Các thành phần của Animation:**

```
Animation
├── Duration (thời gian) - Bao lâu để hoàn thành
├── Curve (đường cong) - Tốc độ thay đổi (nhanh/chậm)
├── Tween (khoảng giá trị) - Từ A đến B
└── Controller (điều khiển) - Bắt đầu/dừng/lặp lại
```

**Ví dụ minh họa: Animation đơn giản**

```dart
// Animation: Box phóng to/thu nhỏ
class SimpleAnimation extends StatefulWidget {
  @override
  State<SimpleAnimation> createState() => _SimpleAnimationState();
}

class _SimpleAnimationState extends State<SimpleAnimation> {
  bool isBig = false;  // State
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isBig = !isBig;  // Thay đổi state
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),  // 500ms để hoàn thành
        width: isBig ? 200 : 100,  // Từ 100 → 200
        height: isBig ? 200 : 100,
        color: isBig ? Colors.blue : Colors.red,  // Đổi màu
        child: Center(child: Text("Tap me")),
      ),
    );
  }
}

// Flow:
// 1. User tap → setState() → isBig = true
// 2. AnimatedContainer nhận width mới = 200
// 3. Flutter tự động tạo các frame: 100 → 120 → 140 → ... → 200
// 4. UI vẽ lại 60 lần/giây → Mắt thấy chuyển động mượt
```

---

### 🎒 Ví dụ đời sống  
Animation giống như bạn kéo 1 cánh cửa:

- lúc đầu → cửa đóng  
- sau đó → từ từ mở  
- cuối cùng → mở hoàn toàn  

UI cũng vậy: từ trạng thái ban đầu → chuyển dần sang trạng thái mới.

**Giải thích chi tiết:**

```
Cánh cửa (Animation):
├── Trạng thái A: Đóng (góc 0°)
├── Trạng thái B: Mở (góc 90°)
└── Quá trình: 0° → 10° → 20° → ... → 90° (mượt mà)

UI Animation:
├── Trạng thái A: width = 100
├── Trạng thái B: width = 200
└── Quá trình: 100 → 120 → 140 → ... → 200 (mượt mà)
```

---

# 2. **AnimatedContainer – widget animation "tất cả trong một"**

Dùng để animate:

- width / height  
- padding / margin  
- màu sắc  
- borderRadius  

### Ví dụ:

```dart
class BoxAnimation extends StatefulWidget {
  const BoxAnimation({super.key});

  @override
  State<BoxAnimation> createState() => _BoxAnimationState();
}

class _BoxAnimationState extends State<BoxAnimation> {
  bool big = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: big ? 200 : 100,
      height: big ? 200 : 100,
      decoration: BoxDecoration(
        color: big ? Colors.blue : Colors.red,
        borderRadius: BorderRadius.circular(big ? 20 : 0),
      ),
      child: TextButton(
        onPressed: () => setState(() => big = !big),
        child: const Text("Nhấn tôi"),
      ),
    );
  }
}
```

→ Kích thước, màu, bo góc thay đổi *mượt* khi nhấn.

---

### 🧠 Giảng giải chi tiết: AnimatedContainer là gì?

**AnimatedContainer là gì?**

- Widget tự động **animate** khi các thuộc tính thay đổi
- Giống Container nhưng có animation
- Rất mạnh mẽ và dễ sử dụng
- Tự động tạo các frame trung gian

**Cấu trúc AnimatedContainer:**

```
AnimatedContainer
├── duration (Duration) - Thời gian animation
├── curve (Curve) - Đường cong tốc độ
├── width / height - Kích thước
├── padding / margin - Khoảng cách
├── color / decoration - Màu sắc, border
└── child - Nội dung
```

**Ví dụ minh họa từng bước:**

```dart
class _BoxAnimationState extends State<BoxAnimation> {
  // BƯỚC 1: State để điều khiển animation
  bool isBig = false;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // BƯỚC 2: Duration - Thời gian animation
      duration: Duration(milliseconds: 500),  // 500ms
      
      // BƯỚC 3: Curve - Đường cong tốc độ
      curve: Curves.easeInOut,  // Nhanh → chậm → nhanh
      
      // BƯỚC 4: Các thuộc tính thay đổi
      width: isBig ? 200 : 100,   // Từ 100 → 200
      height: isBig ? 200 : 100,  // Từ 100 → 200
      
      // BƯỚC 5: Decoration - Màu, border
      decoration: BoxDecoration(
        color: isBig ? Colors.blue : Colors.red,  // Đổi màu
        borderRadius: BorderRadius.circular(isBig ? 20 : 0),  // Bo góc
      ),
      
      // BƯỚC 6: Child - Nội dung
      child: Center(
        child: TextButton(
          onPressed: () {
            // BƯỚC 7: Thay đổi state → Animation tự động chạy
            setState(() {
              isBig = !isBig;  // false → true
            });
          },
          child: Text("Nhấn tôi"),
        ),
      ),
    );
  }
}
```

**Các thuộc tính có thể animate:**

```dart
AnimatedContainer(
  // Kích thước
  width: isBig ? 200 : 100,
  height: isBig ? 200 : 100,
  
  // Khoảng cách
  padding: EdgeInsets.all(isBig ? 20 : 10),
  margin: EdgeInsets.all(isBig ? 10 : 5),
  
  // Màu sắc
  color: isBig ? Colors.blue : Colors.red,
  
  // Decoration
  decoration: BoxDecoration(
    color: isBig ? Colors.blue : Colors.red,
    borderRadius: BorderRadius.circular(isBig ? 20 : 0),
    border: Border.all(
      width: isBig ? 3 : 1,
      color: isBig ? Colors.black : Colors.grey,
    ),
  ),
  
  // Transform
  transform: Matrix4.rotationZ(isBig ? 0.1 : 0),
)
```

**Ví dụ minh họa: AnimatedContainer với các biến thể**

```dart
// 1. Animate kích thước
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: isExpanded ? 300 : 100,
  height: isExpanded ? 300 : 100,
  color: Colors.blue,
)

// 2. Animate màu sắc
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  width: 200,
  height: 200,
  color: isSelected ? Colors.green : Colors.grey,
)

// 3. Animate border radius
AnimatedContainer(
  duration: Duration(milliseconds: 400),
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(isRounded ? 100 : 0),  // Tròn → vuông
  ),
)

// 4. Animate padding
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  padding: EdgeInsets.all(isPressed ? 20 : 10),
  child: Text("Content"),
)

// 5. Animate nhiều thuộc tính cùng lúc
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  width: isBig ? 200 : 100,
  height: isBig ? 200 : 100,
  decoration: BoxDecoration(
    color: isBig ? Colors.blue : Colors.red,
    borderRadius: BorderRadius.circular(isBig ? 20 : 0),
  ),
  padding: EdgeInsets.all(isBig ? 20 : 10),
)
```

---

# 3. **AnimatedOpacity – hiệu ứng Fade In / Fade Out**

```dart
AnimatedOpacity(
  duration: const Duration(milliseconds: 400),
  opacity: isVisible ? 1 : 0,
  child: const Text("Xin chào!"),
);
```

Lý tưởng cho:

- fade chữ  
- fade avatar  
- hiệu ứng xuất hiện ảnh/banner  

---

### 🧠 Giảng giải chi tiết: AnimatedOpacity là gì?

**AnimatedOpacity là gì?**

- Widget làm widget **mờ dần** hoặc **hiện dần**
- opacity = 0 → hoàn toàn trong suốt (ẩn)
- opacity = 1 → hoàn toàn rõ ràng (hiện)
- Rất phổ biến cho fade in/out

**Ví dụ minh họa từng bước:**

```dart
class FadeDemo extends StatefulWidget {
  @override
  State<FadeDemo> createState() => _FadeDemoState();
}

class _FadeDemoState extends State<FadeDemo> {
  // BƯỚC 1: State điều khiển opacity
  bool isVisible = true;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // BƯỚC 2: AnimatedOpacity
        AnimatedOpacity(
          // Duration: Thời gian fade
          duration: Duration(milliseconds: 400),
          
          // Opacity: 0 (ẩn) → 1 (hiện)
          opacity: isVisible ? 1.0 : 0.0,
          
          // Child: Widget cần fade
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Center(child: Text("Fade me")),
          ),
        ),
        
        // BƯỚC 3: Button để toggle
        ElevatedButton(
          onPressed: () {
            setState(() {
              isVisible = !isVisible;  // Toggle
            });
          },
          child: Text(isVisible ? "Ẩn" : "Hiện"),
        ),
      ],
    );
  }
}
```

**Các giá trị opacity:**

```dart
opacity: 0.0  // Hoàn toàn trong suốt (ẩn)
opacity: 0.5  // Mờ 50%
opacity: 1.0  // Hoàn toàn rõ ràng (hiện)
```

**Ví dụ minh họa: AnimatedOpacity với các biến thể**

```dart
// 1. Fade in khi load
AnimatedOpacity(
  duration: Duration(milliseconds: 500),
  opacity: isLoaded ? 1.0 : 0.0,
  child: Image.network("https://..."),
)

// 2. Fade out khi xóa
AnimatedOpacity(
  duration: Duration(milliseconds: 300),
  opacity: isDeleted ? 0.0 : 1.0,
  child: ListTile(...),
)

// 3. Fade với curve
AnimatedOpacity(
  duration: Duration(milliseconds: 400),
  curve: Curves.easeInOut,
  opacity: isVisible ? 1.0 : 0.0,
  child: Text("Hello"),
)
```

---

# 4. **AnimatedAlign – di chuyển widget mượt mà**

```dart
AnimatedAlign(
  duration: const Duration(milliseconds: 500),
  alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
  child: const Icon(Icons.circle, size: 40),
);
```

Ứng dụng thực:

- button chuyển trạng thái  
- nút toggle  
- timeline animation  

---

### 🧠 Giảng giải chi tiết: AnimatedAlign là gì?

**AnimatedAlign là gì?**

- Widget **di chuyển** child đến vị trí khác mượt mà
- Thay đổi alignment → child di chuyển
- Rất phổ biến cho toggle switch, slider

**Ví dụ minh họa từng bước:**

```dart
class ToggleSwitch extends StatefulWidget {
  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  // BƯỚC 1: State điều khiển vị trí
  bool isOn = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;  // Toggle
        });
      },
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: isOn ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        // BƯỚC 2: AnimatedAlign di chuyển circle
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          // Alignment: Trái → Phải
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          // Child: Circle di chuyển
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
```

**Các alignment phổ biến:**

```dart
Alignment.centerLeft      // Giữa trái
Alignment.centerRight     // Giữa phải
Alignment.topCenter       // Trên giữa
Alignment.bottomCenter    // Dưới giữa
Alignment.topLeft         // Trên trái
Alignment.bottomRight     // Dưới phải
```

---

# 5. **AnimatedDefaultTextStyle – đổi style chữ mượt**

```dart
AnimatedDefaultTextStyle(
  duration: const Duration(milliseconds: 400),
  style: TextStyle(
    fontSize: big ? 30 : 18,
    color: big ? Colors.blue : Colors.black,
  ),
  child: const Text("Flutter"),
);
```

---

### 🧠 Giảng giải chi tiết: AnimatedDefaultTextStyle là gì?

**AnimatedDefaultTextStyle là gì?**

- Widget **animate style** của text
- Thay đổi fontSize, color, fontWeight mượt mà
- Rất hữu ích cho text động

**Ví dụ minh họa:**

```dart
class AnimatedText extends StatefulWidget {
  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  bool isBig = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isBig = !isBig;
        });
      },
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 400),
        style: TextStyle(
          fontSize: isBig ? 30 : 18,  // Font size thay đổi
          color: isBig ? Colors.blue : Colors.black,  // Màu thay đổi
          fontWeight: isBig ? FontWeight.bold : FontWeight.normal,
        ),
        child: Text("Flutter"),
      ),
    );
  }
}
```

---

# 6. **Curves – cách làm animation "mượt có style"**

Curves là *đồ thị tốc độ*: nhanh–chậm–nhanh, hoặc chậm–nhanh–chậm.

Ví dụ phổ biến:

- Curves.easeIn  
- Curves.easeOut  
- Curves.easeInOut  
- Curves.bounceOut  
- Curves.elasticOut  

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeInOut,
  ...
);
```

---

### 🧠 Giảng giải chi tiết: Curves là gì?

**Curves là gì?**

- **Đường cong tốc độ** của animation
- Quyết định animation **nhanh/chậm** ở phần nào
- Tạo cảm giác **tự nhiên** hoặc **đặc biệt**

**Các loại Curves phổ biến:**

```dart
// 1. Linear - Tốc độ đều
curve: Curves.linear
// 0% → 50% → 100% (tốc độ đều)

// 2. EaseIn - Chậm → Nhanh
curve: Curves.easeIn
// 0% (chậm) → 100% (nhanh)

// 3. EaseOut - Nhanh → Chậm
curve: Curves.easeOut
// 0% (nhanh) → 100% (chậm)

// 4. EaseInOut - Chậm → Nhanh → Chậm
curve: Curves.easeInOut
// 0% (chậm) → 50% (nhanh) → 100% (chậm)

// 5. BounceOut - Nảy
curve: Curves.bounceOut
// 0% → 100% → Nảy lại một chút

// 6. ElasticOut - Đàn hồi
curve: Curves.elasticOut
// 0% → 100% → Đàn hồi qua lại
```

**Ví dụ minh họa: So sánh các Curves**

```dart
// Linear - Đều
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.linear,  // Tốc độ đều
  width: isBig ? 200 : 100,
)

// EaseInOut - Tự nhiên nhất
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,  // Chậm → Nhanh → Chậm
  width: isBig ? 200 : 100,
)

// BounceOut - Vui nhộn
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.bounceOut,  // Nảy
  width: isBig ? 200 : 100,
)
```

**Khi nào dùng Curve nào?**

| Curve | Khi nào dùng | Ví dụ |
|-------|-------------|-------|
| **linear** | Tốc độ đều | Progress bar |
| **easeInOut** | Tự nhiên (khuyến nghị) | Hầu hết animation |
| **easeOut** | Xuất hiện nhanh | Fade in, slide in |
| **easeIn** | Biến mất nhanh | Fade out, slide out |
| **bounceOut** | Vui nhộn, nổi bật | Button press, notification |
| **elasticOut** | Đàn hồi, đặc biệt | Special effects |

---

# 7. **Tween + AnimationController – animation "toàn quyền kiểm soát"**

Chỉ dùng khi bạn cần animation tùy chỉnh nâng cao.

### Ví dụ Tween basic:

```dart
class TweenDemo extends StatefulWidget {
  const TweenDemo({super.key});

  @override
  State<TweenDemo> createState() => _TweenDemoState();
}

class _TweenDemoState extends State<TweenDemo> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnim,
      child: const Text("Fade với AnimationController"),
    );
  }
}
```

---

### 🧠 Giảng giải chi tiết: Tween + AnimationController là gì?

**AnimationController là gì?**

- **Điều khiển** animation (bắt đầu, dừng, lặp lại)
- Cung cấp giá trị từ 0.0 → 1.0 theo thời gian
- Cần `vsync` để tối ưu performance

**Tween là gì?**

- **Chuyển đổi** giá trị từ A → B
- Tween(0, 1) → chuyển từ 0 đến 1
- Tween(100, 200) → chuyển từ 100 đến 200

**Cơ chế hoạt động:**

```
AnimationController
    ↓ (cung cấp giá trị 0.0 → 1.0)
Tween(begin: 0, end: 1)
    ↓ (chuyển đổi giá trị)
Animation object
    ↓ (giá trị thay đổi)
Widget rebuild với giá trị mới
```

**Ví dụ minh họa từng bước:**

```dart
class TweenDemo extends StatefulWidget {
  @override
  State<TweenDemo> createState() => _TweenDemoState();
}

class _TweenDemoState extends State<TweenDemo> 
    with SingleTickerProviderStateMixin {  // ← QUAN TRỌNG: Mixin này
  
  // BƯỚC 1: Khai báo Controller và Animation
  late AnimationController controller;
  late Animation<double> opacityAnim;
  
  @override
  void initState() {
    super.initState();
    
    // BƯỚC 2: Tạo AnimationController
    controller = AnimationController(
      duration: Duration(seconds: 1),  // Thời gian animation
      vsync: this,  // ← QUAN TRỌNG: this (vì có SingleTickerProviderStateMixin)
    );
    
    // BƯỚC 3: Tạo Tween và Animation
    opacityAnim = Tween<double>(
      begin: 0.0,  // Giá trị bắt đầu
      end: 1.0,    // Giá trị kết thúc
    ).animate(controller);  // Gắn với controller
    
    // BƯỚC 4: Bắt đầu animation
    controller.forward();  // 0.0 → 1.0
  }
  
  @override
  void dispose() {
    // BƯỚC 5: QUAN TRỌNG: Dispose controller
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // BƯỚC 6: Sử dụng Animation
    return FadeTransition(
      opacity: opacityAnim,  // ← Giá trị thay đổi từ 0 → 1
      child: Text("Fade với AnimationController"),
    );
  }
}
```

**Các method của AnimationController:**

```dart
controller.forward();      // Chạy từ 0 → 1
controller.reverse();      // Chạy từ 1 → 0
controller.repeat();        // Lặp lại
controller.stop();          // Dừng
controller.reset();         // Reset về 0
controller.animateTo(0.5);  // Chạy đến giá trị cụ thể
```

**Ví dụ minh họa: Tween với các kiểu dữ liệu**

```dart
// 1. Tween<double> - Opacity, size
Animation<double> opacityAnim = Tween<double>(begin: 0, end: 1).animate(controller);
Animation<double> sizeAnim = Tween<double>(begin: 100, end: 200).animate(controller);

// 2. Tween<Color> - Màu sắc
Animation<Color?> colorAnim = ColorTween(
  begin: Colors.red,
  end: Colors.blue,
).animate(controller);

// 3. Tween<Alignment> - Vị trí
Animation<Alignment> alignAnim = AlignmentTween(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
).animate(controller);

// 4. Tween<Offset> - Vị trí tọa độ
Animation<Offset> offsetAnim = Tween<Offset>(
  begin: Offset(0, 0),
  end: Offset(100, 100),
).animate(controller);
```

**Ví dụ minh họa: Animation với listener**

```dart
@override
void initState() {
  super.initState();
  controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );
  
  opacityAnim = Tween<double>(begin: 0, end: 1).animate(controller);
  
  // Lắng nghe thay đổi giá trị
  opacityAnim.addListener(() {
    setState(() {
      // Rebuild khi giá trị thay đổi
    });
  });
  
  // Lắng nghe khi animation hoàn thành
  controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      print("Animation hoàn thành!");
    }
  });
  
  controller.forward();
}
```

---

# 8. **Hero Animation – hiệu ứng chuyển cảnh "bay"**
*(Chuyển động liền mạch giữa 2 màn hình)*

Bạn có thấy khi bấm vào một ảnh danh sách, nó "bay" và phóng to sang màn hình chi tiết không?
Đó là **Hero Animation**.

### Code mẫu:

```dart
// Màn hình 1 (Danh sách)
Hero(
  tag: "product_123", // Tag phải DUY NHẤT
  child: Image.network("https://picsum.photos/200"),
)

// Màn hình 2 (Chi tiết)
Hero(
  tag: "product_123", // Tag trùng với màn hình 1
  child: Image.network("https://picsum.photos/800"),
)
```

---

### 🧠 Giảng giải chi tiết: Hero là gì?

**Hero là gì?**
- Widget giúp **chuyển tiếp** 1 element từ màn hình A sang màn hình B.
- Element sẽ "bay" và biến đổi kích thước mượt mà giữa 2 màn hình.
- **Quan trọng nhất**: `tag` phải giống hệt nhau ở 2 màn hình.

**Ví dụ thực tế:**
- Avatar ở danh sách -> Avatar to ở trang cá nhân.
- Ảnh bìa sách -> Poster to ở chi tiết sách.
- Nút FAB (Floating Action Button) -> Biến thành Card (Dialog).

---

# 9. **Sai vs Đúng – các lỗi sinh viên cực hay mắc**

## ❌ Sai: animation không chạy vì thiếu setState

```dart
big = !big;  // UI không biết thay đổi!
```

---

### 🔍 Giảng giải chi tiết: Tại sao cần setState?

**Ví dụ minh họa lỗi:**

```dart
class WrongAnimation extends StatefulWidget {
  @override
  State<WrongAnimation> createState() => _WrongAnimationState();
}

class _WrongAnimationState extends State<WrongAnimation> {
  bool isBig = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ❌ SAI: Quên setState
        isBig = !isBig;  // State thay đổi nhưng Flutter không biết!
        // Animation không chạy!
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: isBig ? 200 : 100,  // Giá trị thay đổi nhưng UI không rebuild
        height: isBig ? 200 : 100,
        color: Colors.blue,
      ),
    );
  }
}

// Vấn đề:
// - State thay đổi nhưng không gọi setState
// - Flutter không biết cần rebuild
// - AnimatedContainer không nhận giá trị mới
// → Animation không chạy!
```

**✅ Giải pháp:**

```dart
onTap: () {
  // ✅ ĐÚNG: Có setState
  setState(() {
    isBig = !isBig;  // Flutter biết cần rebuild
  });
  // AnimatedContainer nhận giá trị mới → Animation chạy!
}
```

---

## ✔ Đúng:

```dart
setState(() => big = !big);
```

---

## ❌ Sai: dùng AnimationController mà quên dispose  
→ *memory leak*

---

### 🔍 Giảng giải chi tiết: Tại sao cần dispose AnimationController?

**Ví dụ minh họa lỗi:**

```dart
class WrongController extends StatefulWidget {
  @override
  State<WrongController> createState() => _WrongControllerState();
}

class _WrongControllerState extends State<WrongController> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController controller;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    // ❌ SAI: Quên dispose trong dispose()
  }
  
  @override
  void dispose() {
    // Quên controller.dispose()!
    super.dispose();
    // → Memory leak! Controller vẫn chạy ngầm!
  }
}

// Vấn đề:
// - AnimationController tạo ticker (vẽ lại liên tục)
// - Không dispose → ticker vẫn chạy ngay cả khi widget bị xóa
// - Gây memory leak, tốn pin, app lag
```

**✅ Giải pháp:**

```dart
@override
void dispose() {
  // ✅ ĐÚNG: Dispose controller
  controller.dispose();  // ← QUAN TRỌNG!
  super.dispose();
}
```

---

## ✔ Đúng:

```dart
dispose() {
  controller.dispose();
  super.dispose();
}
```

---

## ❌ Sai: duration quá dài → không giống animation mà giống lag  
→ 300–600 ms là đẹp nhất  
→ >1500 ms trông "lụt nghề"

---

### 🔍 Giảng giải chi tiết: Duration phù hợp

**Ví dụ minh họa:**

```dart
// ❌ SAI: Duration quá dài
AnimatedContainer(
  duration: Duration(seconds: 3),  // ← Quá dài! Giống lag
  width: isBig ? 200 : 100,
)

// ❌ SAI: Duration quá ngắn
AnimatedContainer(
  duration: Duration(milliseconds: 50),  // ← Quá nhanh! Không thấy animation
  width: isBig ? 200 : 100,
)

// ✅ ĐÚNG: Duration phù hợp
AnimatedContainer(
  duration: Duration(milliseconds: 300),  // ← Vừa phải
  width: isBig ? 200 : 100,
)
```

**Bảng tham khảo Duration:**

| Loại animation | Duration khuyến nghị | Ví dụ |
|----------------|---------------------|-------|
| **Nhanh** | 150-300ms | Button press, toggle |
| **Vừa** | 300-600ms | Fade, slide, resize |
| **Chậm** | 600-1000ms | Page transition |
| **Rất chậm** | >1000ms | Chỉ dùng cho special effects |

---

## ❌ Sai: AnimatedContainer lồng nhau gây xung đột thuộc tính  
→ tách ra rõ ràng

---

### 🔍 Giảng giải chi tiết: Vấn đề AnimatedContainer lồng nhau

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: AnimatedContainer lồng nhau
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  width: isBig ? 200 : 100,
  child: AnimatedContainer(  // ← Lồng nhau
    duration: Duration(milliseconds: 300),  // Duration khác nhau
    height: isBig ? 200 : 100,
    child: Text("Content"),
  ),
)

// Vấn đề:
// - 2 animation chạy với duration khác nhau
// - Có thể gây xung đột, không mượt
// - Khó debug
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Tách ra rõ ràng
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  width: isBig ? 200 : 100,
  height: isBig ? 200 : 100,  // ← Cùng container
  child: Text("Content"),
)

// Hoặc dùng AnimatedSize cho size riêng
AnimatedSize(
  duration: Duration(milliseconds: 500),
  child: Container(
    width: isBig ? 200 : 100,
    child: Text("Content"),
  ),
)
```

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: Quên SingleTickerProviderStateMixin

#### ❌ Vấn đề:

```dart
class WrongDemo extends StatefulWidget {
  @override
  State<WrongDemo> createState() => _WrongDemoState();
}

class _WrongDemoState extends State<WrongDemo> {  // ← Quên mixin!
  late AnimationController controller;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,  // ← Lỗi! this không có TickerProvider
    );
  }
}
```

#### ✅ Giải pháp:

```dart
class _WrongDemoState extends State<WrongDemo> 
    with SingleTickerProviderStateMixin {  // ← Có mixin!
  // ...
}
```

---

### Case Study 2: Animation chạy ngay khi build

#### ❌ Vấn đề:

```dart
@override
void initState() {
  super.initState();
  controller = AnimationController(...);
  controller.forward();  // ← Chạy ngay khi build
  // User chưa thấy gì đã chạy xong!
}
```

#### ✅ Giải pháp:

```dart
@override
void initState() {
  super.initState();
  controller = AnimationController(...);
  // Không forward() ở đây
  // Chờ user action hoặc dùng Future.delayed
}

void startAnimation() {
  controller.forward();  // Chạy khi cần
}
```

---

### Case Study 3: Dùng AnimatedContainer cho animation phức tạp

#### ❌ Vấn đề:

```dart
// ❌ SAI: Dùng AnimatedContainer cho animation phức tạp
AnimatedContainer(
  duration: Duration(milliseconds: 500),
  transform: Matrix4.rotationZ(angle),  // ← Phức tạp
  child: ...,
)
```

#### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Dùng AnimationController + Transform
Transform.rotate(
  angle: rotationAnim.value,  // ← Dùng AnimationController
  child: ...,
)
```

---

# 10. **Các ví dụ thực tế đa dạng**

## 9.1. **Ví dụ: Button phóng to thu nhỏ**

```dart
class AnimateButton extends StatefulWidget {
  const AnimateButton({super.key});

  @override
  State<AnimateButton> createState() => _AnimateButtonState();
}

class _AnimateButtonState extends State<AnimateButton> {
  bool big = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: big ? 200 : 120,
        height: big ? 60 : 40,
        child: ElevatedButton(
          onPressed: () => setState(() => big = !big),
          child: const Text("Nhấn"),
        ),
      ),
    );
  }
}
```

---

## 9.2. **Ví dụ: Card sản phẩm với scale effect**

```dart
class ProductCard extends StatefulWidget {
  final Product product;
  
  ProductCard({required this.product});
  
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(isPressed ? 0.95 : 1.0),  // Scale down khi nhấn
        child: Card(
          elevation: isPressed ? 2 : 8,
          child: Column(
            children: [
              Image.network(widget.product.image),
              Text(widget.product.name),
              Text("${widget.product.price} đ"),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 9.3. **Ví dụ: Fade in logo khi mở app**

```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnim;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    
    controller.forward();
    
    // Navigate sau khi animation xong
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Center(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}
```

---

## 9.4. **Ví dụ: Toggle switch với AnimatedAlign**

```dart
class ToggleSwitch extends StatefulWidget {
  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isOn = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: isOn ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 9.5. **Ví dụ: Loading indicator với rotation**

```dart
class LoadingIndicator extends StatefulWidget {
  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();  // Lặp lại vô hạn
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller,  // 0.0 → 1.0 (360 độ)
      child: Icon(Icons.refresh, size: 40),
    );
  }
}
```

---

## 9.6. **Ví dụ: Slide in từ cạnh**

```dart
class SlideInMenu extends StatefulWidget {
  @override
  State<SlideInMenu> createState() => _SlideInMenuState();
}

class _SlideInMenuState extends State<SlideInMenu> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnim;
  bool isOpen = false;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    slideAnim = Tween<Offset>(
      begin: Offset(-1, 0),  // Bên trái (ngoài màn hình)
      end: Offset(0, 0),      // Vị trí bình thường
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  void toggle() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnim,
      child: Container(
        width: 250,
        color: Colors.white,
        child: ListView(
          children: [
            ListTile(title: Text("Menu 1")),
            ListTile(title: Text("Menu 2")),
            ListTile(title: Text("Menu 3")),
          ],
        ),
      ),
    );
  }
}
```

---

# 11. **Best Practices**

## 10.1. **Khi nào dùng widget animation nào?**

| Widget | Khi nào dùng | Ví dụ |
|--------|-------------|-------|
| **AnimatedContainer** | Animate nhiều thuộc tính cùng lúc | Size, color, border radius |
| **AnimatedOpacity** | Fade in/out | Hiện/ẩn text, image |
| **AnimatedAlign** | Di chuyển vị trí | Toggle switch, slider |
| **AnimatedDefaultTextStyle** | Animate text style | Font size, color thay đổi |
| **AnimationController + Tween** | Animation phức tạp, tùy chỉnh | Rotation, scale, custom |

## 10.2. **Best Practices**

### 1. Duration phù hợp

```dart
// ✅ ĐÚNG: 300-600ms cho hầu hết animation
AnimatedContainer(
  duration: Duration(milliseconds: 400),
  ...
)

// ❌ SAI: Quá dài hoặc quá ngắn
AnimatedContainer(
  duration: Duration(seconds: 3),  // Quá dài
  ...
)
```

### 2. Luôn dispose AnimationController

```dart
@override
void dispose() {
  controller.dispose();  // ← QUAN TRỌNG!
  super.dispose();
}
```

### 3. Dùng setState khi thay đổi state

```dart
// ✅ ĐÚNG
setState(() {
  isBig = !isBig;
})

// ❌ SAI
isBig = !isBig;  // Quên setState
```

### 4. Chọn Curve phù hợp

```dart
// ✅ ĐÚNG: easeInOut cho hầu hết
AnimatedContainer(
  curve: Curves.easeInOut,  // Tự nhiên
  ...
)

// ✅ ĐÚNG: bounceOut cho button press
AnimatedContainer(
  curve: Curves.bounceOut,  // Vui nhộn
  ...
)
```

### 5. Tránh animation quá nhiều cùng lúc

```dart
// ❌ SAI: Quá nhiều animation
AnimatedContainer(...)
AnimatedOpacity(...)
AnimatedAlign(...)
// → Có thể gây lag

// ✅ ĐÚNG: Tối ưu, chỉ animate cần thiết
AnimatedContainer(
  // Animate nhiều thuộc tính trong 1 widget
  width: ...,
  height: ...,
  color: ...,
)
```

---

# 11. Bài tập thực hành

1. Tạo box đổi màu + đổi kích thước bằng AnimatedContainer.  
2. Tạo nút “Hiện/ẩn” chữ bằng AnimatedOpacity.  
3. Làm slider chuyển vị trí icon bằng AnimatedAlign.  
4. Tạo card sản phẩm khi nhấn sẽ “phóng to” nhẹ (scale effect).  
5. Tạo hiệu ứng fade-in logo khi mở app bằng Tween + AnimationController.

---

# 12. Mini Test cuối chương

**Câu 1:** AnimatedContainer dùng để animate gì?  
→ kích thước, màu, border, padding…

**Câu 2:** opacity = 0 nghĩa là gì?  
→ hoàn toàn trong suốt (ẩn).

**Câu 3:** Curves dùng để làm gì?  
→ điều chỉnh độ mượt/tốc độ animation.

**Câu 4:** AnimationController phải làm gì khi không dùng nữa?  
→ dispose.

**Câu 5:** Tween dùng để làm gì?  
→ chuyển giá trị từ A → B theo thời gian.

**Câu 6:** Tại sao animation không chạy khi thiếu setState?  
→ Flutter không biết cần rebuild UI với giá trị mới.

**Câu 7:** SingleTickerProviderStateMixin dùng để làm gì?  
→ Cung cấp vsync cho AnimationController.

**Câu 8:** Duration bao nhiêu là phù hợp cho hầu hết animation?  
→ 300-600ms.

**Câu 9:** Curves.easeInOut khác gì với Curves.linear?  
→ easeInOut: chậm → nhanh → chậm, linear: tốc độ đều.

**Câu 10:** Khi nào nên dùng AnimationController thay vì AnimatedContainer?  
→ Khi cần animation phức tạp, tùy chỉnh, hoặc điều khiển chi tiết.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **AnimatedContainer** = animation đơn giản mạnh nhất (size, color, border).  
- **AnimatedOpacity** = fade in/out dễ nhất (opacity 0-1).  
- **AnimatedAlign** giúp di chuyển nhẹ nhàng (toggle, slider).  
- **Curves** tạo cảm giác mượt và tự nhiên (easeInOut khuyến nghị).  
- **Tween + Controller** dành cho animation nâng cao (rotation, scale, custom).  
- **Luôn setState()** khi thay đổi state để animation chạy.  
- **Luôn dispose()** AnimationController để tránh memory leak.  
- **Duration 300-600ms** là phù hợp cho hầu hết animation.  
- **SingleTickerProviderStateMixin** cần thiết khi dùng AnimationController.  
- **Tránh animation quá nhiều** cùng lúc để tránh lag.  

---

# 🎉 Kết thúc chương 13  
Tiếp theo là chương giúp app của bạn tương tác với người dùng mạnh mẽ hơn:

👉 **Chương 14 – Gesture & Interaction (Tap, DoubleTap, LongPress, Drag)**


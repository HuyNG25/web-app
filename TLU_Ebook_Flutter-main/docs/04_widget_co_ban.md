# 🟦 CHƯƠNG 04  
# **WIDGET CƠ BẢN TRONG FLUTTER**  
*(StatelessWidget – StatefulWidget – Text – Button – Layout cơ bản)*

Đây là chương quan trọng nhất dành cho người mới.  
Flutter = Widgets.  
Hiểu Widgets = biết Flutter.

Trong chương này, bạn sẽ học cách tạo giao diện bằng những widget cơ bản nhất nhưng dùng *suốt đời*.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn có thể:

- Hiểu StatelessWidget & StatefulWidget.  
- Xây UI bằng Text, Image, Icon, Button.  
- Sử dụng Column, Row, Center, Container.  
- Biết style cơ bản của các widget.  
- Tránh lỗi thường gặp khi viết UI.  
- Tự xây một màn hình UI đơn giản.

---

# 1. **Widget là gì? (Giải thích dễ nhất)**

Widget = mảnh ghép nhỏ tạo thành giao diện Flutter.

- Text → widget  
- Button → widget  
- Image → widget  
- ListView → widget  
- App → cũng là widget  

Flutter xây dựng toàn bộ UI bằng việc lắp ghép các widget này lại.

---

### 🧠 Lý thuyết chi tiết về Widget

**Widget trong Flutter:**

- **Mọi thứ đều là Widget**: Text, Button, Image, Layout, thậm chí cả App
- **Widget tree**: Các widget lồng nhau tạo thành cây widget
- **Immutable**: Widget không thể thay đổi trực tiếp, phải tạo widget mới
- **Composition**: Widget lớn được tạo từ nhiều widget nhỏ

**Cấu trúc Widget Tree:**

```
MaterialApp (Widget gốc)
└── Scaffold
    ├── AppBar
    └── Body
        └── Column
            ├── Text
            ├── Image
            └── ElevatedButton
```

**Các loại Widget:**

1. **StatelessWidget** - Widget không thay đổi
2. **StatefulWidget** - Widget có thể thay đổi
3. **Layout Widgets** - Column, Row, Stack, Container
4. **Display Widgets** - Text, Image, Icon
5. **Input Widgets** - Button, TextField, Switch

**Widget Lifecycle:**

```
StatelessWidget:
  build() → Render

StatefulWidget:
  createState() → initState() → build() → setState() → build() → dispose()
```

---

### 🎒 Ví dụ đời sống  
Widget giống như **LEGO**:  
Bạn ráp nhiều mảnh nhỏ → thành 1 công trình lớn.

**Ví dụ minh họa:**

```dart
// Widget đơn giản
Text("Hello")

// Widget phức tạp (từ nhiều widget nhỏ)
Card(
  child: Column(
    children: [
      Image.network("..."),
      Text("Title"),
      ElevatedButton(...),
    ],
  ),
)
```

---

# 2. StatelessWidget – UI không thay đổi

Dùng khi UI **không có trạng thái**, không cần cập nhật lại.

Ví dụ:  
- tiêu đề  
- banner  
- logo  
- nội dung tĩnh  

---

### 🧠 Lý thuyết chi tiết về StatelessWidget

**StatelessWidget là gì?**

- Widget **không có state** (trạng thái)
- UI **không thay đổi** sau khi được tạo
- **Nhẹ hơn** StatefulWidget (performance tốt hơn)
- Chỉ có 1 method: `build()`

**Khi nào dùng StatelessWidget:**

- ✅ Widget chỉ hiển thị dữ liệu từ parent
- ✅ UI tĩnh, không thay đổi
- ✅ Không cần quản lý state nội bộ
- ✅ Performance tốt hơn StatefulWidget

**Cấu trúc:**

```dart
class MyWidget extends StatelessWidget {
  // Constructor
  const MyWidget({super.key});
  
  // Method duy nhất: build
  @override
  Widget build(BuildContext context) {
    return Widget(...);
  }
}
```

**Lưu ý quan trọng:**

- Luôn dùng `const` constructor nếu có thể
- `build()` được gọi mỗi khi parent rebuild
- Không thể thay đổi UI sau khi build (phải tạo widget mới)

---

### 📌 Ví dụ:

```dart
class HelloText extends StatelessWidget {
  const HelloText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Xin chào Flutter!",
      style: TextStyle(fontSize: 20),
    );
  }
}
```

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Product Card (StatelessWidget)

```dart
class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  const ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          Text(name),
          Text("${price.toStringAsFixed(0)} đ"),
        ],
      ),
    );
  }
}
```

#### 2. Profile Header (StatelessWidget)

```dart
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(height: 16),
        Text(name, style: const TextStyle(fontSize: 24)),
        Text(email),
      ],
    );
  }
}
```

---

# 3. StatefulWidget – UI thay đổi theo trạng thái

Dùng khi UI **có giá trị thay đổi**, ví dụ:

- Counter (tăng giảm số)  
- Form nhập liệu  
- Switch, Checkbox  
- API loading  

---

### 🧠 Lý thuyết chi tiết về StatefulWidget

**StatefulWidget là gì?**

- Widget **có state** (trạng thái)
- UI **có thể thay đổi** sau khi được tạo
- Gồm 2 phần: **StatefulWidget** (khung) + **State** (logic)
- Dùng `setState()` để cập nhật UI

**Khi nào dùng StatefulWidget:**

- ✅ UI thay đổi theo user interaction
- ✅ Cần quản lý state nội bộ
- ✅ Form input, counter, toggle
- ✅ Loading state, error state

**Cấu trúc:**

```dart
// 1. StatefulWidget (khung)
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// 2. State (logic + UI)
class _MyWidgetState extends State<MyWidget> {
  // State variables
  int count = 0;
  
  // Methods
  void increment() {
    setState(() {
      count++;
    });
  }
  
  // Build method
  @override
  Widget build(BuildContext context) {
    return Widget(...);
  }
}
```

**setState() - Quan trọng:**

- **BẮT BUỘC** gọi `setState()` khi muốn cập nhật UI
- Chỉ thay đổi state **bên trong** setState
- `setState()` trigger `build()` để rebuild UI

---

### 📌 Ví dụ:

```dart
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int count = 0;

  void increase() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Count: $count"),
        ElevatedButton(
          onPressed: increase,
          child: const Text("Tăng"),
        )
      ],
    );
  }
}
```

> **Ghi nhớ:** mọi thay đổi UI trong StatefulWidget phải gọi `setState()`.

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Toggle Switch

```dart
class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isEnabled,
      onChanged: (value) {
        setState(() {
          isEnabled = value;
        });
      },
    );
  }
}
```

#### 2. Like Button với Counter

```dart
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: toggleLike,
        ),
        Text("$likeCount likes"),
      ],
    );
  }
}
```

---

# 4. Các widget cơ bản bạn sẽ dùng suốt đời

## 4.1. Text – hiển thị chữ

```dart
Text(
  "Hello!",
  style: TextStyle(
    fontSize: 24,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
);
```

---

### 🧠 Lý thuyết chi tiết về Text

**Text Widget:**

- Hiển thị chuỗi ký tự
- Có thể style: font, size, color, weight
- Có thể xử lý overflow: ellipsis, fade, clip

**Thuộc tính quan trọng:**

```dart
Text(
  "Nội dung",
  style: TextStyle(
    fontSize: 16,           // Kích thước chữ
    color: Colors.black,    // Màu chữ
    fontWeight: FontWeight.bold, // Độ đậm
    fontStyle: FontStyle.italic,  // Nghiêng
    letterSpacing: 1.0,    // Khoảng cách chữ
    wordSpacing: 2.0,      // Khoảng cách từ
    height: 1.5,           // Chiều cao dòng
    decoration: TextDecoration.underline, // Gạch chân
  ),
  textAlign: TextAlign.center, // Căn chỉnh
  maxLines: 2,             // Số dòng tối đa
  overflow: TextOverflow.ellipsis, // Xử lý tràn
)
```

**TextOverflow:**

- `TextOverflow.ellipsis` - Hiển thị "..."
- `TextOverflow.fade` - Mờ dần
- `TextOverflow.clip` - Cắt bớt
- `TextOverflow.visible` - Hiển thị đầy đủ (có thể tràn)

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Text với các style khác nhau

```dart
Column(
  children: [
    Text("Bold Text", style: TextStyle(fontWeight: FontWeight.bold)),
    Text("Italic Text", style: TextStyle(fontStyle: FontStyle.italic)),
    Text("Underline", style: TextStyle(decoration: TextDecoration.underline)),
    Text("Strikethrough", style: TextStyle(decoration: TextDecoration.lineThrough)),
    Text("Colored Text", style: TextStyle(color: Colors.blue)),
  ],
)
```

#### 2. Text với overflow

```dart
Container(
  width: 100,
  child: Text(
    "Text rất rất rất dài có thể bị tràn",
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
)
```

#### 3. Rich Text (nhiều style trong 1 Text)

```dart
Text.rich(
  TextSpan(
    text: "Hello ",
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(
        text: "Flutter",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: "!"),
    ],
  ),
)
```

---

## 4.2. Image – hiển thị ảnh

### Ảnh trong asset:

```dart
Image.asset("assets/images/banner.png");
```

### Ảnh từ internet:

```dart
Image.network("https://picsum.photos/200");
```

---

### 🧠 Lý thuyết chi tiết về Image

**Image Widget:**

- Hiển thị ảnh từ nhiều nguồn: asset, network, file, memory
- Có thể resize, crop, fit theo container
- Có thể xử lý loading và error

**Các loại Image:**

1. **Image.asset** - Ảnh trong assets folder
2. **Image.network** - Ảnh từ URL
3. **Image.file** - Ảnh từ file system
4. **Image.memory** - Ảnh từ bytes

**Thuộc tính quan trọng:**

```dart
Image.network(
  "https://example.com/image.jpg",
  width: 200,              // Chiều rộng
  height: 200,             // Chiều cao
  fit: BoxFit.cover,       // Cách fit ảnh
  alignment: Alignment.center, // Căn chỉnh
  repeat: ImageRepeat.noRepeat, // Lặp lại
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error); // Widget khi lỗi
  },
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator(); // Widget khi loading
  },
)
```

**BoxFit:**

- `BoxFit.cover` - Phủ kín, có thể crop
- `BoxFit.contain` - Giữ tỷ lệ, không crop
- `BoxFit.fill` - Kéo dãn đầy container
- `BoxFit.fitWidth` - Fit theo chiều rộng
- `BoxFit.fitHeight` - Fit theo chiều cao
- `BoxFit.none` - Không resize
- `BoxFit.scaleDown` - Thu nhỏ nếu cần

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Image với loading và error

```dart
Image.network(
  "https://example.com/image.jpg",
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
          : null,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.error, size: 50),
    );
  },
)
```

#### 2. Avatar tròn

```dart
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
  child: Icon(Icons.person), // Fallback nếu ảnh lỗi
)
```

#### 3. Image với placeholder

```dart
Image.network(
  "https://example.com/image.jpg",
  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  },
)
```

---

## 4.3. Icon

```dart
const Icon(
  Icons.favorite,
  color: Colors.red,
  size: 32,
);
```

---

### 🧠 Lý thuyết chi tiết về Icon

**Icon Widget:**

- Hiển thị icon từ Material Icons hoặc custom
- Có thể thay đổi size, color
- Performance tốt (vector graphics)

**Thuộc tính quan trọng:**

```dart
Icon(
  Icons.star,              // Icon name
  size: 24,                // Kích thước
  color: Colors.blue,      // Màu sắc
  semanticLabel: "Star",   // Accessibility label
)
```

**Các loại Icon:**

- **Material Icons** - `Icons.star`, `Icons.favorite`
- **Custom Icon** - Dùng `IconData` hoặc package `font_awesome_flutter`

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Icon với các size khác nhau

```dart
Row(
  children: [
    Icon(Icons.star, size: 16),
    Icon(Icons.star, size: 24),
    Icon(Icons.star, size: 32),
    Icon(Icons.star, size: 48),
  ],
)
```

#### 2. Icon với màu gradient (cần package)

```dart
// Cần: flutter pub add flutter_svg hoặc dùng ShaderMask
ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [Colors.red, Colors.blue],
  ).createShader(bounds),
  child: Icon(Icons.favorite, color: Colors.white),
)
```

---

## 4.4. Button (nút bấm cơ bản)

```dart
ElevatedButton(
  onPressed: () => print("Clicked!"),
  child: const Text("Nhấn tôi"),
);
```

Các loại button khác:

- `TextButton`  
- `OutlinedButton`  
- `IconButton`  
- `FloatingActionButton`

---

### 🧠 Lý thuyết chi tiết về Button

**Các loại Button:**

1. **ElevatedButton** - Nút nổi, có shadow
2. **TextButton** - Nút text đơn giản
3. **OutlinedButton** - Nút có viền
4. **IconButton** - Nút chỉ có icon
5. **FloatingActionButton** - Nút tròn nổi

**Thuộc tính quan trọng:**

```dart
ElevatedButton(
  onPressed: () {},        // Callback khi nhấn
  onLongPress: () {},      // Callback khi giữ lâu
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.all(16),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text("Button"),
)
```

**Button States:**

- `onPressed: null` - Button bị disable (màu xám)
- `onPressed: () {}` - Button active

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Các loại button

```dart
Column(
  children: [
    ElevatedButton(
      onPressed: () {},
      child: const Text("Elevated Button"),
    ),
    TextButton(
      onPressed: () {},
      child: const Text("Text Button"),
    ),
    OutlinedButton(
      onPressed: () {},
      child: const Text("Outlined Button"),
    ),
    IconButton(
      icon: const Icon(Icons.favorite),
      onPressed: () {},
    ),
    FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    ),
  ],
)
```

#### 2. Button với loading state

```dart
ElevatedButton(
  onPressed: isLoading ? null : _handleSubmit,
  child: isLoading
    ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : const Text("Submit"),
)
```

#### 3. Button với icon

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.download),
  label: const Text("Download"),
)
```  

---

# 5. Các widget bố cục (layout) quan trọng nhất

## 5.1. Center – căn giữa

```dart
Center(
  child: Text("Hello"),
);
```

---

## 5.2. Container – widget "tất cả trong một"

Giúp:

- padding  
- margin  
- background  
- border  
- size  

```dart
Container(
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.symmetric(vertical: 20),
  color: Colors.amber,
  child: const Text("Box"),
);
```

---

### 🧠 Lý thuyết chi tiết về Container

**Container Widget:**

- Widget "đa năng" nhất trong Flutter
- Có thể set padding, margin, color, border, size
- Có thể transform, alignment, decoration

**Thuộc tính quan trọng:**

```dart
Container(
  // Kích thước
  width: 200,
  height: 200,
  
  // Padding (bên trong)
  padding: EdgeInsets.all(16),
  
  // Margin (bên ngoài)
  margin: EdgeInsets.symmetric(vertical: 20),
  
  // Màu nền (đơn giản)
  color: Colors.blue,
  
  // Decoration (phức tạp hơn)
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  
  // Căn chỉnh child
  alignment: Alignment.center,
  
  // Transform
  transform: Matrix4.rotationZ(0.1),
  
  child: Text("Content"),
)
```

**Lưu ý:**

- Không thể dùng cả `color` và `decoration.color` cùng lúc
- Nếu dùng `decoration`, phải set `color` trong `decoration`

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Container với decoration

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  ),
  child: const Text("Card Content"),
)
```

#### 2. Container với gradient

```dart
Container(
  height: 200,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.blue, Colors.purple],
    ),
  ),
  child: const Center(
    child: Text("Gradient Background", style: TextStyle(color: Colors.white)),
  ),
)
```

#### 3. Container với border

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blue, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Text("Bordered Container"),
)
```

---

## 5.3. Row – xếp theo chiều ngang

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.star),
    Text("Hạng VIP"),
  ],
);
```

---

### 🧠 Lý thuyết chi tiết về Row

**Row Widget:**

- Xếp children theo chiều **ngang** (horizontal)
- Main axis = ngang, Cross axis = dọc

**Thuộc tính quan trọng:**

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.start,    // Căn chỉnh main axis
  crossAxisAlignment: CrossAxisAlignment.center, // Căn chỉnh cross axis
  mainAxisSize: MainAxisSize.max,                // Chiếm hết không gian
  textDirection: TextDirection.ltr,              // Hướng text
  verticalDirection: VerticalDirection.down,      // Hướng dọc
  children: [...],
)
```

**MainAxisAlignment:**

- `start` - Bắt đầu từ trái
- `end` - Kết thúc ở phải
- `center` - Căn giữa
- `spaceBetween` - Khoảng cách đều giữa các item
- `spaceAround` - Khoảng cách đều xung quanh
- `spaceEvenly` - Khoảng cách đều hoàn toàn

**CrossAxisAlignment:**

- `start` - Căn trên
- `end` - Căn dưới
- `center` - Căn giữa
- `stretch` - Kéo dãn đầy chiều cao
- `baseline` - Căn theo baseline

---

### 🌟 Ví dụ thực tế

#### 1. Row với các alignment

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("Left"),
    Text("Right"),
  ],
)
```

#### 2. Row với Expanded

```dart
Row(
  children: [
    Expanded(
      child: Text("Text dài có thể wrap"),
    ),
    Icon(Icons.star),
  ],
)
```

---

## 5.4. Column – xếp theo chiều dọc

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    Text("Tên: Dũng"),
    Text("Nghề: Lập trình viên"),
  ],
);
```

---

### 🧠 Lý thuyết chi tiết về Column

**Column Widget:**

- Xếp children theo chiều **dọc** (vertical)
- Main axis = dọc, Cross axis = ngang

**Thuộc tính quan trọng:**

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.start,    // Căn chỉnh main axis
  crossAxisAlignment: CrossAxisAlignment.start,  // Căn chỉnh cross axis
  mainAxisSize: MainAxisSize.max,                // Chiếm hết không gian
  textDirection: TextDirection.ltr,               // Hướng text
  verticalDirection: VerticalDirection.down,      // Hướng dọc
  children: [...],
)
```

**MainAxisAlignment (cho Column):**

- `start` - Bắt đầu từ trên
- `end` - Kết thúc ở dưới
- `center` - Căn giữa
- `spaceBetween` - Khoảng cách đều giữa các item
- `spaceAround` - Khoảng cách đều xung quanh
- `spaceEvenly` - Khoảng cách đều hoàn toàn

**CrossAxisAlignment (cho Column):**

- `start` - Căn trái
- `end` - Căn phải
- `center` - Căn giữa
- `stretch` - Kéo dãn đầy chiều rộng
- `baseline` - Căn theo baseline

---

### 🌟 Ví dụ thực tế

#### 1. Column với các alignment

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text("Item 1"),
    Text("Item 2"),
    Text("Item 3"),
  ],
)
```

#### 2. Column với Expanded

```dart
Column(
  children: [
    Text("Header"),
    Expanded(
      child: ListView(...),
    ),
    Text("Footer"),
  ],
)
```

---

## 5.5. SizedBox – tạo khoảng cách

```dart
SizedBox(height: 20)
```

---

### 🎨 Ví dụ minh họa tổng hợp

```dart
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text("Xin chào!"),
      SizedBox(height: 16),
      Icon(Icons.flutter_dash, size: 48),
    ],
  ),
);
```

---

# 6. Tạo UI màn hình hoàn chỉnh đơn giản

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Xin chào Flutter!"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Nhấn tôi"),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

# 7. Lỗi thường gặp của sinh viên

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| "setState() called but nothing changed" | logic sai | đảm bảo biến thay đổi trong setState |
| Text bị tràn màn hình | quên dùng Expanded/Flexible | xem chương Layout nâng cao |
| UI không hiển thị | build() không trả widget | trả về widget, không return null |
| Overflow (chéo màu vàng) | Column/Row không giới hạn | thêm Expanded hoặc đặt height cố định |
| import sai thư mục | tách file lung tung | tổ chức lại project theo chuẩn |

---

## 🔴 Case Study: Các lỗi chi tiết và cách xử lý

### Case Study 1: setState() nhưng UI không đổi

#### ❌ Vấn đề:

```dart
class _MyWidgetState extends State<MyWidget> {
  int count = 0;
  
  void increment() {
    setState(() {
      // Quên thay đổi biến!
    });
  }
}
```

#### ✅ Giải pháp:

```dart
void increment() {
  setState(() {
    count++; // Phải thay đổi biến trong setState
  });
}
```

---

### Case Study 2: Text bị tràn trong Row

#### ❌ Vấn đề:

```dart
Row(
  children: [
    Text("Text rất rất rất dài..."),
    Icon(Icons.star),
  ],
)
// → Overflow error
```

#### ✅ Giải pháp:

```dart
Row(
  children: [
    Expanded(
      child: Text("Text rất rất rất dài..."),
    ),
    Icon(Icons.star),
  ],
)
```

---

### Case Study 3: Column overflow

#### ❌ Vấn đề:

```dart
Column(
  children: List.generate(100, (i) => Text("Item $i")),
)
// → Overflow error
```

#### ✅ Giải pháp:

```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) => Text("Item $index"),
)
```

---

### Case Study 4: Container với color và decoration

#### ❌ Vấn đề:

```dart
Container(
  color: Colors.blue,
  decoration: BoxDecoration(
    color: Colors.red, // Conflict!
  ),
)
```

#### ✅ Giải pháp:

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue, // Chỉ dùng decoration
  ),
)
```

---

### Case Study 5: build() return null

#### ❌ Vấn đề:

```dart
@override
Widget build(BuildContext context) {
  if (condition) {
    return Text("Hello");
  }
  // Không return gì → Lỗi!
}
```

#### ✅ Giải pháp:

```dart
@override
Widget build(BuildContext context) {
  if (condition) {
    return Text("Hello");
  }
  return SizedBox.shrink(); // Hoặc Container() rỗng
}
```

---

### Case Study 6: Quên const constructor

#### ❌ Vấn đề:

```dart
class MyWidget extends StatelessWidget {
  MyWidget({super.key}); // Thiếu const
  
  @override
  Widget build(BuildContext context) {
    return Text("Hello"); // Rebuild không cần thiết
  }
}
```

#### ✅ Giải pháp:

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // Thêm const
  
  @override
  Widget build(BuildContext context) {
    return const Text("Hello"); // Tối ưu performance
  }
}
```

---

# 8. Best Practices & Performance

## 8.1. Khi nào dùng StatelessWidget vs StatefulWidget

| Widget | Khi nào dùng | Ví dụ |
|--------|--------------|-------|
| StatelessWidget | UI không thay đổi | Text, Image, Card hiển thị |
| StatefulWidget | UI thay đổi theo state | Counter, Form, Toggle |

## 8.2. Performance Tips

### 1. Dùng const constructor

```dart
// ✅ ĐÚNG: const cho widget không đổi
const Text("Hello"),
const Icon(Icons.star),

// ❌ SAI: Không const → rebuild không cần thiết
Text("Hello"),
```

### 2. Tách widget nhỏ

```dart
// ✅ ĐÚNG: Tách thành widget riêng
class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}

// ❌ SAI: Tất cả trong 1 widget lớn
```

### 3. Tránh rebuild không cần thiết

```dart
// ✅ ĐÚNG: Chỉ rebuild phần cần thiết
class _MyWidgetState extends State<MyWidget> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StaticWidget(), // const → không rebuild
        Text("Count: $count"), // Chỉ rebuild phần này
      ],
    );
  }
}
```

## 8.3. Best Practices

### 1. Luôn dùng const khi có thể

```dart
const Text("Hello"),
const Icon(Icons.star),
const SizedBox(height: 20),
```

### 2. Đặt tên widget rõ ràng

```dart
// ✅ ĐÚNG
class ProductCard extends StatelessWidget {}

// ❌ SAI
class Widget1 extends StatelessWidget {}
```

### 3. Tách logic ra khỏi build()

```dart
// ✅ ĐÚNG
void _handleButtonPress() {
  // Logic
}

@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: _handleButtonPress,
    child: Text("Button"),
  );
}
```

### 4. Xử lý overflow đúng cách

```dart
// ✅ ĐÚNG: Dùng Expanded/Flexible
Row(
  children: [
    Expanded(child: Text("Long text...")),
    Icon(Icons.star),
  ],
)
```

---

# 9. Bài tập thực hành

1. **Tạo HomeScreen gồm: Text + Icon + ElevatedButton.**  
   → Xem ví dụ phần 6

2. **Tạo widget ProfileCard gồm avatar + tên + nút follow.**  
   → Xem ví dụ StatelessWidget phần 2

3. **Tạo StatefulWidget Counter có nút tăng/giảm.**  
   → Xem ví dụ StatefulWidget phần 3

4. **Dùng Row + Column tạo layout danh thiếp cá nhân.**  
   → Xem ví dụ Row/Column phần 5

5. **Tạo UI sản phẩm: ảnh + tên + giá + nút mua.**  
   → Xem ví dụ ProductCard phần 2

6. **Tạo widget CustomButton với:**
   - Text tùy chỉnh
   - Icon tùy chỉnh
   - Màu sắc tùy chỉnh
   - Callback onPressed

7. **Tạo màn hình Welcome với:**
   - Logo ở giữa
   - Text chào mừng
   - 2 nút: "Đăng nhập" và "Đăng ký"
   → Dùng Column + Center

8. **Tạo Card sản phẩm với:**
   - Ảnh sản phẩm (Image.network)
   - Tên sản phẩm (Text)
   - Giá (Text với style đặc biệt)
   - Nút "Thêm vào giỏ" (ElevatedButton)
   → Dùng Container + Column

9. **Tạo widget Rating với:**
   - 5 icon star
   - Có thể chọn số sao
   - Hiển thị số sao đã chọn
   → Dùng StatefulWidget + Row

10. **Tạo layout Profile page với:**
    - Avatar tròn ở trên
    - Tên, email, số điện thoại
    - Nút "Chỉnh sửa"
    → Dùng Column + Container

---

# 10. Mini Test cuối chương

**Câu 1:** Widget nào dùng khi UI thay đổi?  
→ StatefulWidget (có state, có thể cập nhật UI).

**Câu 2:** Muốn cập nhật UI thì dùng hàm gì?  
→ setState() - bắt buộc phải gọi trong State class.

**Câu 3:** Dùng widget nào để hiển thị ảnh từ file?  
→ Image.asset("assets/images/image.png").

**Câu 4:** Row xếp widget theo hướng nào?  
→ Ngang (horizontal), main axis = ngang, cross axis = dọc.

**Câu 5:** Container dùng để làm gì?  
→ Tạo box: padding, margin, background, border, size, decoration.

**Câu 6:** StatelessWidget vs StatefulWidget khác nhau như thế nào?  
→ StatelessWidget không có state, StatefulWidget có state và có thể thay đổi UI.

**Câu 7:** Tại sao nên dùng const constructor?  
→ Tối ưu performance, tránh rebuild không cần thiết.

**Câu 8:** BoxFit.cover và BoxFit.contain khác nhau như thế nào?  
→ cover: phủ kín có thể crop, contain: giữ tỷ lệ không crop.

**Câu 9:** MainAxisAlignment.spaceBetween làm gì?  
→ Tạo khoảng cách đều giữa các item, không có khoảng cách ở đầu và cuối.

**Câu 10:** Tại sao không thể dùng cả color và decoration.color trong Container?  
→ Gây conflict, chỉ nên dùng decoration.color.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Mọi thứ trong Flutter là widget** - Text, Button, Image, Layout đều là widget.  
- **StatelessWidget** = không thay đổi, **StatefulWidget** = thay đổi theo state.  
- **Column và Row** là nền tảng của mọi layout (dọc và ngang).  
- **Container** là widget "đa năng" (padding, margin, decoration, size).  
- **setState()** = cập nhật UI (bắt buộc trong StatefulWidget).  
- **Dùng SizedBox** để tạo khoảng cách.  
- **Luôn dùng const** cho widget không đổi để tối ưu performance.  
- **Text** có thể style: fontSize, color, fontWeight, decoration.  
- **Image** có nhiều nguồn: asset, network, file, memory.  
- **Button** có nhiều loại: ElevatedButton, TextButton, OutlinedButton, IconButton.

---

# 🎉 Kết thúc chương 04  
Tiếp theo chúng ta nâng cấp khả năng thiết kế UI:

👉 **Chương 05 – Layout Nâng Cao (Expanded, Flexible, Stack, ListView, GridView)**


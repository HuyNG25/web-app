# 🟦 CHƯƠNG 05  
# **LAYOUT NÂNG CAO TRONG FLUTTER**  
*(Expanded – Flexible – Stack – ListView – GridView – Responsive)*

Nếu chương 04 giúp bạn biết “xếp” UI, thì chương này giúp bạn xây **layout chuyên nghiệp**, không lỗi tràn, không bị “đổ bố cục”, và phù hợp cho nhiều kích thước màn hình.

Đây là chương bắt buộc phải nắm vững trước khi làm app thật.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn có thể:

- Hiểu khi nào dùng Expanded & Flexible.  
- Dùng Stack để chồng widget.  
- Sử dụng ListView để cuộn nội dung.  
- Tạo GridView để hiển thị dạng lưới.  
- Xử lý Overflow (cháy layout).  
- Làm UI phản hồi theo kích thước màn hình (responsive).

---

# 1. **Expanded – GIẢI PHÁP CHO MỌI KIỂU TRÀN MÀN HÌNH**

Trong Column/Row, nếu con chiếm quá nhiều không gian → lỗi OVERFLOW.

### 🧩 Cách sửa: bọc bằng Expanded

```dart
Expanded(
  child: Container(color: Colors.red),
)
```

Expanded chiếm **phần còn lại** của không gian.

---

### 🧠 Lý thuyết chi tiết về Expanded

**Expanded là gì?**

- Widget con của **Row** hoặc **Column**
- Chiếm **toàn bộ không gian còn lại** sau khi các widget khác đã chiếm chỗ
- Có thể dùng `flex` để phân chia tỷ lệ với các Expanded khác
- **BẮT BUỘC** phải chiếm hết không gian còn lại (không thể nhỏ hơn)

**Cơ chế hoạt động:**

```
Row/Column có không gian: 400px
├── Widget A: 100px (cố định)
├── Widget B: 50px (cố định)
└── Expanded: 250px (phần còn lại = 400 - 100 - 50)
```

**Thuộc tính quan trọng:**

```dart
Expanded(
  flex: 2, // Tỷ lệ phân chia (mặc định = 1)
  child: Container(...),
)
```

**Ví dụ với flex:**

```dart
Row(
  children: [
    Expanded(
      flex: 1, // Chiếm 1 phần
      child: Container(color: Colors.red, height: 100),
    ),
    Expanded(
      flex: 2, // Chiếm 2 phần (gấp đôi)
      child: Container(color: Colors.blue, height: 100),
    ),
    Expanded(
      flex: 1, // Chiếm 1 phần
      child: Container(color: Colors.green, height: 100),
    ),
  ],
)
// Tổng flex = 4, mỗi phần = 25%
// Red: 25%, Blue: 50%, Green: 25%
```

---

## Ví dụ

```dart
Column(
  children: [
    Container(height: 100, color: Colors.blue),
    Expanded(
      child: Container(color: Colors.green),
    ),
  ],
);
```

→ Khối xanh lá sẽ tự giãn chiếm toàn bộ phần trống còn lại.

---

### 🌟 Ví dụ thực tế: Layout 3 phần

```dart
Column(
  children: [
    // Header cố định
    Container(
      height: 60,
      color: Colors.blue,
      child: const Center(
        child: Text("Header", style: TextStyle(color: Colors.white)),
      ),
    ),
    // Content chiếm phần còn lại
    Expanded(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(title: Text("Item $index"));
        },
      ),
    ),
    // Footer cố định
    Container(
      height: 60,
      color: Colors.grey,
      child: const Center(
        child: Text("Footer", style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)
```

---

### 🎒 Ví dụ đời sống  
Expanded giống như **cái bong bóng** trong hộp → nó tự phồng ra chiếm hết khoảng trống.

---

# 2. **Flexible – Linh hoạt hơn Expanded**

Flexible cũng chiếm không gian, nhưng **không bắt buộc chiếm hết**.

### Ví dụ:

```dart
Flexible(
  flex: 2,
  child: Container(color: Colors.orange),
),
```

`flex` xác định độ ưu tiên phân chia không gian.

---

### 🧠 Lý thuyết chi tiết về Flexible

**Flexible là gì?**

- Widget con của **Row** hoặc **Column**
- Chiếm không gian **theo tỷ lệ flex**, nhưng **có thể nhỏ hơn** nếu nội dung nhỏ
- Linh hoạt hơn Expanded vì không bắt buộc chiếm hết
- Dùng khi widget con có thể tự điều chỉnh kích thước

**Cơ chế hoạt động:**

```
Row có không gian: 400px
├── Widget A: 100px (cố định)
├── Flexible(flex: 2): Có thể chiếm tối đa 200px, nhưng nếu nội dung chỉ cần 50px thì chỉ chiếm 50px
└── Expanded(flex: 1): Bắt buộc chiếm 100px (phần còn lại)
```

**Thuộc tính quan trọng:**

```dart
Flexible(
  flex: 2, // Tỷ lệ phân chia
  fit: FlexFit.loose, // Mặc định: có thể nhỏ hơn
  // fit: FlexFit.tight, // Giống Expanded: bắt buộc chiếm hết
  child: Container(...),
)
```

**Flexible vs Expanded:**

- **Flexible(fit: FlexFit.tight)** = **Expanded** (giống hệt nhau)
- **Flexible(fit: FlexFit.loose)** = Linh hoạt, có thể nhỏ hơn

---

### Expanded vs Flexible

| Widget | Chiếm toàn bộ không gian còn lại? | Dùng khi | Ví dụ |
|--------|---------------------------------|----------|-------|
| Expanded | ✔ Có (bắt buộc) | khi muốn chiếm hết | ListView trong Column |
| Flexible | ✘ Không (tùy chọn) | khi cần linh hoạt theo nội dung | Text có thể wrap |

---

### 🌟 Ví dụ thực tế: Flexible vs Expanded

```dart
Row(
  children: [
    // Flexible: Text có thể wrap, không chiếm hết
    Flexible(
      child: Text(
        "Text ngắn",
        style: TextStyle(fontSize: 16),
      ),
    ),
    // Expanded: ListView bắt buộc chiếm hết
    Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(title: Text("Item $index"));
        },
      ),
    ),
  ],
)
```

**Kết quả:**
- Flexible: Text chỉ chiếm đúng kích thước cần thiết
- Expanded: ListView chiếm toàn bộ phần còn lại

---

# 3. **Stack – Xếp chồng widget lên nhau**

### Khi nào dùng Stack?

- Banner có chữ phía trên  
- Avatar có nút edit góc dưới  
- Màn hình có nhiều lớp UI  
- Badge trên icon
- Overlay, modal
- Floating action button

---

### 🧠 Lý thuyết chi tiết về Stack

**Stack là gì?**

- Widget xếp các con **chồng lên nhau** theo thứ tự
- Widget sau nằm **trên** widget trước
- Có thể dùng **Positioned** để đặt vị trí chính xác
- Có thể dùng **Align** để căn chỉnh

**Cơ chế hoạt động:**

```
Stack
├── Layer 1 (dưới cùng)
├── Layer 2
└── Layer 3 (trên cùng)
```

**Thuộc tính quan trọng:**

```dart
Stack(
  alignment: Alignment.center, // Căn chỉnh mặc định
  fit: StackFit.expand, // Con chiếm toàn bộ Stack
  clipBehavior: Clip.hardEdge, // Cắt phần tràn ra ngoài
  children: [
    // Widget con
  ],
)
```

**Positioned - Đặt vị trí chính xác:**

```dart
Positioned(
  top: 10,
  right: 10,
  bottom: 10,
  left: 10,
  // Hoặc dùng width, height
  width: 100,
  height: 100,
  child: Container(...),
)
```

---

### Ví dụ:

```dart
Stack(
  children: [
    Image.asset("assets/images/banner.png"),
    Positioned(
      bottom: 20,
      left: 20,
      child: Text("Welcome!", style: TextStyle(fontSize: 24, color: Colors.white)),
    )
  ],
);
```

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Avatar với badge

```dart
Stack(
  children: [
    CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      ),
    ),
  ],
)
```

#### 2. Banner với gradient overlay

```dart
Stack(
  children: [
    Image.network(
      "https://example.com/banner.jpg",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    ),
    // Gradient overlay
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    ),
    // Text trên gradient
    Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: const Text(
        "Tiêu đề banner",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
)
```

#### 3. Card với floating button

```dart
Stack(
  children: [
    Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sản phẩm", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text("Mô tả sản phẩm..."),
          ],
        ),
      ),
    ),
    Positioned(
      top: 10,
      right: 10,
      child: FloatingActionButton(
        mini: true,
        onPressed: () {},
        child: const Icon(Icons.favorite),
      ),
    ),
  ],
)
```

#### 4. Image với loading indicator

```dart
Stack(
  children: [
    Image.network("https://example.com/image.jpg"),
    // Loading overlay
    if (_isLoading)
      Container(
        color: Colors.black.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
)
```

---

### 🎒 Ví dụ đời sống  
Stack giống như **xếp bánh kem nhiều lớp** → lớp nào cũng nằm trên lớp khác.

---

# 4. **ListView – Cuộn danh sách**

Trong ứng dụng thật, nội dung dài gần như luôn cần cuộn.

### Dùng ListView đơn giản:

```dart
ListView(
  children: const [
    Text("Item 1"),
    Text("Item 2"),
    Text("Item 3"),
  ],
);
```

### ListView.builder (dùng nhiều nhất)

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Text(items[index]);
  },
);
```

=> Tối ưu cho danh sách dài.

---

### 🧠 Lý thuyết chi tiết về ListView

**ListView là gì?**

- Widget hiển thị danh sách **có thể cuộn** (scrollable)
- **Lazy loading**: Chỉ render các item hiển thị trên màn hình
- Tối ưu performance cho danh sách dài
- Có nhiều biến thể: ListView, ListView.builder, ListView.separated

**Các loại ListView:**

1. **ListView** - Render tất cả children ngay lập tức
   - Dùng cho danh sách **ngắn** (< 50 items)
   - Không tối ưu cho danh sách dài

2. **ListView.builder** - Render theo nhu cầu (lazy)
   - Dùng cho danh sách **dài** (> 50 items)
   - Chỉ render items hiển thị trên màn hình
   - **Tối ưu performance**

3. **ListView.separated** - Có separator giữa các item
   - Giống ListView.builder nhưng có divider
   - Dùng khi cần divider giữa các item

**Thuộc tính quan trọng:**

```dart
ListView.builder(
  itemCount: items.length, // Số lượng items
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
  padding: EdgeInsets.all(16), // Padding xung quanh
  scrollDirection: Axis.vertical, // Hướng cuộn
  reverse: false, // Đảo ngược thứ tự
  shrinkWrap: false, // Không chiếm toàn bộ không gian
  physics: AlwaysScrollableScrollPhysics(), // Luôn cho phép scroll
)
```

**Performance tips:**

- Luôn dùng **ListView.builder** cho danh sách dài
- Không dùng ListView lồng ListView
- Dùng `cacheExtent` để tối ưu memory
- Dùng `addAutomaticKeepAlives: false` nếu không cần giữ state

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. ListView.builder cơ bản

```dart
class ProductListScreen extends StatelessWidget {
  final List<String> products = [
    "Laptop Dell",
    "iPhone 15",
    "AirPods Pro",
    "MacBook Pro",
    "iPad Air",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách sản phẩm")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(products[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý khi tap
            },
          );
        },
      ),
    );
  }
}
```

#### 2. ListView.separated với divider

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) {
    return const Divider(height: 1);
  },
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

#### 3. ListView với header và footer

```dart
ListView(
  children: [
    // Header
    Container(
      height: 200,
      color: Colors.blue,
      child: const Center(
        child: Text("Header", style: TextStyle(color: Colors.white)),
      ),
    ),
    // List items
    ...items.map((item) => ListTile(title: Text(item))),
    // Footer
    Container(
      height: 100,
      color: Colors.grey,
      child: const Center(
        child: Text("Footer"),
      ),
    ),
  ],
)
```

#### 4. Horizontal ListView

```dart
ListView(
  scrollDirection: Axis.horizontal,
  children: [
    Container(width: 200, color: Colors.red),
    Container(width: 200, color: Colors.blue),
    Container(width: 200, color: Colors.green),
  ],
)
```

#### 5. ListView với pull-to-refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    // Load lại dữ liệu
    await Future.delayed(Duration(seconds: 2));
  },
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return ListTile(title: Text(items[index]));
    },
  ),
)
```

---

# 5. **GridView – Hiển thị dạng lưới**

Dùng cho UI kiểu:

- danh sách sản phẩm  
- bộ sưu tập ảnh  
- chọn icon  
- Gallery ảnh
- Dashboard với cards

---

### 🧠 Lý thuyết chi tiết về GridView

**GridView là gì?**

- Widget hiển thị items dạng **lưới** (grid)
- Có thể cuộn (scrollable)
- Tối ưu cho danh sách nhiều items cần hiển thị dạng lưới
- Có nhiều biến thể: GridView.count, GridView.builder, GridView.extent

**Các loại GridView:**

1. **GridView.count** - Số cột cố định
   - Dùng khi biết số cột cần hiển thị
   - Đơn giản, dễ dùng

2. **GridView.builder** - Render theo nhu cầu (lazy)
   - Tối ưu cho danh sách dài
   - Linh hoạt hơn GridView.count

3. **GridView.extent** - Kích thước item cố định
   - Dùng khi muốn item có kích thước cố định

**Thuộc tính quan trọng:**

```dart
GridView.count(
  crossAxisCount: 2, // Số cột
  crossAxisSpacing: 10, // Khoảng cách giữa các cột
  mainAxisSpacing: 10, // Khoảng cách giữa các hàng
  padding: EdgeInsets.all(16), // Padding xung quanh
  childAspectRatio: 0.8, // Tỷ lệ width/height của item
  children: [...],
)
```

**childAspectRatio:**

- `1.0` = item vuông (width = height)
- `0.8` = item cao hơn rộng (height = width / 0.8)
- `1.2` = item rộng hơn cao (width = height * 1.2)

---

### Ví dụ:

```dart
GridView.count(
  crossAxisCount: 2,
  children: List.generate(4, (i) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.blue,
      child: Center(child: Text("Item $i")),
    );
  }),
);
```

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. GridView.count cơ bản

```dart
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: const EdgeInsets.all(16),
  children: List.generate(10, (index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text("Item $index"),
      ),
    );
  }),
)
```

#### 2. GridView.builder (tối ưu)

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.8,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

#### 3. GridView với responsive (số cột thay đổi theo màn hình)

```dart
LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = 2;
    if (constraints.maxWidth > 600) {
      crossAxisCount = 3;
    }
    if (constraints.maxWidth > 900) {
      crossAxisCount = 4;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: items[index]);
      },
    );
  },
)
```

#### 4. GridView với Staggered (lưới không đều)

```dart
// Cần package: flutter_staggered_grid_view
StaggeredGridView.countBuilder(
  crossAxisCount: 4,
  itemBuilder: (context, index) {
    return Container(
      color: Colors.blue,
      child: Center(child: Text("Item $index")),
    );
  },
  staggeredTileBuilder: (index) {
    return StaggeredTile.count(2, index.isEven ? 2 : 3);
  },
  itemCount: 10,
)
```

#### 5. Product Grid với Card

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 0.7,
  ),
  padding: const EdgeInsets.all(16),
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${product.price.toStringAsFixed(0)} đ"),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

---

# 6. **SingleChildScrollView – Cuộn 1 màn hình dài**

Dùng cho màn hình form, giới thiệu, profile dài.

```dart
SingleChildScrollView(
  child: Column(
    children: [...],
  ),
);
```

---

### 🧠 Lý thuyết chi tiết về SingleChildScrollView

**SingleChildScrollView là gì?**

- Widget cho phép **cuộn** một child duy nhất
- Dùng khi nội dung **dài hơn màn hình** nhưng **không phải danh sách**
- Không lazy loading (render tất cả ngay)
- Dùng cho form, profile, giới thiệu

**Khi nào dùng:**

- ✅ Form dài (đăng ký, đăng nhập)
- ✅ Profile page với nhiều thông tin
- ✅ Màn hình giới thiệu
- ✅ Settings page

**Khi KHÔNG nên dùng:**

- ❌ Danh sách items (dùng ListView)
- ❌ Nội dung ngắn (không cần scroll)
- ❌ Lồng với ListView (gây conflict)

**Thuộc tính quan trọng:**

```dart
SingleChildScrollView(
  scrollDirection: Axis.vertical, // Hướng cuộn
  reverse: false, // Đảo ngược
  padding: EdgeInsets.all(16), // Padding
  physics: AlwaysScrollableScrollPhysics(), // Luôn cho phép scroll
  child: Column(...),
)
```

---

### ⚠ Cẩn thận:
- Không dùng `ListView` lồng `SingleChildScrollView`.  
- Không dùng `SingleChildScrollView` bên trong ListView.
- Không dùng cho danh sách dài (dùng ListView.builder)

---

### 🌟 Ví dụ thực tế

#### 1. Form đăng ký dài

```dart
SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(decoration: InputDecoration(labelText: "Họ tên")),
      const SizedBox(height: 16),
      TextField(decoration: InputDecoration(labelText: "Email")),
      const SizedBox(height: 16),
      TextField(decoration: InputDecoration(labelText: "Số điện thoại")),
      const SizedBox(height: 16),
      TextField(decoration: InputDecoration(labelText: "Địa chỉ")),
      const SizedBox(height: 16),
      TextField(decoration: InputDecoration(labelText: "Mật khẩu")),
      const SizedBox(height: 16),
      TextField(decoration: InputDecoration(labelText: "Xác nhận mật khẩu")),
      const SizedBox(height: 30),
      ElevatedButton(
        onPressed: () {},
        child: const Text("Đăng ký"),
      ),
    ],
  ),
)
```

#### 2. Profile page

```dart
SingleChildScrollView(
  child: Column(
    children: [
      // Avatar
      CircleAvatar(radius: 50),
      const SizedBox(height: 16),
      // Thông tin
      Text("Tên người dùng", style: TextStyle(fontSize: 24)),
      const SizedBox(height: 8),
      Text("email@example.com"),
      const SizedBox(height: 32),
      // Các section
      _buildSection("Giới thiệu", "Mô tả về bản thân..."),
      _buildSection("Kỹ năng", "Flutter, Dart, UI/UX"),
      _buildSection("Kinh nghiệm", "5 năm phát triển mobile app"),
    ],
  ),
)
```  

---

# 7. **Responsive Layout – UI phù hợp mọi màn hình**

Dùng `MediaQuery`:

```dart
double width = MediaQuery.of(context).size.width;

if (width < 400) {
  return Text("Màn nhỏ");
} else {
  return Text("Màn lớn");
}
```

Hoặc:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 500) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
);
```

---

### 🧠 Lý thuyết chi tiết về Responsive Design

**Responsive Design là gì?**

- UI **tự động thích ứng** với kích thước màn hình
- Hiển thị khác nhau trên mobile, tablet, desktop
- Cải thiện trải nghiệm người dùng

**Các breakpoint phổ biến:**

```
Mobile: < 600px
Tablet: 600px - 900px
Desktop: > 900px
```

**MediaQuery vs LayoutBuilder:**

| Widget | Khi nào dùng | Ưu điểm |
|--------|--------------|---------|
| MediaQuery | Cần thông tin màn hình (width, height, padding) | Đơn giản, truy cập nhiều thông tin |
| LayoutBuilder | Cần constraints của widget cha | Linh hoạt, không phụ thuộc context |

**Các thông tin từ MediaQuery:**

```dart
final mediaQuery = MediaQuery.of(context);
final width = mediaQuery.size.width;
final height = mediaQuery.size.height;
final padding = mediaQuery.padding; // Safe area
final orientation = mediaQuery.orientation; // Portrait/Landscape
final devicePixelRatio = mediaQuery.devicePixelRatio;
```

---

### 🌟 Ví dụ thực tế đa dạng

#### 1. Responsive GridView

```dart
LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = 2;
    if (constraints.maxWidth > 600) {
      crossAxisCount = 3;
    }
    if (constraints.maxWidth > 900) {
      crossAxisCount = 4;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(item: items[index]),
    );
  },
)
```

#### 2. Responsive Row/Column

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      // Mobile: Column
      return Column(
        children: [
          WidgetA(),
          WidgetB(),
        ],
      );
    } else {
      // Tablet/Desktop: Row
      return Row(
        children: [
          Expanded(child: WidgetA()),
          Expanded(child: WidgetB()),
        ],
      );
    }
  },
)
```

#### 3. Responsive với MediaQuery

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return MobileLayout();
    } else if (width < 900) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  }
}
```

#### 4. Responsive Text size

```dart
LayoutBuilder(
  builder: (context, constraints) {
    double fontSize = 16;
    if (constraints.maxWidth > 600) {
      fontSize = 18;
    }
    if (constraints.maxWidth > 900) {
      fontSize = 20;
    }

    return Text(
      "Responsive Text",
      style: TextStyle(fontSize: fontSize),
    );
  },
)
```

#### 5. Responsive AppBar với actions

```dart
AppBar(
  title: const Text("Responsive App"),
  actions: MediaQuery.of(context).size.width > 600
    ? [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ]
    : [
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
)
```

#### 6. Orientation-aware layout

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isPortrait = constraints.maxHeight > constraints.maxWidth;
    
    if (isPortrait) {
      return Column(
        children: [
          Image.network("..."),
          Text("Content"),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: Image.network("...")),
          Expanded(child: Text("Content")),
        ],
      );
    }
  },
)
```

---

# 8. **Sai vs Đúng (dành cho sinh viên hay lỗi)**

## ❌ Sai: Row không đủ chỗ
```dart
// ❌ SAI: Text dài gây overflow
Row(
  children: [
    Text("Tên sản phẩm rất rất rất dài..."),
    Text("Giá: 1000000đ"),
  ],
);
```
→ Lỗi OVERFLOW

## ✔ Đúng: Dùng Expanded hoặc Flexible
```dart
// ✅ ĐÚNG: Text có thể wrap
Row(
  children: [
    Expanded(
      child: Text("Tên sản phẩm rất rất rất dài..."),
    ),
    Text("Giá: 1000000đ"),
  ],
)

// Hoặc dùng Flexible nếu không muốn chiếm hết
Row(
  children: [
    Flexible(
      child: Text("Tên sản phẩm rất rất rất dài..."),
    ),
    Text("Giá: 1000000đ"),
  ],
)
```

---

## ❌ Sai: List dài nhưng không cuộn
```dart
// ❌ SAI: Column với nhiều items → overflow
Column(
  children: List.generate(100, (i) => Text("Item $i")),
);
```

## ✔ Đúng: Dùng ListView.builder
```dart
// ✅ ĐÚNG: ListView có thể cuộn
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return Text("Item $index");
  },
)
```

---

## ❌ Sai: ListView lồng SingleChildScrollView

```dart
// ❌ SAI: Conflict scroll
SingleChildScrollView(
  child: Column(
    children: [
      Text("Header"),
      ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => Text("Item $index"),
      ),
    ],
  ),
)
```

## ✔ Đúng: Dùng Column với Expanded

```dart
// ✅ ĐÚNG: ListView trong Expanded
Column(
  children: [
    Text("Header"),
    Expanded(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => Text("Item $index"),
      ),
    ),
  ],
)
```

---

## ❌ Sai: GridView không có itemCount

```dart
// ❌ SAI: GridView.count với List.generate không tối ưu
GridView.count(
  crossAxisCount: 2,
  children: List.generate(1000, (i) => Container(...)),
)
```

## ✔ Đúng: Dùng GridView.builder

```dart
// ✅ ĐÚNG: Lazy loading, tối ưu performance
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: 1000,
  itemBuilder: (context, index) {
    return Container(...);
  },
)
```

---

## ❌ Sai: Stack không có kích thước

```dart
// ❌ SAI: Stack không biết kích thước
Stack(
  children: [
    Image.network("..."),
    Positioned(child: Text("Overlay")),
  ],
)
```

## ✔ Đúng: Đặt kích thước cho Stack

```dart
// ✅ ĐÚNG: Stack có kích thước rõ ràng
SizedBox(
  height: 200,
  child: Stack(
    children: [
      Image.network("...", fit: BoxFit.cover),
      Positioned(
        bottom: 10,
        left: 10,
        child: Text("Overlay"),
      ),
    ],
  ),
)

// Hoặc dùng Expanded nếu trong Column/Row
Expanded(
  child: Stack(...),
)
```

---

## ❌ Sai: Expanded trong Column/Row không có không gian

```dart
// ❌ SAI: Column không có kích thước cố định
Column(
  children: [
    Expanded(child: Container(...)), // Lỗi!
  ],
)
```

## ✔ Đúng: Column phải có kích thước hoặc trong Expanded

```dart
// ✅ ĐÚNG: Column trong SizedBox hoặc Expanded
SizedBox(
  height: 400,
  child: Column(
    children: [
      Expanded(child: Container(...)),
    ],
  ),
)

// Hoặc
Expanded(
  child: Column(
    children: [
      Expanded(child: Container(...)),
    ],
  ),
)
```

---

## ❌ Sai: Không xử lý overflow trong Text

```dart
// ❌ SAI: Text dài gây overflow
Row(
  children: [
    Text("Text rất rất rất dài..."),
    Icon(Icons.star),
  ],
)
```

## ✔ Đúng: Dùng Flexible hoặc maxLines

```dart
// ✅ ĐÚNG: Text có thể wrap hoặc ellipsis
Row(
  children: [
    Flexible(
      child: Text(
        "Text rất rất rất dài...",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
    Icon(Icons.star),
  ],
)
```

---

## ❌ Sai: GridView với childAspectRatio không phù hợp

```dart
// ❌ SAI: childAspectRatio = 2.0 → item quá rộng
GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 2.0,
  children: [...],
)
```

## ✔ Đúng: Điều chỉnh childAspectRatio

```dart
// ✅ ĐÚNG: childAspectRatio phù hợp (0.8 - 1.2)
GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 0.8, // Item cao hơn rộng
  children: [...],
)
```

---

# 9. **Best Practices & Performance**

## 9.1. **Khi nào dùng widget nào?**

| Widget | Khi nào dùng | Ví dụ |
|--------|--------------|-------|
| Expanded | Cần chiếm hết không gian còn lại | ListView trong Column |
| Flexible | Cần linh hoạt, không bắt buộc chiếm hết | Text có thể wrap |
| Stack | Cần xếp chồng widget | Banner với overlay |
| ListView.builder | Danh sách dài (> 50 items) | Product list |
| GridView.builder | Lưới nhiều items | Gallery, product grid |
| SingleChildScrollView | Form, profile dài | Registration form |

## 9.2. **Performance Tips**

### 1. Luôn dùng builder cho danh sách dài

```dart
// ❌ SAI: Render tất cả ngay
ListView(children: List.generate(1000, ...))

// ✅ ĐÚNG: Lazy loading
ListView.builder(itemCount: 1000, ...)
```

### 2. Tránh rebuild không cần thiết

```dart
// ✅ ĐÚNG: Dùng const cho widget không đổi
const Text("Static text"),
const Icon(Icons.star),
```

### 3. Tối ưu GridView với childAspectRatio

```dart
// ✅ ĐÚNG: Tính toán childAspectRatio phù hợp
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.8, // Phù hợp với content
  ),
  ...
)
```

### 4. Dùng cacheExtent cho ListView dài

```dart
ListView.builder(
  cacheExtent: 500, // Cache 500px trước và sau viewport
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)
```

## 9.3. **Best Practices**

### 1. Luôn xử lý overflow

```dart
// ✅ ĐÚNG: Dùng Expanded/Flexible trong Row/Column
Row(
  children: [
    Expanded(child: Text("Long text...")),
    Icon(Icons.star),
  ],
)
```

### 2. Đặt kích thước rõ ràng cho Stack

```dart
// ✅ ĐÚNG: Stack có kích thước
SizedBox(
  height: 200,
  child: Stack(...),
)
```

### 3. Dùng LayoutBuilder cho responsive

```dart
// ✅ ĐÚNG: Responsive theo constraints
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    }
    return TabletLayout();
  },
)
```

### 4. Tránh nested scrollable widgets

```dart
// ❌ SAI: ListView trong SingleChildScrollView
SingleChildScrollView(
  child: ListView(...),
)

// ✅ ĐÚNG: Dùng Column với Expanded
Column(
  children: [
    Text("Header"),
    Expanded(child: ListView(...)),
  ],
)
```

---

# 10. **Bài tập thực hành**

1. **Tạo màn hình profile có avatar, tên, bio và nút Follow → dùng Column + Row + Padding.**  
   → Xem ví dụ Stack phần 3

2. **Tạo layout banner dùng Stack (ảnh nền + text).**  
   → Xem ví dụ Stack phần 3

3. **Tạo danh sách 50 sản phẩm dùng ListView.builder.**  
   → Xem ví dụ ListView phần 4

4. **Tạo lưới ảnh 3 cột bằng GridView.count.**  
   → Xem ví dụ GridView phần 5

5. **Làm UI trang giới thiệu công ty bằng SingleChildScrollView.**  
   → Xem ví dụ SingleChildScrollView phần 6

6. **Tạo hai giao diện Mobile/Tablet bằng LayoutBuilder.**  
   → Xem ví dụ Responsive phần 7

7. **Tạo màn hình shopping với:**
   - Header cố định (AppBar)
   - Product grid (GridView) chiếm phần còn lại
   - Footer cố định (Bottom bar)
   → Dùng Column + Expanded

8. **Tạo card sản phẩm với:**
   - Ảnh sản phẩm
   - Badge "New" góc trên phải (dùng Stack)
   - Tên, giá, nút "Thêm vào giỏ"
   → Dùng Stack + Positioned

9. **Tạo responsive layout:**
   - Mobile (< 600px): 1 cột
   - Tablet (600-900px): 2 cột
   - Desktop (> 900px): 3 cột
   → Dùng LayoutBuilder + GridView

10. **Tạo màn hình chat:**
    - Header cố định
    - ListView messages (có thể cuộn)
    - Input field cố định ở dưới
    → Dùng Column + Expanded + ListView

---

# 11. Mini Test cuối chương

**Câu 1:** Widget nào dùng để chiếm không gian còn lại?  
→ Expanded (bắt buộc chiếm hết) hoặc Flexible (linh hoạt).

**Câu 2:** Khi nào dùng Stack?  
→ Khi muốn xếp widget chồng lên nhau (banner, avatar với badge, overlay).

**Câu 3:** Dùng widget nào để hiển thị danh sách dài?  
→ ListView.builder (lazy loading, tối ưu performance).

**Câu 4:** crossAxisCount trong GridView là gì?  
→ Số cột trong lưới.

**Câu 5:** LayoutBuilder dùng để làm gì?  
→ Tạo responsive UI dựa trên constraints của widget cha.

**Câu 6:** Expanded vs Flexible khác nhau như thế nào?  
→ Expanded bắt buộc chiếm hết không gian, Flexible có thể nhỏ hơn nếu nội dung nhỏ.

**Câu 7:** Tại sao nên dùng ListView.builder thay vì ListView cho danh sách dài?  
→ ListView.builder lazy loading, chỉ render items hiển thị, tối ưu performance.

**Câu 8:** childAspectRatio trong GridView là gì?  
→ Tỷ lệ width/height của item (1.0 = vuông, < 1.0 = cao hơn rộng, > 1.0 = rộng hơn cao).

**Câu 9:** Tại sao không nên lồng ListView trong SingleChildScrollView?  
→ Gây conflict scroll, không biết widget nào xử lý scroll.

**Câu 10:** MediaQuery vs LayoutBuilder khác nhau như thế nào?  
→ MediaQuery lấy thông tin màn hình, LayoutBuilder lấy constraints của widget cha.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Expanded** = chiếm hết chỗ trống (bắt buộc).  
- **Flexible** = chiếm chỗ nhưng không bắt buộc đầy (linh hoạt).  
- **Stack** = chồng UI, dùng Positioned để đặt vị trí.  
- **ListView.builder** = cuộn danh sách dài (lazy loading, tối ưu).  
- **GridView.builder** = hiển thị dạng lưới (lazy loading).  
- **SingleChildScrollView** = cuộn 1 màn hình dài (form, profile).  
- **MediaQuery** = lấy thông tin màn hình (width, height, orientation).  
- **LayoutBuilder** = responsive UI dựa trên constraints.  
- **Luôn xử lý overflow** trong Row/Column bằng Expanded/Flexible.  
- **Tránh nested scrollable** widgets (ListView trong SingleChildScrollView).  

---

# 🎉 Kết thúc chương 05  
Tiếp theo, bạn sẽ học cách điều hướng giữa các màn hình:

👉 **Chương 06 – Navigation (Điều hướng trong Flutter)**


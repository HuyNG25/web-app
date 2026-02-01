# 🟦 CHƯƠNG 02  
# **DART CHO FLUTTER DEVELOPER**  
*(Phiên bản thực chiến – chỉ học những gì Flutter cần)*

Bạn đã học Dart căn bản trong phần trước.  
Nhưng! Khi bước vào Flutter, bạn **không cần tất cả**, mà chỉ cần những phần “ăn liền” giúp build UI nhanh, xử lý state, làm việc với async, và quản lý dữ liệu.

Chương này chọn lọc **Dart tối thiểu nhưng đủ dùng** để bạn làm app Flutter chuyên nghiệp.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Biết những phần Dart nào quan trọng nhất cho Flutter.  
- Hiểu bản chất `StatelessWidget` và `StatefulWidget` nhờ OOP.  
- Sử dụng List/Map với UI.  
- Biết dùng async–await để gọi API và load dữ liệu.  
- Tự tin đọc code Flutter của người khác.  

---

# 1. **Dart – Nền tảng 100% của Flutter**

Bạn viết Flutter = bạn đang viết Dart.  
Bạn hiểu Dart tốt → Flutter vào đầu như uống nước.

Dart trong Flutter chủ yếu dùng cho:

- UI (Widgets)  
- State  
- Xử lý logic  
- Xử lý async (API, Future, Stream)  
- Quản lý data (List, Map, Model class)  

---

# 2. **Biến & Kiểu dữ liệu (rất hay gặp khi viết UI)**

## 📌 var và final  
Flutter dùng `final` rất nhiều.

```dart
final String title = "Hello";
var count = 0;
```

---

### 🧠 Lý thuyết chi tiết về var, final, const

**var, final, const - Khi nào dùng?**

| Từ khóa | Có thể thay đổi? | Khi nào dùng | Ví dụ |
|---------|------------------|--------------|-------|
| `var` | ✅ Có | Kiểu tự suy luận, có thể thay đổi | `var count = 0;` |
| `final` | ❌ Không | Giá trị không đổi sau khi gán | `final name = "Flutter";` |
| `const` | ❌ Không | Hằng số compile-time | `const pi = 3.14;` |

**final dùng khi:**
- dữ liệu **không thay đổi**, nhưng lấy được lúc runtime  
(VD: màu, padding, text từ API)

**const dùng khi:**
- hằng số compile-time  
(VD: const Text("Hi") trong widget tree)

**Lưu ý quan trọng:**

```dart
// ✅ ĐÚNG: final cho giá trị runtime
final String userName = getUserName(); // Lấy từ API

// ✅ ĐÚNG: const cho giá trị compile-time
const String appName = "MyApp";

// ❌ SAI: const không thể dùng với runtime
const String userName = getUserName(); // Lỗi!
```

**Best Practice trong Flutter:**

- Luôn dùng `final` thay vì `var` khi giá trị không đổi
- Dùng `const` cho widget không thay đổi (tối ưu performance)
- Tránh dùng `var` khi có thể suy luận kiểu rõ ràng

---

## 📌 List – Map – Cặp dữ liệu quan trọng nhất của Flutter

### List

```dart
List<String> names = ["Huy", "Mai", "An"];
```

Dùng để hiển thị ListView.

---

### 🧠 Lý thuyết chi tiết về List

**List trong Flutter:**

- Dùng để lưu danh sách items
- Kết hợp với ListView.builder để hiển thị UI
- Có nhiều methods hữu ích: map, where, forEach, etc.

**Các thao tác phổ biến:**

```dart
List<String> names = ["Huy", "Mai", "An"];

// Thêm phần tử
names.add("Lan");
names.addAll(["Nam", "Hoa"]);

// Xóa phần tử
names.remove("Huy");
names.removeAt(0);

// Tìm kiếm
bool hasMai = names.contains("Mai");
int index = names.indexOf("Mai");

// Transform
List<String> upperNames = names.map((name) => name.toUpperCase()).toList();

// Filter
List<String> longNames = names.where((name) => name.length > 3).toList();

// Sắp xếp
names.sort(); // Sắp xếp theo thứ tự alphabet
```

**List với ListView:**

```dart
List<Product> products = [...];

ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

---

### Map

```dart
Map<String, dynamic> user = {
  "name": "Dung",
  "age": 21
};
```

Dùng để xử lý JSON khi gọi API.

---

### 🧠 Lý thuyết chi tiết về Map

**Map trong Flutter:**

- Dùng để lưu key-value pairs
- Thường dùng với JSON từ API
- `Map<String, dynamic>` = flexible, có thể chứa bất kỳ kiểu nào

**Các thao tác phổ biến:**

```dart
Map<String, dynamic> user = {
  "name": "Dung",
  "age": 21,
  "email": "dung@example.com"
};

// Truy cập
String name = user["name"];
int age = user["age"];

// Thêm/Sửa
user["phone"] = "0123456789";
user["age"] = 22;

// Xóa
user.remove("email");

// Kiểm tra
bool hasName = user.containsKey("name");
bool hasValue = user.containsValue("Dung");

// Lặp qua
user.forEach((key, value) {
  print("$key: $value");
});

// Chuyển thành List
List<String> keys = user.keys.toList();
List<dynamic> values = user.values.toList();
```

**Map với JSON:**

```dart
// JSON string → Map
String jsonStr = '{"name":"Dung","age":21}';
Map<String, dynamic> data = jsonDecode(jsonStr);

// Map → JSON string
String jsonString = jsonEncode(data);
```

---

# 3. **Hàm (function) – đơn giản nhưng dùng suốt**

### Hàm bình thường

```dart
int sum(int a, int b) {
  return a + b;
}
```

### Hàm ngắn gọn (fat arrow)

```dart
int sum2(int a, int b) => a + b;
```

### Callback – cực quan trọng với Buttons

```dart
onPressed: () {
  print("Clicked!");
}
```

---

# 4. **OOP trong Flutter (hiểu đúng để không bị rối)**

UI trong Flutter là **class**.  
Mỗi màn hình là 1 class.  
Mỗi widget cũng là 1 class.

## 📌 StatelessWidget
Dùng khi UI **không thay đổi**.

```dart
class MyBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Box");
  }
}
```

## 📌 StatefulWidget
Dùng khi UI **thay đổi theo trạng thái**.

```dart
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  void increase() {
    setState(() => count++);
  }

  @override
  Widget build(BuildContext context) {
    return Text("$count");
  }
}
```

### 🎒 Ví dụ đời sống  
- Stateless = cái bảng hiệu treo tường, viết rồi giữ nguyên.  
- Stateful = cái nồi cơm điện đang đếm giờ, số phút thay đổi theo thời gian.

---

# 5. **Model class – cực quan trọng khi làm app**

Các app thật luôn tương tác với dữ liệu.  
Model class là cấu trúc mô tả đối tượng.

Ví dụ: User model

```dart
class User {
  String name;
  int age;

  User({required this.name, required this.age});
}
```

Dùng trong API + UI.

---

### 🧠 Lý thuyết chi tiết về Model Class

**Model Class là gì?**

- Class mô tả cấu trúc dữ liệu
- Dùng để chuyển đổi JSON ↔ Dart object
- Giúp code type-safe, dễ maintain

**Cấu trúc Model Class chuẩn:**

```dart
class User {
  final String id;
  final String name;
  final int age;
  final String? email; // Nullable

  User({
    required this.id,
    required this.name,
    required this.age,
    this.email, // Optional
  });

  // JSON → User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String?,
    );
  }

  // User → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
    };
  }
}
```

**Sử dụng Model:**

```dart
// Từ JSON
String jsonStr = '{"id":"1","name":"Dung","age":21}';
Map<String, dynamic> json = jsonDecode(jsonStr);
User user = User.fromJson(json);

// Sang JSON
Map<String, dynamic> json = user.toJson();
String jsonStr = jsonEncode(json);
```

---

### 🌟 Ví dụ thực tế: Product Model

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}
```

---

# 6. **Dart & JSON – kỹ năng sống còn khi dùng API**

API trả về JSON → bạn phải convert sang Dart Map/List.

```dart
import 'dart:convert';

void main() {
  String jsonStr = '{"name":"Tuan","age":20}';
  Map<String, dynamic> data = jsonDecode(jsonStr);

  print(data["name"]); // Tuan
}
```

---

# 7. **Async – Await (phần quan trọng nhất của chương)**

Flutter làm nhiều việc bất đồng bộ:

- đọc file  
- load dữ liệu  
- gọi API  
- chờ animation  
- chờ UI load  

---

### 🧠 Lý thuyết chi tiết về Async/Await

**Future là gì?**

- Đại diện cho giá trị sẽ có trong tương lai
- Có thể thành công (value) hoặc thất bại (error)
- Dùng cho các thao tác bất đồng bộ

**async/await:**

- `async` - Đánh dấu hàm là bất đồng bộ
- `await` - Chờ Future hoàn thành
- Code sau `await` chỉ chạy khi Future xong

**Cơ chế hoạt động:**

```dart
// Hàm async trả về Future
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2)); // Giả lập API call
  return "Hello";
}

// Sử dụng await
void main() async {
  print("Bắt đầu");
  var data = await fetchData(); // Chờ 2 giây
  print(data); // "Hello"
  print("Kết thúc");
}
```

**Xử lý lỗi:**

```dart
Future<String> fetchData() async {
  try {
    // API call
    return "Success";
  } catch (e) {
    throw Exception("Error: $e");
  }
}

void main() async {
  try {
    var data = await fetchData();
    print(data);
  } catch (e) {
    print("Lỗi: $e");
  }
}
```

---

## 📌 Future

```dart
Future<String> fetchData() async {
  return "Hello";
}
```

---

## 📌 async – await

```dart
void main() async {
  var data = await fetchData();
  print(data);
}
```

---

## 🧠 Hình dung đời sống  
- async giống như việc bạn bấm đặt đồ ăn → callback khi ship tới.  
- await giống như bạn đứng chờ gọi đồ ăn (chặn lại cho đến khi có dữ liệu).

---

## 📌 FutureBuilder – dùng để load API trong UI

```dart
FutureBuilder(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    return Text(snapshot.data.toString());
  },
);
```

Đây là công cụ bạn sẽ dùng **rất nhiều**.

---

### 🧠 Lý thuyết chi tiết về FutureBuilder

**FutureBuilder là gì?**

- Widget tự động rebuild khi Future thay đổi
- Hiển thị UI khác nhau theo trạng thái: loading, success, error
- Rất hữu ích khi load dữ liệu từ API

**Các trạng thái của snapshot:**

```dart
FutureBuilder<String>(
  future: fetchData(),
  builder: (context, snapshot) {
    // 1. Đang chờ
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 2. Có lỗi
    if (snapshot.hasError) {
      return Text("Lỗi: ${snapshot.error}");
    }
    
    // 3. Có dữ liệu
    if (snapshot.hasData) {
      return Text(snapshot.data!);
    }
    
    // 4. Không có dữ liệu
    return Text("Không có dữ liệu");
  },
)
```

**ConnectionState:**

- `ConnectionState.none` - Chưa bắt đầu
- `ConnectionState.waiting` - Đang chờ
- `ConnectionState.active` - Đang xử lý
- `ConnectionState.done` - Hoàn thành

---

### 🌟 Ví dụ thực tế: FutureBuilder với API

```dart
class ProductListScreen extends StatelessWidget {
  Future<List<Product>> fetchProducts() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 2));
    return [
      Product(id: "1", name: "Laptop", price: 1000),
      Product(id: "2", name: "Phone", price: 500),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm")),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text("Lỗi: ${snapshot.error}"),
                  ElevatedButton(
                    onPressed: () {
                      // Retry
                    },
                    child: Text("Thử lại"),
                  ),
                ],
              ),
            );
          }
          
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text("${products[index].price} đ"),
                );
              },
            );
          }
          
          return Center(child: Text("Không có dữ liệu"));
        },
      ),
    );
  }
}
```

---

# 8. **Extensions – kỹ thuật viết code nhanh hơn**

```dart
extension IntX on int {
  int doubleUp() => this * 2;
}

void main() {
  print(5.doubleUp()); // 10
}
```

Trong Flutter hay dùng để rút gọn UI.

---

# 9. **Lỗi sinh viên thường gặp**

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| Không hiểu async → FutureBuilder lỗi | không biết snapshot có trạng thái | check `snapshot.hasData` |
| Dùng var lung tung | thiếu type → khó debug | dùng kiểu rõ ràng |
| Không dùng `setState` | UI không update | luôn bọc thay đổi state bằng `setState()` |
| Model class sai kiểu JSON | nhầm int/string | in JSON ra xem kỹ |
| Viết code tất cả trong main.dart | lười tách file | chia theo screens/models/widgets |

---

## 🔴 Case Study: Các lỗi chi tiết và cách xử lý

### Case Study 1: FutureBuilder không kiểm tra snapshot.hasData

#### ❌ Vấn đề:

```dart
FutureBuilder(
  future: fetchData(),
  builder: (context, snapshot) {
    return Text(snapshot.data.toString()); // Crash nếu data = null!
  },
)
```

#### ✅ Giải pháp:

```dart
FutureBuilder(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text("Lỗi: ${snapshot.error}");
    }
    if (snapshot.hasData) {
      return Text(snapshot.data.toString());
    }
    return Text("Không có dữ liệu");
  },
)
```

---

### Case Study 2: Quên await trong async function

#### ❌ Vấn đề:

```dart
Future<String> fetchData() async {
  Future.delayed(Duration(seconds: 2)); // Quên await!
  return "Hello"; // Chạy ngay, không chờ 2 giây
}
```

#### ✅ Giải pháp:

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2)); // Có await
  return "Hello"; // Chờ 2 giây mới return
}
```

---

### Case Study 3: Model class không xử lý null

#### ❌ Vấn đề:

```dart
class User {
  final String email; // Không nullable
  
  User.fromJson(Map<String, dynamic> json) {
    email = json['email']; // Crash nếu email = null
  }
}
```

#### ✅ Giải pháp:

```dart
class User {
  final String? email; // Nullable
  
  User.fromJson(Map<String, dynamic> json) {
    email = json['email'] as String?; // An toàn
  }
}
```

---

### Case Study 4: Dùng var thay vì final/const

#### ❌ Vấn đề:

```dart
var userName = "Flutter"; // Có thể thay đổi nhầm
var count = 0;
```

#### ✅ Giải pháp:

```dart
final String userName = "Flutter"; // Không thể thay đổi
int count = 0; // Hoặc final nếu không đổi
```

---

### Case Study 5: List/Map không kiểm tra null

#### ❌ Vấn đề:

```dart
List<String> names = [];
String first = names[0]; // Crash nếu list rỗng!

Map<String, dynamic> user = {};
String name = user["name"]; // Null nếu không có key
```

#### ✅ Giải pháp:

```dart
List<String> names = [];
if (names.isNotEmpty) {
  String first = names[0];
}

Map<String, dynamic> user = {};
String? name = user["name"] as String?; // Nullable
if (name != null) {
  // Sử dụng name
}
```

---

# 10. **Best Practices & Tips**

## 10.1. **Dart Best Practices cho Flutter**

### 1. Luôn dùng final thay vì var

```dart
// ✅ ĐÚNG
final String name = "Flutter";
final int count = 0;

// ❌ SAI
var name = "Flutter";
var count = 0;
```

### 2. Type rõ ràng cho function parameters

```dart
// ✅ ĐÚNG
void processUser(User user) {}

// ❌ SAI
void processUser(user) {}
```

### 3. Xử lý null safety đúng cách

```dart
// ✅ ĐÚNG
String? name; // Nullable
if (name != null) {
  print(name.length);
}

// Hoặc dùng null-aware operator
print(name?.length ?? 0);
```

### 4. Model class luôn có fromJson và toJson

```dart
class Product {
  // Properties
  // Constructor
  // fromJson factory
  // toJson method
}
```

## 10.2. **Async/Await Best Practices**

### 1. Luôn xử lý lỗi

```dart
try {
  var data = await fetchData();
} catch (e) {
  print("Lỗi: $e");
}
```

### 2. Kiểm tra snapshot trong FutureBuilder

```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  // Loading
}
if (snapshot.hasError) {
  // Error
}
if (snapshot.hasData) {
  // Success
}
```

### 3. Không await trong build()

```dart
// ❌ SAI: await trong build()
@override
Widget build(BuildContext context) {
  var data = await fetchData(); // Lỗi!
}

// ✅ ĐÚNG: Dùng FutureBuilder
@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: fetchData(),
    builder: (context, snapshot) {...},
  );
}
```

---

# 11. **Bài tập thực hành**

1. **Tạo class `Product` có name, price, description.**  
   → Xem ví dụ Model Class phần 5

2. **Tạo List<Product> và in ra từng item.**  
   → Xem ví dụ List phần 2

3. **Parse chuỗi JSON thành Map và hiển thị ra console.**  
   → Xem ví dụ JSON phần 6

4. **Viết hàm async chờ 2 giây rồi trả về "Done!".**  
   → Xem ví dụ async/await phần 7

5. **Tạo StatefulWidget hiển thị số đếm và nút bấm tăng số.**  
   → Xem ví dụ StatefulWidget phần 4

6. **Tạo Model User với fromJson và toJson.**

7. **Tạo FutureBuilder load danh sách sản phẩm từ API (giả lập).**

8. **Xử lý lỗi trong async function và hiển thị trong UI.**

9. **Tạo extension method cho String để format số điện thoại.**

10. **Tạo hàm async fetchUser() và hiển thị trong FutureBuilder với loading/error states.**

---

# 12. **Mini Test cuối chương**

**Câu 1:** StatelessWidget dùng khi nào?  
→ Khi UI không thay đổi, không có state nội bộ.

**Câu 2:** Từ khóa giúp UI cập nhật trong StatefulWidget?  
→ `setState()` - bắt buộc phải gọi khi muốn cập nhật UI.

**Câu 3:** Dạng dữ liệu API thường trả về là gì?  
→ JSON: Map<String, dynamic>, List<dynamic>.

**Câu 4:** async–await dùng để làm gì?  
→ Xử lý bất đồng bộ (API call, file I/O, delay).

**Câu 5:** Model class dùng để làm gì?  
→ Định nghĩa cấu trúc dữ liệu, chuyển đổi JSON ↔ Dart object.

**Câu 6:** final vs const khác nhau như thế nào?  
→ final: giá trị runtime không đổi, const: hằng số compile-time.

**Câu 7:** FutureBuilder có những trạng thái nào?  
→ waiting (loading), hasError (lỗi), hasData (thành công).

**Câu 8:** Tại sao nên dùng final thay vì var?  
→ final không thể thay đổi, code an toàn hơn, dễ debug.

**Câu 9:** List và Map khác nhau như thế nào?  
→ List: danh sách có index, Map: key-value pairs.

**Câu 10:** Tại sao cần kiểm tra snapshot.hasData trong FutureBuilder?  
→ Tránh crash khi data = null, xử lý đúng các trạng thái.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Flutter = Widget** → tất cả đều là class.  
- **Dart phải vững**: List, Map, async/await.  
- **Stateless** = không đổi, **Stateful** = có trạng thái.  
- **FutureBuilder** là công cụ quan trọng khi xử lý API.  
- **Model class** giúp quản lý dữ liệu sạch sẽ (fromJson/toJson).  
- **setState()** = cập nhật giao diện (bắt buộc trong StatefulWidget).  
- **final** cho giá trị không đổi, **const** cho hằng số compile-time.  
- **async/await** xử lý bất đồng bộ, luôn xử lý lỗi với try-catch.  
- **List** dùng với ListView, **Map** dùng với JSON.  
- **Luôn kiểm tra** snapshot.hasData, hasError trong FutureBuilder.  

---

# 🎉 Kết thúc chương 02  
Tiếp theo, bạn sẽ học về cấu trúc dự án Flutter – điều cực kỳ quan trọng:

👉 **Chương 03 – Cấu trúc dự án Flutter & Tổ chức file**


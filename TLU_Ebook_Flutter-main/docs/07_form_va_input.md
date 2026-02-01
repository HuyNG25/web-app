# 🟦 CHƯƠNG 07  
# **FORM & INPUT TRONG FLUTTER**  
*(TextField – Form – Validation – Keyboard – Controllers)*

Gần như mọi ứng dụng đều cần nhập dữ liệu:

- đăng nhập  
- đăng ký  
- tạo ghi chú  
- nhập số tiền  
- tìm kiếm  

Vì vậy, hiểu TextField và Form là kỹ năng **bắt buộc** trong Flutter.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Tạo TextField để nhập dữ liệu.  
- Đọc dữ liệu từ TextField bằng controller.  
- Dùng Form + FormState để validate dữ liệu.  
- Hiểu cách xử lý keyboard.  
- Tránh các lỗi cực phổ biến khi nhập liệu.  
- Tạo màn hình đăng nhập đơn giản.

---

# 1. **TextField – widget nhập liệu cơ bản**

Đơn giản nhất:

```dart
TextField()
```

Nhưng trong thực tế, bạn gần như luôn cần controller.

---

# 2. **TextEditingController – lấy dữ liệu từ TextField**

```dart
final TextEditingController nameController = TextEditingController();
```

### Gán vào TextField:

```dart
TextField(
  controller: nameController,
)
```

### Lấy giá trị khi bấm nút:

```dart
print(nameController.text);
```

---

### 🧠 Lý thuyết chi tiết về TextEditingController

**TextEditingController là gì?**

- Là một **controller** quản lý nội dung của TextField
- Cung cấp **2-way binding**: đọc và ghi dữ liệu
- Có thể **lắng nghe thay đổi** qua `addListener()`
- **BẮT BUỘC phải dispose** khi không dùng nữa

**Lifecycle của Controller:**

```
Tạo controller (initState)
    ↓
Gán vào TextField
    ↓
Người dùng nhập liệu → controller.text thay đổi
    ↓
Lấy dữ liệu từ controller.text
    ↓
Dispose controller (dispose)
```

**Các thuộc tính quan trọng:**

```dart
controller.text          // Lấy/đặt nội dung
controller.selection     // Vị trí con trỏ
controller.value         // TextEditingValue (text + selection)
controller.clear()       // Xóa nội dung
controller.dispose()     // Giải phóng tài nguyên
```

**Lắng nghe thay đổi:**

```dart
@override
void initState() {
  super.initState();
  _controller.addListener(() {
    print("Text đã thay đổi: ${_controller.text}");
    // Có thể cập nhật UI real-time
  });
}

@override
void dispose() {
  _controller.removeListener(() {}); // Nếu đã add listener
  _controller.dispose();
  super.dispose();
}
```

---

### 🎒 Ví dụ đời sống  
TextEditingController giống như "cái hộp thư" chứa nội dung người dùng nhập vào.  
Bạn mở hộp → lấy ra `.text`.
Bạn cũng có thể đặt thư vào hộp → `controller.text = "Nội dung mới"`.

---

# 3. **Decoration – làm TextField đẹp và dễ dùng**

```dart
TextField(
  decoration: InputDecoration(
    labelText: "Tên",
    hintText: "Nhập tên của bạn",
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
)
```

### Các thuộc tính hay dùng:

- **labelText** - Nhãn hiển thị phía trên
- **hintText** - Gợi ý khi TextField trống
- **prefixIcon / suffixIcon** - Icon bên trái/phải
- **border** - Viền (OutlineInputBorder, UnderlineInputBorder)
- **errorText** - Thông báo lỗi (validate thủ công)
- **helperText** - Text gợi ý phía dưới
- **counterText** - Đếm ký tự (thường dùng với maxLength)
- **filled** - Tô màu nền
- **fillColor** - Màu nền khi filled = true

### 🌟 Ví dụ đầy đủ với các decoration:

```dart
TextField(
  decoration: InputDecoration(
    // Nhãn và gợi ý
    labelText: "Email",
    hintText: "example@email.com",
    helperText: "Nhập email của bạn",
    
    // Icon
    prefixIcon: Icon(Icons.email),
    suffixIcon: IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => controller.clear(),
    ),
    
    // Viền
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    
    // Màu nền
    filled: true,
    fillColor: Colors.grey[100],
    
    // Đếm ký tự
    counterText: "${controller.text.length}/100",
  ),
  maxLength: 100,
)
```

### 🎨 Các kiểu border phổ biến:

```dart
// 1. Outline (viền quanh)
border: OutlineInputBorder()

// 2. Underline (gạch chân)
border: UnderlineInputBorder()

// 3. Không viền
border: InputBorder.none
```

---

# 4. **Ẩn mật khẩu – obscureText**

```dart
TextField(
  obscureText: true,
  decoration: InputDecoration(
    labelText: "Mật khẩu",
  ),
)
```

---

# 5. **TextField có keyboard phù hợp**

```dart
keyboardType: TextInputType.number
```

### Các loại keyboardType:

- **TextInputType.text** - Bàn phím chữ thường
- **TextInputType.number** - Bàn phím số
- **TextInputType.phone** - Bàn phím điện thoại
- **TextInputType.emailAddress** - Bàn phím email (@, .com)
- **TextInputType.datetime** - Bàn phím ngày tháng
- **TextInputType.url** - Bàn phím URL (/, .com)
- **TextInputType.multiline** - Nhiều dòng (Enter xuống dòng)

### 🌟 Ví dụ sử dụng:

```dart
// Số điện thoại
TextField(
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(labelText: "Số điện thoại"),
)

// Email
TextField(
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(labelText: "Email"),
)

// Số tiền
TextField(
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  decoration: InputDecoration(labelText: "Số tiền"),
)

// Nhiều dòng
TextField(
  keyboardType: TextInputType.multiline,
  maxLines: 5,
  decoration: InputDecoration(labelText: "Mô tả"),
)
```

### 📱 InputFormatters - Định dạng input

Để giới hạn hoặc format input, dùng `inputFormatters`:

```dart
import 'package:flutter/services.dart';

// Chỉ cho phép số
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
)

// Giới hạn độ dài
TextField(
  inputFormatters: [
    LengthLimitingTextInputFormatter(10),
  ],
)

// Format số điện thoại (VD: 0123-456-789)
TextField(
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    // Có thể thêm MaskTextInputFormatter từ package
  ],
)
```

---

# 6. **Form & FormState – validation chuyên nghiệp**

### Tại sao cần Form?

- **validate nhiều input cùng lúc** - Kiểm tra tất cả field một lần
- **quản lý lỗi dễ hơn** - Tự động hiển thị errorText
- **logic gọn hơn** - Không cần validate từng field riêng lẻ
- **auto-save** - Có thể lưu trạng thái form
- **reset form** - Dễ dàng reset tất cả field

---

### 🧠 Lý thuyết chi tiết về Form

**Form vs TextField:**

```
TextField          → Chỉ nhập liệu, không có validation tự động
TextFormField      → TextField + validator (phải nằm trong Form)
Form               → Container chứa nhiều TextFormField
FormState          → Quản lý trạng thái của Form
GlobalKey<FormState> → Key để truy cập FormState
```

**Cơ chế hoạt động:**

1. **Form** chứa các **TextFormField**
2. Mỗi **TextFormField** có **validator** function
3. Khi gọi `formKey.currentState!.validate()`:
   - Flutter gọi validator của TẤT CẢ TextFormField
   - Nếu validator trả về String → hiển thị lỗi, return false
   - Nếu validator trả về null → hợp lệ, return true

**Validator function:**

```dart
String? validator(String? value) {
  // value có thể null hoặc empty
  if (value == null || value.isEmpty) {
    return "Không được để trống"; // Lỗi
  }
  // Kiểm tra logic khác...
  return null; // Hợp lệ
}
```

---

### Ví dụ Form đầy đủ

```dart
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(labelText: "Email"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email không được để trống";
          }
          if (!value.contains("@")) {
            return "Email không hợp lệ";
          }
          return null; // hợp lệ
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Hợp lệ: ${_emailController.text}");
          }
        },
        child: const Text("Gửi"),
      )
    ],
  ),
);
```

---

### 🌟 Các pattern validation phổ biến

#### 1. Validation email

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Email không được để trống";
  }
  // Regex kiểm tra email
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return "Email không hợp lệ";
  }
  return null;
}
```

#### 2. Validation mật khẩu

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Mật khẩu không được để trống";
  }
  if (value.length < 8) {
    return "Mật khẩu phải có ít nhất 8 ký tự";
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return "Mật khẩu phải có chữ hoa";
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return "Mật khẩu phải có số";
  }
  return null;
}
```

#### 3. Validation số điện thoại Việt Nam

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Số điện thoại không được để trống";
  }
  // Loại bỏ khoảng trắng và ký tự đặc biệt
  final phone = value.replaceAll(RegExp(r'[^\d]'), '');
  if (phone.length != 10) {
    return "Số điện thoại phải có 10 số";
  }
  if (!phone.startsWith('0')) {
    return "Số điện thoại phải bắt đầu bằng 0";
  }
  return null;
}
```

#### 4. Validation so sánh (nhập lại mật khẩu)

```dart
// Trong State class
String? _password;

// Field mật khẩu
TextFormField(
  obscureText: true,
  onSaved: (value) => _password = value,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Mật khẩu không được để trống";
    }
    if (value.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự";
    }
    return null;
  },
)

// Field nhập lại mật khẩu
TextFormField(
  obscureText: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập lại mật khẩu";
    }
    if (value != _password) {
      return "Mật khẩu không khớp";
    }
    return null;
  },
)
```

---

### 🧠 Giải thích cực rõ

- `Form` = "đơn đăng ký" chứa nhiều field
- `GlobalKey<FormState>` = "chìa khóa" để truy cập FormState
- `validator` = "luật kiểm tra" cho từng field
- `formKey.currentState!.validate()` = "kiểm tra toàn bộ form"
- `formKey.currentState!.save()` = "lưu giá trị của tất cả field" (dùng onSaved)
- `formKey.currentState!.reset()` = "reset toàn bộ form"  

---

# 7. **Tắt bàn phím khi chạm ra ngoài**

Sinh viên hay bị lỗi nhập xong → keyboard che UI.

### Cách tắt keyboard:

```dart
FocusScope.of(context).unfocus();
```

### Cách dùng:

```dart
GestureDetector(
  onTap: () => FocusScope.of(context).unfocus(),
  child: ...
)
```

---

### 🧠 Lý thuyết chi tiết về Keyboard & Focus

**Focus trong Flutter:**

- Mỗi TextField có một **FocusNode**
- Khi TextField được tap → nhận **focus** → keyboard hiện lên
- Khi mất focus → keyboard tự động ẩn

**Các cách xử lý keyboard:**

#### 1. Tắt keyboard khi tap ra ngoài

```dart
GestureDetector(
  onTap: () {
    // Tắt keyboard
    FocusScope.of(context).unfocus();
    // Hoặc
    FocusManager.instance.primaryFocus?.unfocus();
  },
  behavior: HitTestBehavior.opaque, // Quan trọng!
  child: Scaffold(
    body: Form(...),
  ),
)
```

#### 2. Tắt keyboard khi submit

```dart
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Tắt keyboard trước khi xử lý
      FocusScope.of(context).unfocus();
      // Xử lý form
      _submitForm();
    }
  },
  child: Text("Gửi"),
)
```

#### 3. Điều khiển focus programmatically

```dart
// Tạo FocusNode
final _emailFocus = FocusNode();
final _passwordFocus = FocusNode();

// Gán vào TextField
TextFormField(
  focusNode: _emailFocus,
  // Khi nhấn Enter, chuyển focus sang password
  onFieldSubmitted: (_) {
    _passwordFocus.requestFocus();
  },
)

TextFormField(
  focusNode: _passwordFocus,
  obscureText: true,
  // Khi nhấn Enter, tắt keyboard
  onFieldSubmitted: (_) {
    _passwordFocus.unfocus();
  },
)

// QUAN TRỌNG: Dispose FocusNode
@override
void dispose() {
  _emailFocus.dispose();
  _passwordFocus.dispose();
  super.dispose();
}
```

#### 4. Ẩn keyboard khi scroll

```dart
ListView(
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  children: [...],
)
```

#### 5. Điều chỉnh UI khi keyboard hiện lên

```dart
Scaffold(
  resizeToAvoidBottomInset: true, // Mặc định: true
  // Khi keyboard hiện, Scaffold tự động resize
  body: SingleChildScrollView(
    child: Form(...),
  ),
)
```

**Lưu ý quan trọng:**

- `resizeToAvoidBottomInset: true` → UI tự động đẩy lên khi keyboard hiện
- `resizeToAvoidBottomInset: false` → UI không đổi, keyboard che UI
- Dùng `SingleChildScrollView` để có thể scroll khi keyboard che UI

---

# 8. **Sử dụng TextFormField – phiên bản nâng cấp của TextField**

`TextFormField` = TextField + tích hợp validation.

```dart
TextFormField(
  decoration: InputDecoration(labelText: "Họ tên"),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Không được để trống";
    }
    return null;
  },
)
```

---

### 🧠 So sánh TextField vs TextFormField

| Tính năng | TextField | TextFormField |
|-----------|-----------|---------------|
| Nhập liệu | ✅ | ✅ |
| Controller | ✅ | ✅ |
| Decoration | ✅ | ✅ |
| Validator | ❌ | ✅ |
| onSaved | ❌ | ✅ |
| Phải nằm trong Form | ❌ | ✅ (để dùng validator) |

**Khi nào dùng TextField:**
- Chỉ cần nhập liệu đơn giản
- Không cần validation
- Search bar, filter input

**Khi nào dùng TextFormField:**
- Form có validation
- Cần kiểm tra dữ liệu trước khi submit
- Form đăng ký, đăng nhập, feedback

---

### 🌟 TextFormField với onSaved

`onSaved` được gọi khi `formKey.currentState!.save()` được gọi:

```dart
String? _email;
String? _password;

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        decoration: InputDecoration(labelText: "Email"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email không được để trống";
          }
          return null;
        },
        onSaved: (value) {
          _email = value; // Lưu giá trị
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Mật khẩu"),
        obscureText: true,
        validator: (value) {
          if (value == null || value.length < 6) {
            return "Mật khẩu phải >= 6 ký tự";
          }
          return null;
        },
        onSaved: (value) {
          _password = value; // Lưu giá trị
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save(); // Gọi onSaved của tất cả field
            // Bây giờ _email và _password đã có giá trị
            print("Email: $_email, Password: $_password");
          }
        },
        child: Text("Gửi"),
      ),
    ],
  ),
)
```

**Lưu ý:** `onSaved` chỉ được gọi khi `validate()` trả về `true` và sau đó gọi `save()`.

---

# 9. **Sai vs Đúng – sinh viên hay lỗi**

## ❌ Sai: Lấy dữ liệu trước khi người dùng nhập

```dart
// ❌ SAI: Lấy ngay sau khi tạo controller
final controller = TextEditingController();
print(controller.text);  // luôn trống vì chưa có dữ liệu
```

## ✔ Đúng: Lấy trong onPressed hoặc listener

```dart
// ✅ ĐÚNG: Lấy khi người dùng submit
ElevatedButton(
  onPressed: () {
    print(controller.text); // Lấy đúng lúc
  },
)
```

---

## ❌ Sai: validator không return string lỗi

```dart
// ❌ SAI: In ra console thay vì return
validator: (value) {
  if (value!.isEmpty) {
    print("Empty");  // Không hiển thị lỗi trên UI!
  }
}
```

## ✔ Đúng: Return string lỗi

```dart
// ✅ ĐÚNG: Return string để hiển thị lỗi
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Không được để trống"; // Hiển thị trên UI
  }
  return null; // Hợp lệ
}
```

---

## ❌ Sai: Quên dispose controller

```dart
// ❌ SAI: Tạo controller nhưng không dispose
class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
  // Thiếu dispose() → memory leak!
}
```

## ✔ Đúng: Luôn dispose controller

```dart
// ✅ ĐÚNG: Dispose trong dispose()
class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();
  
  @override
  void dispose() {
    controller.dispose(); // QUAN TRỌNG!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

---

## ❌ Sai: Đặt TextField trong Container có height cố định → tràn

```dart
// ❌ SAI: Container cố định height
Container(
  height: 50,
  child: TextField(
    maxLines: 5, // Muốn 5 dòng nhưng bị giới hạn
  ),
)
```

## ✔ Đúng: Để TextField tự giãn theo nội dung

```dart
// ✅ ĐÚNG: Không giới hạn height
TextField(
  maxLines: 5,
  minLines: 1,
  // Tự động giãn theo nội dung
)
```

---

## ❌ Sai: Dùng nhiều TextField mà không tắt keyboard → UI bị che

```dart
// ❌ SAI: Keyboard che UI, không thể scroll
Column(
  children: [
    TextField(...),
    TextField(...),
    TextField(...),
    // Keyboard che mất các field phía dưới
  ],
)
```

## ✔ Đúng: Dùng GestureDetector và SingleChildScrollView

```dart
// ✅ ĐÚNG: Có thể tắt keyboard và scroll
GestureDetector(
  onTap: () => FocusScope.of(context).unfocus(),
  behavior: HitTestBehavior.opaque,
  child: SingleChildScrollView(
    child: Column(
      children: [
        TextField(...),
        TextField(...),
        TextField(...),
      ],
    ),
  ),
)
```

---

## ❌ Sai: Validate từng field riêng lẻ thay vì dùng Form

```dart
// ❌ SAI: Validate thủ công, code dài dòng
bool isValid = true;
if (emailController.text.isEmpty) {
  setState(() => emailError = "Email trống");
  isValid = false;
}
if (passwordController.text.isEmpty) {
  setState(() => passwordError = "Password trống");
  isValid = false;
}
// ... nhiều dòng code
```

## ✔ Đúng: Dùng Form và validator

```dart
// ✅ ĐÚNG: Validate tự động, code gọn
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email trống";
          }
          return null;
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Tất cả đều hợp lệ
          }
        },
      ),
    ],
  ),
)
```

---

## ❌ Sai: Dùng TextField thay vì TextFormField trong Form

```dart
// ❌ SAI: TextField không có validator
Form(
  child: Column(
    children: [
      TextField(...), // Không có validator!
    ],
  ),
)
```

## ✔ Đúng: Dùng TextFormField trong Form

```dart
// ✅ ĐÚNG: TextFormField có validator
Form(
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          // Có thể validate
        },
      ),
    ],
  ),
)
```

---

## ❌ Sai: Không kiểm tra null trong validator

```dart
// ❌ SAI: Có thể crash nếu value null
validator: (value) {
  if (value.isEmpty) { // Lỗi nếu value = null
    return "Trống";
  }
}
```

## ✔ Đúng: Luôn kiểm tra null trước

```dart
// ✅ ĐÚNG: Kiểm tra null trước
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Trống";
  }
  return null;
}
```

---

## ❌ Sai: Tạo controller trong build()

```dart
// ❌ SAI: Tạo mới mỗi lần build
@override
Widget build(BuildContext context) {
  final controller = TextEditingController(); // Tạo mới mỗi lần!
  return TextField(controller: controller);
}
```

## ✔ Đúng: Tạo trong State class

```dart
// ✅ ĐÚNG: Tạo 1 lần trong State class
class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController(); // Tạo 1 lần
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

---

# 10. **Các ví dụ thực tế đa dạng**

## 10.1. **Ví dụ: Form Đăng nhập (Login)**

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Tắt keyboard
      FocusScope.of(context).unfocus();
      
      // Giả lập API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng nhập thành công!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "example@email.com",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email không được để trống";
                  }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                    return "Email không hợp lệ";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mật khẩu không được để trống";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải có ít nhất 6 ký tự";
                  }
                  return null;
                },
              ),
                const SizedBox(height: 30),
                _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Đăng nhập"),
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

## 10.2. **Ví dụ: Form Đăng ký (Register)**

```dart
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Họ và tên",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Họ tên không được để trống";
                    }
                    if (value.trim().length < 2) {
                      return "Họ tên phải có ít nhất 2 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email không được để trống";
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Số điện thoại",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Số điện thoại không được để trống";
                    }
                    if (value.length != 10) {
                      return "Số điện thoại phải có 10 số";
                    }
                    if (!value.startsWith('0')) {
                      return "Số điện thoại phải bắt đầu bằng 0";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    helperText: "Ít nhất 8 ký tự, có chữ hoa và số",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mật khẩu không được để trống";
                    }
                    if (value.length < 8) {
                      return "Mật khẩu phải có ít nhất 8 ký tự";
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return "Mật khẩu phải có chữ hoa";
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return "Mật khẩu phải có số";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Xác nhận mật khẩu",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng xác nhận mật khẩu";
                    }
                    if (value != _passwordController.text) {
                      return "Mật khẩu không khớp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Đăng ký"),
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

## 10.3. **Ví dụ: Search Bar**

```dart
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final List<String> _items = [
    "Áo thun",
    "Quần jean",
    "Giày thể thao",
    "Túi xách",
    "Mũ lưỡi trai",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<String> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) {
      return item.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Tìm kiếm...",
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                onPressed: () {
                    _searchController.clear();
                    _onSearchChanged("");
                  },
                )
              : null,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _filteredItems.isEmpty
        ? const Center(
            child: Text(
              "Không tìm thấy kết quả",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredItems[index]),
                leading: const Icon(Icons.shopping_bag),
              );
            },
          ),
    );
  }
}
```

---

## 10.4. **Ví dụ: Note Editor (Ghi chú)**

```dart
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSaved = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tiêu đề")),
      );
      return;
    }
    
    setState(() {
      _isSaved = true;
    });
    
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã lưu ghi chú!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghi chú mới"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: "Lưu",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Tiêu đề",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "Bắt đầu viết...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: null,
              minLines: 20,
              keyboardType: TextInputType.multiline,
            ),
            if (_isSaved)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Đã lưu"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 10.5. **Ví dụ: Product Form (Form sản phẩm)**

```dart
class Product {
  String name;
  double price;
  String description;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
  });
}

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submitForm() {
                  if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        quantity: int.parse(_quantityController.text),
      );
      
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã thêm sản phẩm: ${product.name}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm sản phẩm")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Tên sản phẩm",
                    prefixIcon: Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tên sản phẩm không được để trống";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Giá (VNĐ)",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Giá không được để trống";
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return "Giá phải là số dương";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Số lượng",
                    prefixIcon: Icon(Icons.inventory),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Số lượng không được để trống";
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity < 0) {
                      return "Số lượng phải là số nguyên >= 0";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Mô tả",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Mô tả không được để trống";
                    }
                    if (value.trim().length < 10) {
                      return "Mô tả phải có ít nhất 10 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Thêm sản phẩm"),
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

## 10.6. **Ví dụ: Feedback Form (Form đánh giá)**

```dart
class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_rating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn đánh giá")),
        );
        return;
      }
      
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cảm ơn bạn đã gửi phản hồi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gửi phản hồi")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Đánh giá của bạn",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Tên của bạn",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tên không được để trống";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email không được để trống";
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    labelText: "Phản hồi của bạn",
                    prefixIcon: Icon(Icons.feedback),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Vui lòng nhập phản hồi";
                    }
                    if (value.trim().length < 10) {
                      return "Phản hồi phải có ít nhất 10 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Gửi phản hồi"),
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

# 11. **Best Practices & Performance**

## 11.1. **Khi nào dùng TextField vs TextFormField**

### TextField - Dùng khi:
- Chỉ cần nhập liệu đơn giản
- Không cần validation
- Search bar, filter input
- Input không quan trọng (optional)

### TextFormField - Dùng khi:
- Form có validation bắt buộc
- Cần kiểm tra dữ liệu trước khi submit
- Form đăng ký, đăng nhập, feedback
- Input quan trọng (required)

---

## 11.2. **Tối ưu Performance**

### 1. Dispose controller đúng cách

```dart
// ✅ ĐÚNG: Dispose trong dispose()
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 2. Tránh rebuild không cần thiết

```dart
// ❌ SAI: Rebuild mỗi lần text thay đổi
TextField(
  onChanged: (value) {
    setState(() {
      // Rebuild toàn bộ widget
    });
  },
)

// ✅ ĐÚNG: Chỉ update phần cần thiết
TextField(
  controller: _controller,
  // Không cần setState nếu chỉ lấy giá trị khi submit
)
```

### 3. Sử dụng const cho decoration không đổi

```dart
// ✅ ĐÚNG: const decoration
TextField(
  decoration: const InputDecoration(
    labelText: "Email",
    prefixIcon: Icon(Icons.email),
  ),
)
```

---

## 11.3. **Best Practices**

### 1. Luôn dispose controller

```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _focusNode.dispose();
  super.dispose();
}
```

### 2. Kiểm tra null trong validator

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Không được để trống";
  }
  // Logic khác...
  return null;
}
```

### 3. Tắt keyboard khi submit

```dart
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Tắt keyboard
      _submitForm();
    }
  },
)
```

### 4. Dùng SingleChildScrollView cho form dài

```dart
SingleChildScrollView(
  child: Form(
    child: Column(
      children: [
        // Nhiều TextFormField
      ],
    ),
  ),
)
```

### 5. Sử dụng inputFormatters để giới hạn input

```dart
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
)
```

### 6. Focus management cho UX tốt hơn

```dart
// Chuyển focus tự động khi nhấn Enter
TextFormField(
  onFieldSubmitted: (_) {
    FocusScope.of(context).nextFocus(); // Chuyển sang field tiếp theo
  },
)
```

---

# 12. **Bài tập thực hành**

1. **Tạo form đăng ký có: họ tên, email, mật khẩu, nhập lại mật khẩu.**  
   → Xem ví dụ 10.2

2. **Tạo form nhập thông tin sản phẩm (tên, giá, mô tả).**  
   → Xem ví dụ 10.5

3. **Tạo search bar bằng TextField + IconButton.**  
   → Xem ví dụ 10.3

4. **Làm màn hình ghi chú có TextField lớn + nút lưu.**  
   → Xem ví dụ 10.4

5. **Làm form feedback (rating + message).**  
   → Xem ví dụ 10.6

6. **Tạo form đặt hàng:**
   - Tên người nhận
   - Số điện thoại (chỉ số, 10 ký tự)
   - Địa chỉ (multiline)
   - Ghi chú (optional)
   - Validate tất cả field

7. **Tạo form liên hệ:**
   - Họ tên
   - Email
   - Tiêu đề
   - Nội dung (multiline, tối thiểu 20 ký tự)
   - Có thể gửi kèm file (hiển thị tên file)

8. **Tạo form đổi mật khẩu:**
   - Mật khẩu cũ
   - Mật khẩu mới (validate: >= 8 ký tự, có chữ hoa, số)
   - Xác nhận mật khẩu mới (phải khớp)
   - Hiển thị strength của mật khẩu mới (weak/medium/strong)

9. **Tạo form tìm kiếm nâng cao:**
   - Search bar với filter
   - Filter theo giá (min-max)
   - Filter theo danh mục
   - Hiển thị số kết quả tìm thấy

10. **Tạo form profile:**
    - Avatar (có thể chọn ảnh)
    - Họ tên
    - Email (readonly)
    - Số điện thoại
    - Ngày sinh (date picker)
    - Địa chỉ
    - Lưu và hiển thị thông báo thành công

---

# 13. Mini Test cuối chương

**Câu 1:** TextEditingController dùng để làm gì?  
→ Lấy dữ liệu từ TextField, quản lý nội dung và selection.

**Câu 2:** validator trả về gì khi có lỗi?  
→ Thông báo lỗi dạng String. Trả về null nếu hợp lệ.

**Câu 3:** Làm sao để validate tất cả field?  
→ `_formKey.currentState!.validate()`.

**Câu 4:** obscureText dùng khi nào?  
→ Ẩn mật khẩu, hiển thị dấu chấm thay vì ký tự.

**Câu 5:** Làm sao tắt keyboard khi chạm ra ngoài?  
→ `FocusScope.of(context).unfocus()` hoặc `FocusManager.instance.primaryFocus?.unfocus()`.

**Câu 6:** Tại sao phải dispose TextEditingController?  
→ Để tránh memory leak, giải phóng tài nguyên.

**Câu 7:** TextField và TextFormField khác nhau như thế nào?  
→ TextFormField có validator và onSaved, phải nằm trong Form.

**Câu 8:** onSaved được gọi khi nào?  
→ Khi gọi `formKey.currentState!.save()` sau khi validate thành công.

**Câu 9:** Làm sao giới hạn input chỉ cho phép số?  
→ Dùng `inputFormatters: [FilteringTextInputFormatter.digitsOnly]`.

**Câu 10:** Làm sao chuyển focus sang field tiếp theo khi nhấn Enter?  
→ Dùng `onFieldSubmitted` và `FocusScope.of(context).nextFocus()`.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **TextField** nhập dữ liệu → **controller** lấy dữ liệu.  
- **Form + validator** = kiểm tra hợp lệ chuyên nghiệp.  
- **TextFormField** = TextField + validation tích hợp.  
- **Keyboard che màn hình?** → `unfocus()` + `SingleChildScrollView`.  
- **Luôn dispose controller** trong `dispose()` để tránh memory leak.  
- **Kiểm tra null** trong validator: `if (value == null || value.isEmpty)`.  
- **Dùng inputFormatters** để giới hạn/format input (số, độ dài, pattern).  
- **Focus management** giúp UX tốt hơn (nextFocus, requestFocus).  
- **onSaved** lưu giá trị khi gọi `formKey.currentState!.save()`.  
- **Tách UI và logic** để code dễ bảo trì và test.

---

# 🎉 Kết thúc chương 07  
Tiếp theo: chương cực kỳ quan trọng trong kiến trúc UI:

👉 **Chương 08 – State Management căn bản (setState, lifting state up)**


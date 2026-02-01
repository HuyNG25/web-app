# 🟦 THỰC HÀNH CHI TIẾT: FORM & INPUT (BÀI 07)

Tài liệu này giúp bạn làm chủ kỹ năng xử lý "nhập liệu" trong Flutter – từ cái ô nhập tên đơn giản đến cả một form đăng ký phức tạp với validation.

> **⚠️ BẮT BUỘC:** Hãy gõ từng dòng code để hiểu cơ chế hoạt động. Đừng copy-paste!
> **💡 TƯ DUY:** Nhập liệu = (Hỏi người dùng) + (Lấy câu trả lời) + (Kiểm tra đúng sai).

---

## 🎯 MỤC TIÊU SẢN PHẨM
1.  **Level 1 (Dễ): Simple Note** - *Làm quen TextField & Controller.*
2.  **Level 2 (Trung bình): Login Form** - *Làm quen Form, Validator, Ẩn mật khẩu.*
3.  **Level 3 (Khó): Survey Form** - *Checkbox, Radio, Dropdown, DatePicker.*
4.  **Level 4 (Rất khó): Registration Master** - *Form đầy đủ, FocusNode, Keyboard handling.*

---

## 🛠️ CHUẨN BỊ
1.  Tạo dự án mới (hoặc dùng dự án nháp):
    ```bash
    flutter create thuc_hanh_form
    cd thuc_hanh_form
    ```
2.  Setup `main.dart` với khung sườn trống:

```dart
import 'package:flutter/material.dart';

// Import các file bài tập (bỏ comment dần khi làm)
// import 'bai1_simple_note.dart';
// import 'bai2_login_form.dart';
// import 'bai3_survey_form.dart';
// import 'bai4_register_form.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: Text("HÃY KHAI BÁO MÀN HÌNH Ở ĐÂY")),
    ),
  ));
}
```

---

## 🟢 LEVEL 1: SIMPLE NOTE (TEXTFIELD CƠ BẢN)
**Mục tiêu:** Tạo một ô nhập ghi chú đơn giản. Nhập xong bấm nút "Xóa" thì xóa trắng ô nhập.
**Tư duy:** `TextField` là cái "vỏ" hiển thị. `TextEditingController` là cái "ruột" quản lý chữ bên trong. Muốn xóa chữ, ta phải tác động vào cái "ruột".

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai1_simple_note.dart`.

**Bước 2:** Nhập code. Chú ý State và Controller.

```dart
import 'package:flutter/material.dart';

class SimpleNoteScreen extends StatefulWidget {
  const SimpleNoteScreen({super.key});

  @override
  State<SimpleNoteScreen> createState() => _SimpleNoteScreenState();
}

class _SimpleNoteScreenState extends State<SimpleNoteScreen> {
  // 1. Tạo Controller để quản lý nội dung nhập liệu
  final TextEditingController _noteController = TextEditingController();
  
  // Biến lưu nội dung để hiển thị ra màn hình
  String _displayText = "";

  @override
  void dispose() {
    // 2. Luôn luôn dispose controller khi không dùng nữa để tránh rò rỉ bộ nhớ
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ghi Chú Đơn Giản")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Ô NHẬP LIỆU
            TextField(
              controller: _noteController, // Gắn Controller vào
              decoration: const InputDecoration(
                labelText: "Nhập ghi chú",
                hintText: "Ví dụ: Mua rau, Gọi cho mẹ...",
                prefixIcon: Icon(Icons.note_add),
                border: OutlineInputBorder(), // Viền bao quanh
              ),
              onChanged: (text) {
                // Sự kiện này chạy MỖI KHI bạn gõ 1 ký tự
                // setState(() { _displayText = text; }); // Uncomment nếu muốn hiện real-time
              },
            ),
            
            const SizedBox(height: 20),
            
            // HÀNG NÚT BẤM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Chia đều khoảng cách
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lấy dữ liệu từ controller và cập nhật lên UI
                    setState(() {
                      _displayText = _noteController.text;
                    });
                  },
                  child: const Text("Hiển thị"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () {
                    // Xóa nội dung trong controller
                    _noteController.clear();
                    setState(() {
                      _displayText = ""; // Xóa cả text hiển thị
                    });
                  },
                  child: const Text("Xóa trắng"),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // HIỂN THỊ KẾT QUẢ
            Text(
              "Nội dung: $_displayText",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `dispose()`: Giống như đi vệ sinh xong phải xả nước. Dùng xong controller phải dọn dẹp nó.
> - `controller.text`: Truy cập trực tiếp dòng chữ đang nằm trong ô `TextField`.
> - `controller.clear()`: Hàm tiện ích có sẵn để xóa sạch nội dung.

---

## 🟡 LEVEL 2: LOGIN FORM (VALIDATION)
**Mục tiêu:** Form đăng nhập có kiểm tra lỗi (Email không được trống, Mật khẩu phải > 6 ký tự).
**Tư duy:**
- `TextField` chỉ nhập được thôi, không biết đúng sai.
- Muốn "bắt lỗi" (validate), phải dùng `TextFormField` bọc trong `Form`.
- Cần một "chìa khóa" (`GlobalKey<FormState>`) để ra lệnh cho Form kiểm tra.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai2_login_form.dart`.

**Bước 2:** Xây dựng Form.

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Khóa của Form (quan trọng nhất)
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Biến trạng thái ẩn/hiện mật khẩu
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form( // Bắt buộc phải bọc trong Form
          key: _formKey, // Gắn chìa khóa vào
          child: Column(
            children: [
              // EMAIL FIELD
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress, // Bàn phím có @
                
                // Hàm kiểm tra lỗi
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập Email"; // Trả về chuỗi lỗi
                  }
                  if (!value.contains("@")) {
                    return "Email không hợp lệ (thiếu @)";
                  }
                  return null; // Không trả về gì => Hợp lệ
                },
              ),
              
              const SizedBox(height: 20),
              
              // PASSWORD FIELD
              TextFormField(
                controller: _passController,
                obscureText: _obscureText, // Ẩn/hiện mật khẩu
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  icon: const Icon(Icons.lock),
                  // Nút con mắt để ẩn/hiện
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nhập mật khẩu đi bạn ơi";
                  if (value.length < 6) return "Mật khẩu phải dài hơn 6 ký tự";
                  return null;
                },
              ),
              
              const SizedBox(height: 30),
              
              // BUTTON SUBMIT
              ElevatedButton(
                onPressed: () {
                  // Gọi lệnh kiểm tra toàn bộ Form
                  if (_formKey.currentState!.validate()) {
                    // Nếu validate trả về true => Form ngon lành
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đang đăng nhập...")),
                    );
                    print("Email: ${_emailController.text}");
                    print("Pass: ${_passController.text}");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Nút full width
                ),
                child: const Text("ĐĂNG NHẬP"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `Show/Hide Password`: Chỉ đơn giản là đổi giá trị boolean `_obscureText` và `setState`.
> - `validator`: Hàm này chạy khi gọi lệnh `validate()`. Nếu nó return chuỗi String -> chuỗi đó sẽ hiện đỏ lừ bên dưới ô nhập.
> - `_formKey.currentState!.validate()`: Câu thần chú kích hoạt việc kiểm tra lỗi.

---

## 🟠 LEVEL 3: SURVEY FORM (TEXTFIELD KHÔNG LÀ CHƯA ĐỦ)
**Mục tiêu:** Làm quen với các input khác: Checkbox, Radio Button, Dropdown, Slider.
**Tư duy:** Không phải lúc nào cũng nhập text. Đôi khi là chọn phương án. Mỗi loại input có cách quản lý state riêng.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai3_survey_form.dart`.

**Bước 2:** Khai báo các biến State để lưu giá trị.

```dart
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // Biến lưu trạng thái
  bool _isAgreed = false;             // Checkbox
  String _gender = "Nam";             // Radio Button (Nam/Nữ)
  String? _jobValues = "Sinh viên";   // Dropdown Button
  double _satisfaction = 5.0;         // Slider (1-10)

  // Danh sách nghề nghiệp cho Dropdown
  final List<String> _jobs = ["Sinh viên", "Lập trình viên", "Giáo viên", "Khác"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Khảo Sát Người Dùng")),
      body: SingleChildScrollView( // Cho phép cuộn nếu form dài
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DROPDOWN (Chọn nghề nghiệp)
            const Text("Nghề nghiệp của bạn:", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _jobValues,
              isExpanded: true, // Bung rộng hết cỡ
              items: _jobs.map((String job) {
                return DropdownMenuItem(value: job, child: Text(job));
              }).toList(),
              onChanged: (newValue) {
                setState(() { _jobValues = newValue; });
              },
            ),
            const SizedBox(height: 20),

            // 2. RADIO BUTTON (Chọn giới tính)
            const Text("Giới tính:", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Nam"),
                    value: "Nam",
                    groupValue: _gender, // Gom nhóm lại để chỉ chọn 1
                    onChanged: (val) { setState(() { _gender = val.toString(); }); },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Nữ"),
                    value: "Nữ", 
                    groupValue: _gender, // Cùng groupValue với Nam
                    onChanged: (val) { setState(() { _gender = val.toString(); }); },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. SLIDER (Mức độ hài lòng)
            Text("Mức độ hài lòng: ${_satisfaction.toInt()}/10", style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _satisfaction,
              min: 0, max: 10, divisions: 10, // Chia làm 10 nấc
              label: _satisfaction.round().toString(),
              onChanged: (val) {
                setState(() { _satisfaction = val; });
              },
            ),
            
            const SizedBox(height: 20),

            // 4. CHECKBOX (Điều khoản)
            CheckboxListTile(
              title: const Text("Tôi đồng ý với điều khoản sử dụng"),
              value: _isAgreed,
              onChanged: (val) {
                setState(() { _isAgreed = val ?? false; });
              },
              controlAffinity: ListTileControlAffinity.leading, // Checkbox nằm bên trái
            ),

            const SizedBox(height: 30),

            // NÚT GỬI
            Center(
              child: ElevatedButton(
                onPressed: _isAgreed ? () { // Nếu chưa check thì disable nút
                   _showResult();
                } : null, // null là disable nút
                child: const Text("GỬI KHẢO SÁT"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Kết quả"),
        content: Text("Nghề: $_jobValues\nGiới tính: $_gender\nĐiểm: $_satisfaction"),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `SingleChildScrollView`: Nếu form dài quá màn hình điện thoại thì người dùng có thể vuốt lên xem tiếp.
> - `RadioListTile.groupValue`: Các radio button có cùng `groupValue` sẽ tự động loại trừ nhau (chọn cái này thì cái kia bỏ chọn).
> - `CheckboxListTile`: Kết hợp Text và Checkbox tiện lợi.
> - `onPressed: _isAgreed ? ... : null`: Kỹ thuật disable nút. Nếu điều kiện sai -> gán null -> Nút xám đi không bấm được.

---

## 🔴 LEVEL 4: COMPLETE REGISTRATION (FOCUS NODE & KEYBOARD)
**Mục tiêu:** Xử lý UX chuyên nghiệp.
**Vấn đề:** Khi nhập xong Email, bấm Enter (Next) trên bàn phím thì phải tự nhảy trỏ chuột (Focus) sang ô Password. Bấm ra ngoài phải ẩn phím.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai4_register_form.dart`.

**Bước 2:** Code logic FocusNode.

```dart
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Tạo FocusNode để điều khiển trỏ chuột
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  @override
  void dispose() {
    // Đừng quên dispose cả FocusNode!
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector bọc ngoài cùng để bắt sự kiện chạm vào vùng trống -> Tắt phím
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Lệnh tắt bàn phím
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Đăng Ký Thành Viên")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 1. HỌ TÊN (Autofocus)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Họ và tên", border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next, // Nút Enter đổi thành Next
                  autofocus: true, // Vào màn hình là focus ngay
                  onFieldSubmitted: (_) {
                    // Khi bấm Next, chuyển focus sang Email
                    FocusScope.of(context).requestFocus(_emailFocusNode); 
                  },
                ),
                const SizedBox(height: 15),

                // 2. EMAIL
                TextFormField(
                  focusNode: _emailFocusNode, // Gán node
                  decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                ),
                const SizedBox(height: 15),

                // 3. ĐIỆN THOẠI
                TextFormField(
                  focusNode: _phoneFocusNode, // Gán node
                  decoration: const InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passFocusNode);
                  },
                ),
                const SizedBox(height: 15),

                // 4. MẬT KHẨU
                TextFormField(
                  focusNode: _passFocusNode, // Gán node
                  decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder()),
                  obscureText: true,
                  textInputAction: TextInputAction.done, // Nút Enter đổi thành Done (V)
                  onFieldSubmitted: (_) {
                    // Khi bấm Done, thực hiện submit form luôn
                    _submitForm();
                  },
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("HOÀN TẤT ĐĂNG KÝ"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Ẩn bàn phím trước khi xử lý
      FocusScope.of(context).unfocus();
      
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          title: Text("Thành công"),
          content: Text("Chào mừng thành viên mới!"),
        ),
      );
    }
  }
}
```

> **🧠 Giải thích code:**
> - `FocusNode`: Giống như "con mắt". TextField nào đang giữ "Focus" thì bàn phím sẽ nhập vào TextField đó.
> - `textInputAction: TextInputAction.next`: Đổi icon nút Enter trên bàn phím ảo thành mũi tên (Next) hoặc dấu tích (Done).
> - `FocusScope.of(context).requestFocus(node)`: Code để ép buộc chuyển con trỏ sang ô khác.

---

## 🏆 TỔNG KẾT
Chúc mừng! Bạn đã hoàn thành 4 bài tập về Form & Input.
Đây là kỹ năng cực kỳ quan trọng vì app nào cũng cần tương tác với người dùng.

Hãy nhớ:
- Dùng `TextField` cho nhập liệu đơn giản.
- Dùng `TextFormField` + `Form` khi cần bắt lỗi (Validate).
- Luôn `dispose` controller và focus node.
- Chú ý UX: Ẩn phím khi không dùng, chuyển focus khi bấm Next.
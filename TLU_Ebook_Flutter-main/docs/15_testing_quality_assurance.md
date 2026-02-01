# 🟦 CHƯƠNG 15  
# **TESTING TRONG FLUTTER**  
*(Unit Test – Widget Test – Integration Test – Test Coverage)*

Testing là **bước quan trọng** để đảm bảo app hoạt động đúng và không bị lỗi khi thêm tính năng mới.

Chương này giúp bạn viết test cơ bản cho Flutter app, đủ để bảo vệ code khỏi bug.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Hiểu tại sao cần testing.  
- Viết Unit Test cho function, class.  
- Viết Widget Test cho UI component.  
- Viết Integration Test cho flow hoàn chỉnh.  
- Chạy test và đọc kết quả.  
- Hiểu test coverage và cách cải thiện.

---

# 1. **Tại sao cần Testing?**

Testing giúp:

- **Phát hiện bug sớm** - Trước khi user gặp lỗi  
- **Tự tin refactor** - Thay đổi code mà không sợ phá vỡ  
- **Tài liệu sống** - Test mô tả cách code hoạt động  
- **Chất lượng code** - Code dễ test = code tốt hơn

---

### 🧠 Giảng giải chi tiết: Testing là gì?

**Testing là gì?**

- Quá trình **kiểm tra** code có hoạt động đúng không
- Viết code để **test code khác**
- Tự động chạy test mỗi khi thay đổi code
- Đảm bảo code **không bị phá vỡ** khi thêm tính năng mới

**Các loại test:**

```
Testing
├── Unit Test - Test function/class đơn lẻ
├── Widget Test - Test UI component
└── Integration Test - Test flow hoàn chỉnh
```

**Ví dụ minh họa:**

```dart
// Code cần test
int add(int a, int b) {
  return a + b;
}

// Test code
void main() {
  test('add function', () {
    expect(add(2, 3), 5);  // Kiểm tra: 2 + 3 = 5?
  });
}
```

---

# 2. **Cài đặt package test**

Trong `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

# 3. **Unit Test – test function/class**

Unit Test kiểm tra **logic** của function/class.

### Ví dụ: Test function tính tổng

```dart
// lib/utils/math_utils.dart
int add(int a, int b) {
  return a + b;
}

// test/utils/math_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/math_utils.dart';

void main() {
  test('add function returns correct sum', () {
    expect(add(2, 3), 5);
    expect(add(0, 0), 0);
    expect(add(-1, 1), 0);
  });
}
```

---

### 🧠 Giảng giải chi tiết: Unit Test là gì?

**Unit Test là gì?**

- Test **function/class đơn lẻ**
- Không cần UI, không cần widget
- Chạy rất nhanh
- Test logic, calculation, business rules

**Cấu trúc Unit Test:**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Nhóm test
  group('Math Utils', () {
    // Test case 1
    test('add function', () {
      // Arrange: Chuẩn bị
      int a = 2;
      int b = 3;
      
      // Act: Thực hiện
      int result = add(a, b);
      
      // Assert: Kiểm tra
      expect(result, 5);
    });
    
    // Test case 2
    test('subtract function', () {
      expect(subtract(5, 3), 2);
    });
  });
}
```

**Các hàm assert phổ biến:**

```dart
expect(actual, expected);           // So sánh bằng
expect(actual, isNot(expected));     // So sánh không bằng
expect(actual, isTrue);             // Là true
expect(actual, isFalse);            // Là false
expect(actual, isNull);             // Là null
expect(actual, isNotNull);          // Không null
expect(actual, greaterThan(5));     // Lớn hơn 5
expect(actual, lessThan(10));      // Nhỏ hơn 10
expect(actual, contains('text'));  // Chứa text
```

**Ví dụ minh họa: Unit Test đầy đủ**

```dart
// lib/models/user.dart
class User {
  final String name;
  final int age;
  
  User({required this.name, required this.age});
  
  bool isAdult() {
    return age >= 18;
  }
  
  String getGreeting() {
    return "Xin chào, tôi là $name";
  }
}

// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    test('isAdult returns true for age >= 18', () {
      final user = User(name: "John", age: 20);
      expect(user.isAdult(), isTrue);
    });
    
    test('isAdult returns false for age < 18', () {
      final user = User(name: "Jane", age: 16);
      expect(user.isAdult(), isFalse);
    });
    
    test('getGreeting returns correct message', () {
      final user = User(name: "John", age: 20);
      expect(user.getGreeting(), "Xin chào, tôi là John");
    });
  });
}
```

---

# 4. **Widget Test – test UI component**

Widget Test kiểm tra **UI component** có hiển thị đúng không.

### Ví dụ: Test Counter widget

```dart
// lib/widgets/counter.dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Count: $count"),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: Text("Increment"),
        ),
      ],
    );
  }
}

// test/widgets/counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter.dart';

void main() {
  testWidgets('Counter increments', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(Counter());
    
    // Tìm widget
    expect(find.text('Count: 0'), findsOneWidget);
    
    // Tap button
    await tester.tap(find.text('Increment'));
    await tester.pump();
    
    // Kiểm tra kết quả
    expect(find.text('Count: 1'), findsOneWidget);
  });
}
```

---

### 🧠 Giảng giải chi tiết: Widget Test là gì?

**Widget Test là gì?**

- Test **UI component** có hiển thị đúng không
- Test **tương tác** (tap, scroll, input)
- Chạy nhanh hơn Integration Test
- Không cần device thật

**Cấu trúc Widget Test:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Widget test name', (WidgetTester tester) async {
    // BƯỚC 1: Build widget
    await tester.pumpWidget(MyWidget());
    
    // BƯỚC 2: Tìm widget
    expect(find.text('Hello'), findsOneWidget);
    
    // BƯỚC 3: Tương tác
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();  // Rebuild sau khi tap
    
    // BƯỚC 4: Kiểm tra kết quả
    expect(find.text('World'), findsOneWidget);
  });
}
```

**Các hàm tìm widget:**

```dart
find.text('Hello')              // Tìm Text widget
find.byType(ElevatedButton)     // Tìm theo type
find.byKey(Key('myKey'))        // Tìm theo key
find.byIcon(Icons.star)         // Tìm theo icon
find.widgetWithText(Text, 'Hi') // Tìm widget có text
```

**Các hàm kiểm tra:**

```dart
findsOneWidget      // Tìm thấy đúng 1 widget
findsWidgets        // Tìm thấy nhiều widget
findsNothing        // Không tìm thấy
findsNWidgets(3)    // Tìm thấy đúng 3 widget
```

**Các hàm tương tác:**

```dart
await tester.tap(find.byType(Button));        // Tap
await tester.longPress(find.byType(Button));  // Long press
await tester.enterText(find.byType(TextField), 'text');  // Nhập text
await tester.drag(find.byType(ListView), Offset(0, -100));  // Kéo
await tester.pump();                          // Rebuild
await tester.pumpAndSettle();                 // Rebuild và chờ animation
```

**Ví dụ minh họa: Widget Test đầy đủ**

```dart
// test/widgets/login_form_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/login_form.dart';

void main() {
  testWidgets('Login form shows error when empty', (tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginForm(),
      ),
    );
    
    // Tìm TextField
    expect(find.byType(TextField), findsNWidgets(2));
    
    // Tap button (chưa nhập gì)
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Kiểm tra error message
    expect(find.text('Email không được để trống'), findsOneWidget);
  });
  
  testWidgets('Login form submits with valid data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginForm(),
      ),
    );
    
    // Nhập email
    await tester.enterText(
      find.byType(TextField).first,
      'user@example.com',
    );
    
    // Nhập password
    await tester.enterText(
      find.byType(TextField).last,
      'password123',
    );
    
    // Tap button
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Kiểm tra không có error
    expect(find.text('Email không được để trống'), findsNothing);
  });
}
```

---

# 5. **Integration Test – test flow hoàn chỉnh**

Integration Test kiểm tra **toàn bộ flow** từ đầu đến cuối.

### Ví dụ: Test flow đăng nhập

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Login flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Tìm và nhập email
    await tester.enterText(find.byKey(Key('email')), 'user@example.com');
    await tester.enterText(find.byKey(Key('password')), 'password123');
    
    // Tap login button
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    
    // Kiểm tra đã vào màn hình home
    expect(find.text('Home'), findsOneWidget);
  });
}
```

---

### 🧠 Giảng giải chi tiết: Integration Test là gì?

**Integration Test là gì?**

- Test **toàn bộ flow** của app
- Test nhiều màn hình, nhiều widget cùng lúc
- Chạy trên device/emulator thật
- Chậm hơn Unit Test và Widget Test

**Khi nào dùng Integration Test?**

- Test flow hoàn chỉnh (login → home → detail)
- Test navigation giữa các màn hình
- Test tương tác với API, database
- Test performance

**Ví dụ minh họa: Integration Test đầy đủ**

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Flow', () {
    testWidgets('Complete login flow', (tester) async {
      // BƯỚC 1: Khởi động app
      app.main();
      await tester.pumpAndSettle();
      
      // BƯỚC 2: Kiểm tra màn hình login
      expect(find.text('Đăng nhập'), findsOneWidget);
      
      // BƯỚC 3: Nhập thông tin
      await tester.enterText(find.byKey(Key('email')), 'user@example.com');
      await tester.enterText(find.byKey(Key('password')), 'password123');
      
      // BƯỚC 4: Tap login
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();
      
      // BƯỚC 5: Kiểm tra đã vào home
      expect(find.text('Home'), findsOneWidget);
    });
    
    testWidgets('Navigation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Tap vào item
      await tester.tap(find.text('Product 1'));
      await tester.pumpAndSettle();
      
      // Kiểm tra màn hình detail
      expect(find.text('Product Detail'), findsOneWidget);
      
      // Back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Kiểm tra về home
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
```

---

# 6. **Sai vs Đúng – lỗi sinh viên hay gặp**

## ❌ Sai: Quên await tester.pump()

```dart
await tester.tap(find.byType(Button));
expect(find.text('Updated'), findsOneWidget);  // Lỗi! Chưa rebuild
```

---

### 🔍 Giảng giải chi tiết: Tại sao cần pump()?

**Ví dụ minh họa lỗi:**

```dart
testWidgets('Counter test', (tester) async {
  await tester.pumpWidget(Counter());
  
  // ❌ SAI: Quên pump() sau khi tap
  await tester.tap(find.text('Increment'));
  expect(find.text('Count: 1'), findsOneWidget);
  // → Lỗi! UI chưa rebuild, vẫn hiển thị "Count: 0"
})
```

**✅ Giải pháp:**

```dart
testWidgets('Counter test', (tester) async {
  await tester.pumpWidget(Counter());
  
  // ✅ ĐÚNG: Có pump() sau khi tap
  await tester.tap(find.text('Increment'));
  await tester.pump();  // ← QUAN TRỌNG: Rebuild UI
  expect(find.text('Count: 1'), findsOneWidget);
})
```

---

## ✔ Đúng:

```dart
await tester.tap(find.byType(Button));
await tester.pump();  // Rebuild UI
expect(find.text('Updated'), findsOneWidget);
```

---

## ❌ Sai: Test không độc lập

```dart
int globalCount = 0;  // Dùng biến global

test('test 1', () {
  globalCount++;
  expect(globalCount, 1);
});

test('test 2', () {
  globalCount++;  // Phụ thuộc vào test 1!
  expect(globalCount, 2);
});
```

---

### 🔍 Giảng giải chi tiết: Test độc lập

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Test phụ thuộc lẫn nhau
int count = 0;

test('test 1', () {
  count = 5;
  expect(count, 5);
});

test('test 2', () {
  count++;  // Phụ thuộc vào test 1!
  expect(count, 6);
})
// → Nếu test 1 fail, test 2 cũng fail!
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Mỗi test độc lập
test('test 1', () {
  int count = 5;  // Biến local
  expect(count, 5);
});

test('test 2', () {
  int count = 6;  // Biến local riêng
  expect(count, 6);
})
```

---

## ✔ Đúng: Mỗi test độc lập, không phụ thuộc

---

## ❌ Sai: Test quá phức tạp

```dart
test('complex test', () {
  // Test quá nhiều thứ trong 1 test
  expect(add(1, 2), 3);
  expect(subtract(5, 3), 2);
  expect(multiply(2, 3), 6);
  expect(divide(6, 2), 3);
});
```

---

### 🔍 Giảng giải chi tiết: Test đơn giản

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Test quá nhiều thứ
test('math operations', () {
  expect(add(1, 2), 3);
  expect(subtract(5, 3), 2);
  expect(multiply(2, 3), 6);
  // → Nếu 1 cái fail, không biết cái nào!
})
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Tách thành nhiều test nhỏ
test('add function', () {
  expect(add(1, 2), 3);
});

test('subtract function', () {
  expect(subtract(5, 3), 2);
});

test('multiply function', () {
  expect(multiply(2, 3), 6);
})
// → Mỗi test rõ ràng, dễ debug
```

---

## ✔ Đúng: Tách thành nhiều test nhỏ, mỗi test 1 mục đích

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: Quên setup MaterialApp

#### ❌ Vấn đề:

```dart
testWidgets('Widget test', (tester) async {
  await tester.pumpWidget(MyWidget());  // ← Thiếu MaterialApp
  // → Lỗi: No Material widget found!
})
```

#### ✅ Giải pháp:

```dart
testWidgets('Widget test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyWidget(),  // ← Có MaterialApp
    ),
  );
})
```

---

### Case Study 2: Test async function không đúng

#### ❌ Vấn đề:

```dart
test('async test', () {
  Future.delayed(Duration(seconds: 1), () {
    expect(result, 5);  // ← Test kết thúc trước khi async hoàn thành!
  });
})
```

#### ✅ Giải pháp:

```dart
test('async test', () async {  // ← Có async
  final result = await someAsyncFunction();
  expect(result, 5);
})
```

---

# 7. **Các ví dụ thực tế đa dạng**

## 7.1. **Ví dụ: Unit Test cho Provider**

```dart
// test/providers/counter_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/providers/counter_provider.dart';

void main() {
  group('CounterProvider', () {
    test('initial count is 0', () {
      final provider = CounterProvider();
      expect(provider.count, 0);
    });
    
    test('increase increments count', () {
      final provider = CounterProvider();
      provider.increase();
      expect(provider.count, 1);
    });
    
    test('decrease decrements count', () {
      final provider = CounterProvider();
      provider.increase();
      provider.decrease();
      expect(provider.count, 0);
    });
  });
}
```

---

## 7.2. **Ví dụ: Widget Test cho Form**

```dart
// test/widgets/login_form_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/login_form.dart';

void main() {
  testWidgets('Login form validation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginForm(),
      ),
    );
    
    // Tap submit (chưa nhập gì)
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Kiểm tra error
    expect(find.text('Email không được để trống'), findsOneWidget);
    
    // Nhập email
    await tester.enterText(
      find.byKey(Key('email')),
      'invalid-email',
    );
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Kiểm tra error format
    expect(find.text('Email không hợp lệ'), findsOneWidget);
  });
}
```

---

## 7.3. **Ví dụ: Integration Test cho Navigation**

```dart
// integration_test/navigation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Navigation flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Tap vào item trong list
    await tester.tap(find.text('Product 1'));
    await tester.pumpAndSettle();
    
    // Kiểm tra màn hình detail
    expect(find.text('Product Detail'), findsOneWidget);
    expect(find.text('Product 1'), findsOneWidget);
    
    // Back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    
    // Kiểm tra về list
    expect(find.text('Product List'), findsOneWidget);
  });
}
```

---

# 8. **Best Practices**

## 8.1. **Quy tắc viết test**

1. **Test đơn giản** - Mỗi test chỉ test 1 thứ
2. **Test độc lập** - Test không phụ thuộc lẫn nhau
3. **Test nhanh** - Unit Test < 1s, Widget Test < 5s
4. **Test rõ ràng** - Tên test mô tả rõ mục đích
5. **Test đầy đủ** - Test cả success và error cases

## 8.2. **Cấu trúc test**

```dart
void main() {
  group('Feature Name', () {
    test('should do something when condition', () {
      // Arrange: Chuẩn bị
      // Act: Thực hiện
      // Assert: Kiểm tra
    });
  });
}
```

## 8.3. **Test Coverage**

- **Coverage** = % code được test
- Mục tiêu: > 80% coverage
- Chạy: `flutter test --coverage`

---

# 9. Bài tập thực hành

1. Viết Unit Test cho function tính toán (add, subtract, multiply).  
2. Viết Widget Test cho Counter widget (tap button, kiểm tra count).  
3. Viết Widget Test cho LoginForm (validation, submit).  
4. Viết Integration Test cho flow: Login → Home → Detail.  
5. Viết Unit Test cho Provider (CounterProvider, UserProvider).

---

# 10. Mini Test cuối chương

**Câu 1:** Unit Test dùng để test gì?  
→ Function/class đơn lẻ, logic, calculation.

**Câu 2:** Widget Test dùng để test gì?  
→ UI component, tương tác, hiển thị.

**Câu 3:** Integration Test dùng để test gì?  
→ Flow hoàn chỉnh, nhiều màn hình.

**Câu 4:** Tại sao cần await tester.pump() sau khi tap?  
→ Để rebuild UI trước khi kiểm tra kết quả.

**Câu 5:** Test coverage là gì?  
→ % code được test, mục tiêu > 80%.

**Câu 6:** Tại sao test phải độc lập?  
→ Để tránh test này ảnh hưởng test khác, dễ debug.

**Câu 7:** Khi nào dùng Unit Test vs Widget Test?  
→ Unit Test cho logic, Widget Test cho UI.

**Câu 8:** findsOneWidget khác gì findsWidgets?  
→ findsOneWidget: đúng 1 widget, findsWidgets: nhiều widget.

**Câu 9:** Tại sao cần MaterialApp trong Widget Test?  
→ Nhiều widget cần Material context để hoạt động.

**Câu 10:** Test quá phức tạp có vấn đề gì?  
→ Khó debug, không biết phần nào fail.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Unit Test** = test function/class, logic, calculation.  
- **Widget Test** = test UI component, tương tác, hiển thị.  
- **Integration Test** = test flow hoàn chỉnh, nhiều màn hình.  
- **Luôn await tester.pump()** sau khi tương tác để rebuild UI.  
- **Test độc lập** - Mỗi test không phụ thuộc test khác.  
- **Test đơn giản** - Mỗi test chỉ test 1 thứ.  
- **MaterialApp** cần thiết trong Widget Test.  
- **Test Coverage** mục tiêu > 80%.  
- **find.text()** để tìm widget, **expect()** để kiểm tra.  
- **group()** để nhóm test liên quan.

---

# 🎉 Kết thúc chương 15  
Bạn đã hoàn thành khóa học Flutter cơ bản! Chúc mừng! 🎊

👉 **Tiếp theo: Thực hành xây dựng ứng dụng thực tế và nâng cao kỹ năng!**


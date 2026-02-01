# 🟦 THỰC HÀNH CHƯƠNG 15: TESTING TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI ĐÃ CÓ KINH NGHIỆM**
> 
> Bài thực hành này hướng dẫn cách viết test cho Flutter app để đảm bảo chất lượng code.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Viết Unit Test cho function và class
- ✅ Viết Widget Test cho UI component
- ✅ Viết Integration Test cho flow hoàn chỉnh
- ✅ Chạy test và đọc kết quả
- ✅ Hiểu về test coverage

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt
- [ ] Kiến thức về Dart và Flutter cơ bản
- [ ] Hiểu về async/await

---

## BÀI TẬP 1: UNIT TEST CƠ BẢN

### Mục đích
Viết Unit Test cho function và class đơn giản.

### Yêu cầu

1. **Tạo file cần test:**
Tạo `lib/utils/math_utils.dart`:
```dart
class MathUtils {
  static int add(int a, int b) {
    return a + b;
  }
  
  static int subtract(int a, int b) {
    return a - b;
  }
  
  static int multiply(int a, int b) {
    return a * b;
  }
  
  static double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return a / b;
  }
}
```

2. **Tạo file test:**
Tạo `test/utils/math_utils_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/math_utils.dart';

void main() {
  group('MathUtils', () {
    test('add should return correct sum', () {
      // Arrange
      int a = 2;
      int b = 3;
      
      // Act
      int result = MathUtils.add(a, b);
      
      // Assert
      expect(result, 5);
    });
    
    test('add with negative numbers', () {
      expect(MathUtils.add(-1, 1), 0);
      expect(MathUtils.add(-5, -3), -8);
    });
    
    test('subtract should return correct difference', () {
      expect(MathUtils.subtract(5, 3), 2);
      expect(MathUtils.subtract(0, 5), -5);
    });
    
    test('multiply should return correct product', () {
      expect(MathUtils.multiply(2, 3), 6);
      expect(MathUtils.multiply(-2, 3), -6);
    });
    
    test('divide should return correct quotient', () {
      expect(MathUtils.divide(6, 2), 3.0);
      expect(MathUtils.divide(5, 2), 2.5);
    });
    
    test('divide by zero should throw error', () {
      expect(
        () => MathUtils.divide(5, 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

3. **Chạy test:**
```bash
flutter test test/utils/math_utils_test.dart
```

### Kết quả mong đợi
- Tất cả test pass
- Hiểu cấu trúc Unit Test

---

## BÀI TẬP 2: UNIT TEST CHO MODEL CLASS

### Mục đích
Test Model class với fromJson/toJson.

### Yêu cầu

1. **Tạo Model:**
Tạo `lib/models/user.dart`:
```dart
class User {
  final String id;
  final String name;
  final int age;
  final String? email;
  
  User({
    required this.id,
    required this.name,
    required this.age,
    this.email,
  });
  
  bool isAdult() {
    return age >= 18;
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String?,
    );
  }
  
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

2. **Tạo file test:**
Tạo `test/models/user_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    test('isAdult returns true for age >= 18', () {
      final user = User(id: '1', name: 'John', age: 20);
      expect(user.isAdult(), isTrue);
    });
    
    test('isAdult returns false for age < 18', () {
      final user = User(id: '1', name: 'Jane', age: 16);
      expect(user.isAdult(), isFalse);
    });
    
    test('fromJson creates User correctly', () {
      final json = {
        'id': '1',
        'name': 'John',
        'age': 20,
        'email': 'john@example.com',
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, '1');
      expect(user.name, 'John');
      expect(user.age, 20);
      expect(user.email, 'john@example.com');
    });
    
    test('fromJson handles null email', () {
      final json = {
        'id': '1',
        'name': 'John',
        'age': 20,
      };
      
      final user = User.fromJson(json);
      
      expect(user.email, isNull);
    });
    
    test('toJson converts User to Map correctly', () {
      final user = User(
        id: '1',
        name: 'John',
        age: 20,
        email: 'john@example.com',
      );
      
      final json = user.toJson();
      
      expect(json['id'], '1');
      expect(json['name'], 'John');
      expect(json['age'], 20);
      expect(json['email'], 'john@example.com');
    });
  });
}
```

### Kết quả mong đợi
- Test pass cho tất cả cases
- Hiểu cách test Model class

---

## BÀI TẬP 3: WIDGET TEST

### Mục đích
Test UI component với Widget Test.

### Yêu cầu

1. **Tạo Widget:**
Tạo `lib/widgets/counter.dart`:
```dart
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  
  void increment() {
    setState(() {
      count++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

2. **Tạo file test:**
Tạo `test/widgets/counter_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/counter.dart';

void main() {
  testWidgets('Counter increments when button is tapped', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(MaterialApp(home: Counter()));
    
    // Verify initial count
    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Count: 1'), findsNothing);
    
    // Tap button
    await tester.tap(find.text('Increment'));
    await tester.pump(); // Rebuild after tap
    
    // Verify count increased
    expect(find.text('Count: 0'), findsNothing);
    expect(find.text('Count: 1'), findsOneWidget);
  });
  
  testWidgets('Counter increments multiple times', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Counter()));
    
    // Tap 3 times
    await tester.tap(find.text('Increment'));
    await tester.pump();
    
    await tester.tap(find.text('Increment'));
    await tester.pump();
    
    await tester.tap(find.text('Increment'));
    await tester.pump();
    
    // Verify count is 3
    expect(find.text('Count: 3'), findsOneWidget);
  });
}
```

3. **Chạy test:**
```bash
flutter test test/widgets/counter_test.dart
```

### Kết quả mong đợi
- Widget Test pass
- Hiểu cách test UI component

---

## BÀI TẬP 4: WIDGET TEST CHO FORM

### Mục đích
Test form validation và submission.

### Yêu cầu

1. **Tạo Form:**
Tạo `lib/widgets/login_form.dart`:
```dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  
  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == 'user@example.com' &&
          _passwordController.text == 'password123') {
        setState(() {
          _errorMessage = null;
        });
        // Success
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: Key('email'),
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email không được để trống';
              }
              if (!value.contains('@')) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          TextFormField(
            key: Key('password'),
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password không được để trống';
              }
              return null;
            },
          ),
          if (_errorMessage != null)
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

2. **Tạo file test:**
Tạo `test/widgets/login_form_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/login_form.dart';

void main() {
  testWidgets('Login form shows error when empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: LoginForm())),
    );
    
    // Tap submit without entering data
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Verify error message
    expect(find.text('Email không được để trống'), findsOneWidget);
  });
  
  testWidgets('Login form shows error for invalid email', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: LoginForm())),
    );
    
    // Enter invalid email
    await tester.enterText(find.byKey(Key('email')), 'invalid-email');
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Verify error
    expect(find.text('Email không hợp lệ'), findsOneWidget);
  });
  
  testWidgets('Login form submits with valid data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: LoginForm())),
    );
    
    // Enter valid data
    await tester.enterText(find.byKey(Key('email')), 'user@example.com');
    await tester.enterText(find.byKey(Key('password')), 'password123');
    
    // Tap submit
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    
    // Verify no error
    expect(find.text('Email không được để trống'), findsNothing);
    expect(find.text('Invalid email or password'), findsNothing);
  });
}
```

### Kết quả mong đợi
- Test pass cho tất cả cases
- Hiểu cách test form validation

---

## BÀI TẬP 5: INTEGRATION TEST

### Mục đích
Test flow hoàn chỉnh của app.

### Yêu cầu

1. **Thêm package:**
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

2. **Tạo Integration Test:**
Tạo `integration_test/app_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete app flow', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();
    
    // Verify home screen
    expect(find.text('Home'), findsOneWidget);
    
    // Navigate to products
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    
    // Verify products screen
    expect(find.text('Product List'), findsOneWidget);
    
    // Tap on first product
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    
    // Verify product detail
    expect(find.text('Product Detail'), findsOneWidget);
  });
}
```

3. **Chạy test:**
```bash
flutter test integration_test/app_test.dart
```

### Kết quả mong đợi
- Integration Test pass
- Hiểu cách test flow hoàn chỉnh

---

## BÀI TẬP 6: TEST COVERAGE

### Mục đích
Kiểm tra test coverage và cải thiện.

### Yêu cầu

1. **Chạy test với coverage:**
```bash
flutter test --coverage
```

2. **Xem coverage report:**
```bash
# Cài lcov (nếu chưa có)
# Windows: choco install lcov
# macOS: brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Mở coverage/html/index.html trong browser
```

3. **Cải thiện coverage:**
- Thêm test cho các function chưa được test
- Đảm bảo coverage > 80%

### Kết quả mong đợi
- Hiểu về test coverage
- Biết cách cải thiện coverage

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Viết được Unit Test
- [ ] Viết được Widget Test
- [ ] Viết được Integration Test
- [ ] Chạy test và đọc kết quả
- [ ] Hiểu về test coverage

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Testing.

👉 **Tiếp theo:** Bài 16 - CI/CD & Release hoặc các bài nâng cao khác

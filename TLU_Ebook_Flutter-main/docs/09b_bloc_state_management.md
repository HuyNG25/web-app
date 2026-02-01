# 🟦 CHƯƠNG 09+  
# **QUẢN LÝ STATE VỚI BLOC (Business Logic Component)**  
*(Stream – Sink – Bloc – Cubit – Flutter Bloc)*

Nếu Provider là "xe số" (dễ đi, linh hoạt), thì BLoC là "xe phân khối lớn" (mạnh mẽ, chặt chẽ, cấu trúc rõ ràng).
Đây là kiến trúc state management phổ biến nhất trong các công ty công nghệ lớn (Enterprise Apps).

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Hiểu triết lý BLoC: Input là **Event**, Output là **State**.
- Phân biệt **Cubit** (đơn giản) và **Bloc** (nâng cao).
- Hiểu cơ chế **Stream** (dòng chảy dữ liệu).
- Sử dụng `BlocProvider`, `BlocBuilder`, `BlocListener`.
- Xây dựng app Counter và Login bằng Cubit/Bloc.

---

# 1. **BLoC là gì?**

BLoC (**B**usiness **Lo**gic **C**omponent) là mô hình tách biệt hoàn toàn Logic ra khỏi UI.

- **UI:** Chỉ gửi sự kiện (**Event**) và lắng nghe trạng thái (**State**).
- **BLoC:** Nhận Event -> Xử lý Logic -> Bắn ra State mới.

### 🔄 Mô hình luồng dữ liệu (The Stream):

```
[UI] --(gửi Event)--> [BLoC] --(xử lý)--> [New State] --(cập nhật)--> [UI]
```

Ví dụ Máy bán nước tự động:
1. Bạn (UI) bỏ xu vào (Event `InsertCoin`).
2. Máy (BLoC) kiểm tra tiền, tính toán (Logic).
3. Máy nhả lon nước ra (State `Success`).

---

# 2. **Cubit – Em trai của Bloc (Nên học trước)**

Cubit là phiên bản đơn giản hóa của Bloc.
- **Không cần Event class**: Chỉ cần gọi hàm (Function).
- **Vẫn dùng State**: Để cập nhật UI.

Dùng Cubit khi logic đơn giản (Counter, Toggle, Checkbox...).

### 💻 Cấu trúc Cubit:

Cài đặt package:
```yaml
dependencies:
  flutter_bloc: ^8.1.0
```

Tạo file `counter_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// State ở đây chỉ là một số nguyên (int)
class CounterCubit extends Cubit<int> {
  // Khởi tạo state ban đầu là 0
  CounterCubit() : super(0);

  // Function thay vì Event
  void increment() => emit(state + 1); // emit = bắn state mới ra ngoài
  void decrement() => emit(state - 1);
}
```

---

# 3. **Bloc – Phiên bản đầy đủ**

Bloc dùng khi logic phức tạp, cần theo dõi *nguyên nhân* thay đổi (Event gì đã gây ra State này?).
Ví dụ: Search (cần debounce), API call (cần loading/success/error).

### 💻 Cấu trúc Bloc:

Phải định nghĩa 3 thành phần: **State**, **Event**, **Bloc**.

**1. Định nghĩa Events (`counter_event.dart`):**
```dart
abstract class CounterEvent {}
class CounterIncrementPressed extends CounterEvent {} // Sự kiện bấm nút tăng
class CounterDecrementPressed extends CounterEvent {} // Sự kiện bấm nút giảm
```

**2. Định nghĩa Bloc (`counter_bloc.dart`):**
```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    // Đăng ký: Hễ gặp sự kiện A thì làm gì...
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    });
    
    on<CounterDecrementPressed>((event, emit) {
      emit(state - 1);
    });
  }
}
```

---

# 4. **Các Widget của Flutter Bloc**

Sau khi có file logic (Cubit/Bloc), ta cần kết nối với UI.

### 🛠 `BlocProvider` (Cung cấp)
Giống như `Provider`, đặt ở widget cha để cung cấp Bloc cho con.

```dart
BlocProvider(
  create: (context) => CounterCubit(),
  child: const CounterPage(),
)
```

### 🛠 `BlocBuilder` (Xây dựng UI)
Lắng nghe state thay đổi để vẽ lại UI (giống `Consumer` hoặc `context.watch`).

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, count) {
    return Text('$count', style: Theme.of(context).textTheme.headline4);
  },
)
```

### 🛠 `BlocListener` (Lắng nghe sự kiện phụ)
Dùng để hiện SnackBar, Dialog, chuyển màn hình... (những thứ **không** vẽ lại UI).

```dart
BlocListener<CounterCubit, int>(
  listener: (context, state) {
    if (state == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã đạt mốc 10!")),
      );
    }
  },
  child: Container(...),
)
```

---

# 5. **Ví dụ: Login với Bloc**

State của Login thường có 4 trạng thái:
1. `LoginInitial` (Chưa làm gì)
2. `LoginLoading` (Đang xoay xoay...)
3. `LoginSuccess` (Đăng nhập thành công)
4. `LoginFailure` (Lỗi, sai mật khẩu)

```dart
// STATE
abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

// CUBIT
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(String username, String password) async {
    emit(LoginLoading()); // 1. Báo UI hiện loading
    
    try {
      await Future.delayed(const Duration(seconds: 2)); // Giả lập gọi API
      
      if (username == "admin" && password == "123") {
        emit(LoginSuccess()); // 2. Báo thành công
      } else {
        emit(LoginFailure("Sai mật khẩu rồi!")); // 3. Báo lỗi
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}

// UI
BlocConsumer<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginFailure) {
       // Hiện lỗi
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
    } else if (state is LoginSuccess) {
       // Chuyển màn hình
       Navigator.pushReplacementNamed(context, '/home');
    }
  },
  builder: (context, state) {
    if (state is LoginLoading) {
      return const CircularProgressIndicator();
    }
    return ElevatedButton(
      onPressed: () => context.read<LoginCubit>().login("admin", "123"),
      child: const Text("Đăng nhập"),
    );
  },
)
```

---

# 🧠 TỔNG KẾT
- **Provider:** Đơn giản, dùng `ChangeNotifier`. Tốt cho app vừa và nhỏ.
- **Cubit:** Đơn giản hơn Bloc, dùng `Function`. Tốt cho đa số trường hợp.
- **Bloc:** Chặt chẽ, dùng `Event`. Tốt cho app cực lớn, cần Trace log rõ ràng (User làm gì, lúc nào).

Chọn vũ khí phù hợp với quy mô trận chiến nhé! 🚀

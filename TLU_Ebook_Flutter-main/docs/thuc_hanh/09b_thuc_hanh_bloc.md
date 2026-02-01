# 🟦 THỰC HÀNH CHI TIẾT: BLOC & CUBIT (BÀI 09B)

> **📌 YÊU CẦU:** Đã hoàn thành [Bài 09 - Provider](09_thuc_hanh_provider.md) trước khi học bài này.
> 
> **🔗 LIÊN KẾT:**
> - **Bài trước:** [09 - Provider State Management](09_thuc_hanh_provider.md) (Quản lý State đơn giản)
> - **Bài sau:** [10b - Dự án Tổng hợp](10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) (Kết hợp Bloc + Provider + API)

---

## 🎬 MỞ ĐẦU: BLOC LÀ GÌ? (DÙNG VÍ DỤ ĐỜI THƯỜNG)

### 🏪 Ví dụ 1: Quán cà phê đơn giản vs Quán cà phê chuyên nghiệp

**🏪 Quán cà phê đơn giản (Provider):**
- Bạn gọi món → Nhân viên báo "Đã nhận!" → Bạn chờ → Món đến
- **Vấn đề:** Không biết món đang ở giai đoạn nào (đang pha? đang giao? hay sắp xong?)
- Chỉ biết "đã thay đổi" nhưng không rõ thay đổi cái gì

**🏢 Quán cà phê chuyên nghiệp (BLoC):**
- Bạn gọi món → Màn hình hiển thị **"Đang chuẩn bị"** (State 1)
- → Màn hình chuyển **"Đang pha cà phê"** (State 2)  
- → Màn hình chuyển **"Đang giao hàng"** (State 3)
- → Màn hình chuyển **"Hoàn thành"** hoặc **"Thất bại - hết nguyên liệu"** (State 4)
- **Ưu điểm:** Biết chính xác món đang ở giai đoạn nào!

### 🚦 Ví dụ 2: Đèn giao thông

**Provider (Đơn giản):**
- Có một cái loa báo "Đèn đã đổi!" → Nhưng không biết đèn nào (đỏ, vàng, xanh?)

**BLoC (Rõ ràng):**
- Mỗi trạng thái là một State riêng: `ĐènĐỏ()`, `ĐènVàng()`, `ĐènXanh()`
- Biết chính xác đèn nào đang bật!

### 📚 Vậy BLoC là gì?

**BLoC = Business Logic Component** - Component quản lý Logic nghiệp vụ

**Tư duy đơn giản:**
- **Provider** = Nhân viên báo tin: "Có thay đổi!" (không nói rõ thay đổi gì)
- **BLoC** = Hệ thống đèn hiệu: Mỗi đèn = một State cụ thể (Đỏ, Vàng, Xanh)

**Lộ trình học:**
```
setState (Bài 08) 
    ↓ Đơn giản nhất
Provider (Bài 09) 
    ↓ Nâng cấp từ setState
BLoC (Bài này)
    ↓ Nâng cấp từ Provider
Clean Architecture (Bài 14)
```

---

## 🎯 MỤC TIÊU HỌC TẬP (TỪ DỄ ĐẾN KHÓ)

Chúng ta sẽ học **BLoC** theo thứ tự từ dễ đến khó:

1. **Level 1 (Dễ):** Counter Cubit - *Làm quen với Cubit cơ bản (giống Provider)*
2. **Level 2 (Trung bình):** Theme Cubit - *Áp dụng Cubit toàn cục (giống Theme Provider)*
3. **Level 3 (Khó):** Login Cubit - *Xử lý nhiều State phức tạp (BLoC tỏa sáng!)*
4. **Level 4 (Nâng cao):** Multi-BlocProvider - *Quản lý nhiều Cubit (giống MultiProvider)*

> **⚠️ BẮT BUỘC:** Hãy làm theo thứ tự từ Level 1 → 4, đừng nhảy cóc!
> 
> **💡 NGUYÊN TẮC:**
> - Mỗi Level xây dựng trên Level trước
> - Hiểu Level 1 → Dễ hiểu Level 2
> - Hiểu Level 2 → Dễ hiểu Level 3
> - Làm nhiều lần để quen tay!

---

## 🤔 TẠI SAO CẦN BLOC SAU KHI ĐÃ HỌC PROVIDER?

### 📖 Câu chuyện: Từ đơn giản đến phức tạp

Bạn đã học **Provider** (Bài 09) và thấy nó rất hay! Nhưng...

**Tưởng tượng:**
- Bạn đang làm **app đếm số** → Provider quá đủ! ✅
- Bạn làm **app đổi theme** → Provider vẫn ổn! ✅
- Bạn làm **app Login** với nhiều trạng thái → Provider bắt đầu khó! ⚠️
- Bạn làm **app thanh toán** với nhiều bước phức tạp → Provider rất khó! ❌

**Giống như:**
- Đi xe đạp → Tốt cho đường ngắn (Provider)
- Đi xe máy → Tốt hơn cho đường dài (BLoC)
- Đi ô tô → Cần cho đường cao tốc, đường xa (BLoC + Clean Architecture)

### 🎯 Vậy khi nào cần BLoC?

Sau khi học Provider (Bài 09), bạn có thể thắc mắc: **"Provider đã đủ dùng rồi, tại sao cần thêm BLoC?"**

### So sánh nhanh Provider vs BLoC:

| Tiêu chí | Provider | BLoC (Cubit) |
|----------|----------|--------------|
| **Độ phức tạp** | Đơn giản, dễ học | Hơi phức tạp hơn |
| **Cú pháp** | `notifyListeners()` | `emit(state)` |
| **Theo dõi State** | Không tự động | Có thể trace từng State |
| **Test** | Cần mock ChangeNotifier | Test State rất dễ dàng |
| **Debug** | Khó debug khi có nhiều Provider | Dễ debug với BlocObserver |
| **Phù hợp** | App nhỏ/trung bình, UI state | App lớn, business logic phức tạp |
| **Cấu trúc** | 1 class (Provider) | 2-3 class (Cubit/Bloc + State + Event) |

### Khi nào dùng Provider?
- ✅ Theme switching
- ✅ User preferences
- ✅ Shopping cart đơn giản
- ✅ Local state management
- ✅ App nhỏ/trung bình

### Khi nào dùng BLoC?
- ✅ Business logic phức tạp (Login, Payment)
- ✅ Cần trace từng State thay đổi
- ✅ App lớn, nhiều features
- ✅ Cần test kỹ lưỡng
- ✅ Team lớn, cần chuẩn hóa code

### Quan trọng: 
**Provider và BLoC KHÔNG loại trừ nhau!** Bạn có thể dùng cả 2:
- **Provider** cho UI state (Theme, Settings)
- **BLoC** cho Business logic (Auth, Payment, Data fetching)

---

## 📊 SO SÁNH CODE: COUNTER VỚI PROVIDER vs BLOC

Để dễ hiểu, hãy so sánh cùng một ví dụ Counter:

### Provider (Bài 09):
```dart
// Provider: 1 file, đơn giản
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Báo tin
  }
}

// UI: Dùng context.watch
final count = context.watch<CounterProvider>().count;
context.read<CounterProvider>().increment();
```

### BLoC (Cubit) - Bài này:
```dart
// Cubit: 1 file, tương tự Provider
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1); // Bắn State mới
}

// UI: Dùng BlocBuilder
BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('$count'),
)
context.read<CounterCubit>().increment();
```

**Nhận xét:** Với ví dụ đơn giản này, **Provider và Cubit gần như tương đương** về độ phức tạp. Nhưng với logic phức tạp hơn (Login, Payment), **BLoC sẽ thể hiện sức mạnh** rõ ràng hơn!

---

## 🎯 MỤC TIÊU SẢN PHẨM
1.  **Level 1 (Dễ): Counter Cubit** - *Làm quen Cubit cơ bản.*
2.  **Level 2 (Trung bình): Theme Cubit** - *Quản lý giao diện Sáng/Tối.*
3.  **Level 3 (Khó): Login Bloc** - *Xử lý trạng thái Loading/Success/Failure giả lập.*
4.  **Level 4 (Nâng cao): Multi-BlocProvider** - *Quản lý nhiều Cubit/Bloc cùng lúc (giống MultiProvider).*

---

## 🛠️ CHUẨN BỊ

**⚠️ QUAN TRỌNG:** Đảm bảo bạn đã hoàn thành [Bài 09 - Provider](09_thuc_hanh_provider.md) trước!

1.  Tạo dự án mới:
    ```bash
    flutter create thuc_hanh_bloc
    cd thuc_hanh_bloc
    ```
2.  **Cài đặt thư viện flutter_bloc:**
    Mở `pubspec.yaml`, thêm vào phần `dependencies`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_bloc: ^8.1.0  # <--- Thư viện quan trọng nhất
      equatable: ^2.0.5     # <--- Giúp so sánh State dễ hơn (tùy chọn nhưng nên dùng)
    ```
    Sau đó chạy lệnh: `flutter pub get`

3.  **Kiến thức cần có:**
    - ✅ Đã hiểu Provider (ChangeNotifier, notifyListeners, context.watch/read)
    - ✅ Hiểu về State Management cơ bản
    - ✅ Biết cách tách Logic ra khỏi UI

3.  Setup `main.dart` trống:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'bai1_counter_cubit.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(body: Center(child: Text("SETUP XONG"))),
  ));
}
```

---

## 🟢 LEVEL 1: COUNTER CUBIT (NHẬP MÔN)
**Độ khó:** ⭐ (Dễ nhất)

**Mục tiêu:** Tăng giảm số đếm dùng Cubit.
**Tư duy:** State là một số nguyên `int`.

### 🎭 Liên tưởng đời thường:

Hãy tưởng tượng bạn có một **cái đồng hồ đếm số**:

**Với Provider (Bạn đã học):**
- Mỗi khi số thay đổi → Có người hét "Số đã đổi!" → Bạn phải nhìn lại đồng hồ để biết số mới
- ❌ Phải tự kiểm tra số mới là gì

**Với BLoC (Bạn sẽ học):**
- Mỗi khi số thay đổi → Đồng hồ tự động cập nhật và báo "Số hiện tại là X!"
- ✅ Biết ngay số mới là gì, không cần kiểm tra

### 📚 Xây dựng từ kiến thức đã biết:

### 🔄 BƯỚC 1: NHỚ LẠI - CÁCH LÀM VỚI PROVIDER

Trong [Bài 09 - Provider](09_thuc_hanh_provider.md), chúng ta đã làm Counter như sau:

**Provider Code:**
```dart
// lib/providers/counter_provider.dart
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Báo tin: "Dữ liệu đã thay đổi!"
  }
  
  void decrement() {
    _count--;
    notifyListeners();
  }
}

// lib/bai1_counter.dart - UI
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ VẤN ĐỀ 1: context.watch ở đây sẽ rebuild TOÀN BỘ Widget
    final count = context.watch<CounterProvider>().count;
    
    print("UI Rebuild toàn bộ"); // Log này sẽ chạy mỗi lần count thay đổi
    
    return Scaffold(
      appBar: AppBar(title: const Text("Counter với Provider")),
      body: Center(
        child: Text("$count", style: TextStyle(fontSize: 80)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterProvider>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**⚠️ VẤN ĐỀ VỚI PROVIDER:**
1. **Rebuild toàn bộ Widget:** `context.watch` ở cấp `build()` sẽ rebuild toàn bộ `CounterScreen` mỗi khi `count` thay đổi
2. **Không tối ưu:** Ngay cả `AppBar` và `FloatingActionButton` cũng rebuild (mặc dù không cần thiết)
3. **Khó kiểm soát:** Không biết chính xác phần nào của UI sẽ rebuild

**✅ GIẢI PHÁP VỚI PROVIDER (Consumer):**
```dart
// Dùng Consumer để chỉ rebuild phần cần thiết
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter với Provider")),
      body: Center(
        // ✅ Consumer chỉ rebuild Text này thôi
        child: Consumer<CounterProvider>(
          builder: (context, provider, child) {
            return Text("${provider.count}", style: TextStyle(fontSize: 80));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterProvider>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Nhưng vẫn còn vấn đề:**
- Phải nhớ dùng `Consumer` thay vì `context.watch`
- Code dài dòng hơn một chút
- Không biết chính xác State nào đang được emit

### ✅ BƯỚC 2: HỌC MỚI - CÁCH LÀM VỚI BLOC (CUBIT)

**Tư duy:** BLoC giống Provider nhưng **tốt hơn** một chút!

**Sự khác biệt chính:**
- Provider: `notifyListeners()` → "Đã thay đổi!" (không nói rõ thay đổi gì)
- BLoC: `emit(5)` → "State mới là 5!" (nói rõ State mới)

**Ví dụ đời thường:**
- Provider = Người báo tin: "Có thay đổi!" 
- BLoC = Người báo tin: "Số mới là 5!"

### 📝 Hướng dẫn từng bước (Từng bước một):

**Bước 1:** Tạo file `lib/cubits/counter_cubit.dart`.

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit<int>: State quản lý là kiểu int
class CounterCubit extends Cubit<int> {
  // Khởi tạo giá trị ban đầu là 0
  CounterCubit() : super(0);

  // Logic tăng
  void increment() => emit(state + 1);

  // Logic giảm
  void decrement() => emit(state - 1);
}
```

**Bước 2:** Tạo UI `lib/bai1_counter.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/counter_cubit.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider cung cấp Cubit cho nhánh Widget con
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter Cubit")),
      body: Center(
        // BlocBuilder: Lắng nghe và vẽ lại UI khi state đổi
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) {
            return Text(
              '$count',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // context.read: Gọi hàm logic (giống Provider)
            // Lưu ý: KHÔNG dùng context.watch ở đây vì button không cần rebuild
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            // context.read: Không lắng nghe thay đổi, chỉ gọi hàm
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

> **🧠 Giải thích code chi tiết (Dùng ví dụ đời thường):**

#### 1. `emit(newValue)` vs `notifyListeners()`:

**Ví dụ đời thường:**
- **Provider (`notifyListeners`)**: Giống như có người hét "Có thay đổi!" → Bạn phải tự kiểm tra xem thay đổi gì
- **BLoC (`emit`)**: Giống như có người nói "Số mới là 5!" → Bạn biết ngay số mới là gì

```dart
// Provider: Chỉ báo tin "Dữ liệu đã thay đổi"
void increment() {
  _count++;
  notifyListeners(); // ❌ Không biết giá trị mới là gì, chỉ biết "đã thay đổi"
  // Giống như: "Có thay đổi!" → Phải tự nhìn đồng hồ để biết số mới
}

// BLoC: Bắn State cụ thể
void increment() => emit(state + 1); // ✅ Biết chính xác State mới là gì
// Giống như: "Số mới là 5!" → Biết ngay, không cần kiểm tra
```

**Lợi ích:**
- ✅ Biết chính xác State mới là gì
- ✅ Có thể log/trace State thay đổi
- ✅ Dễ debug hơn (giống như có GPS theo dõi mọi thay đổi)

#### 2. `BlocBuilder` vs `context.watch` vs `Consumer`:

**Ví dụ đời thường:**
- **`context.watch`**: Giống như bật đèn cả phòng để xem số → Tốn điện (rebuild toàn bộ)
- **`Consumer`/`BlocBuilder`**: Giống như chỉ bật đèn bàn để xem số → Tiết kiệm (chỉ rebuild phần cần)

```dart
// Provider - Cách 1: context.watch (❌ Rebuild toàn bộ)
final count = context.watch<CounterProvider>().count;
return Scaffold(...); // Toàn bộ Scaffold rebuild
// Giống như: Bật đèn cả phòng để xem số → Tốn điện!

// Provider - Cách 2: Consumer (✅ Chỉ rebuild phần cần)
Consumer<CounterProvider>(
  builder: (context, provider, child) => Text("${provider.count}"),
)
// Giống như: Chỉ bật đèn bàn → Tiết kiệm hơn

// BLoC: BlocBuilder (✅ Tự động tối ưu, rõ ràng hơn)
BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('$count'), // Chỉ rebuild Text này
)
// Giống như: Có cảm biến thông minh, chỉ bật đèn khi cần → Rất tiết kiệm!
```

**Lợi ích:**
- ✅ Rõ ràng: Biết chính xác phần nào rebuild (giống như biết đèn nào bật)
- ✅ Tự động tối ưu: Chỉ rebuild khi State thực sự thay đổi (cảm biến thông minh)
- ✅ Type-safe: Compiler báo lỗi nếu State type không đúng (giống như cảnh báo an toàn)

#### 3. `context.read<T>()`: Giống nhau ở cả 2

**Ví dụ đời thường:**
- **`context.read`**: Giống như **bấm nút** → Thực hiện hành động, nhưng không cần nghe phản hồi
- **`context.watch`/`BlocBuilder`**: Giống như **nghe radio** → Lắng nghe và phản ứng khi có thay đổi

```dart
// Provider
context.read<CounterProvider>().increment();
// Giống như: Bấm nút tăng → Số tăng, nhưng không cần biết số mới (button không cần rebuild)

// BLoC
context.read<CounterCubit>().increment();
// Giống như: Bấm nút tăng → Số tăng, logic giống hệt Provider

// ✅ Cả 2 đều: Gọi hàm, KHÔNG lắng nghe thay đổi
// ❌ KHÔNG dùng: context.watch ở đây (vì button không cần rebuild)
```

### 🔄 SO SÁNH CHI TIẾT: PROVIDER vs BLOC

| Khía cạnh | Provider | BLoC (Cubit) | Nhận xét |
|-----------|----------|--------------|----------|
| **Code length** | Ngắn hơn | Dài hơn một chút | Provider thắng |
| **Tối ưu rebuild** | Phải dùng `Consumer` | `BlocBuilder` tự động | BLoC thắng |
| **Type safety** | Runtime check | Compile-time check | BLoC thắng |
| **Debug** | Khó biết State mới | Dễ trace State | BLoC thắng |
| **Test** | Phải mock ChangeNotifier | Test State dễ dàng | BLoC thắng |
| **Độ phức tạp** | Đơn giản | Hơi phức tạp hơn | Provider thắng |
| **Phù hợp** | State đơn giản | Logic phức tạp | Tùy trường hợp |

### 📊 VÍ DỤ THỰC TẾ: Counter với nhiều nút bấm

**Vấn đề:** Khi có nhiều nút bấm, Provider phải dùng nhiều `Consumer`:

**Provider cách:**
```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CounterProvider>(
          builder: (context, provider, _) => Text("Count: ${provider.count}"),
        ),
      ),
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, provider, _) => Text(
            "${provider.count}",
            style: TextStyle(fontSize: 80),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().increment(),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().decrement(),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

**BLoC cách:**
```dart
class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ✅ BlocBuilder ở AppBar
        title: BlocBuilder<CounterCubit, int>(
          builder: (context, count) => Text("Count: $count"),
        ),
      ),
      body: Center(
        // ✅ BlocBuilder ở Body
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) => Text(
            '$count',
            style: TextStyle(fontSize: 80),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

**Nhận xét:**
- ✅ Cả 2 đều tối ưu (chỉ rebuild phần cần)
- ✅ BLoC rõ ràng hơn: Biết chính xác kiểu State (`int`)
- ✅ Provider ngắn gọn hơn nhưng phải nhớ dùng `Consumer`

### 🔄 So sánh nhanh:

| Provider | BLoC (Cubit) |
|----------|--------------|
| `notifyListeners()` | `emit(state)` |
| `context.watch<T>()` | `BlocBuilder<T, State>` |
| `context.read<T>()` | `context.read<T>()` (giống nhau) |
| `Consumer<T>` | `BlocBuilder<T, State>` |
| `ChangeNotifierProvider` | `BlocProvider` |

---

## 🟡 LEVEL 2: THEME CUBIT (GLOBAL BLOC)
**Độ khó:** ⭐⭐ (Trung bình) - *Nâng cấp từ Level 1*

**Mục tiêu:** Áp dụng Cubit cho toàn bộ ứng dụng (chuyển màu Sáng/Tối).

### 🎭 Liên tưởng đời thường:

**Tưởng tượng:** Bạn có một **công tắc đèn trong nhà**

**Với Provider (Bạn đã học):**
- Bật công tắc → Công tắc chỉ biết "Đã bật!" (boolean)
- → Phải tính toán lại xem đèn sáng hay tối

**Với BLoC (Bạn sẽ học):**
- Bật công tắc → Công tắc biết ngay "Đèn sáng!" hoặc "Đèn tối!" (ThemeData)
- → Không cần tính toán, dùng trực tiếp!

### 📚 Xây dựng từ Level 1:

**Bạn đã học ở Level 1:**
- ✅ Tạo Cubit
- ✅ Dùng `emit()` để bắn State
- ✅ Dùng `BlocBuilder` để hiển thị

**Bây giờ bạn sẽ học:**
- ✅ Dùng Cubit cho **toàn bộ app** (không chỉ 1 màn hình)
- ✅ State là **ThemeData** (phức tạp hơn `int`)

### 🔄 BƯỚC 1: NHỚ LẠI - CÁCH LÀM VỚI PROVIDER

Trong [Bài 09 - Provider](09_thuc_hanh_provider.md), chúng ta đã làm Theme như sau:

**Provider Code:**
```dart
// lib/providers/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get currentTheme => _isDarkMode 
      ? ThemeData.dark(useMaterial3: true) 
      : ThemeData.light(useMaterial3: true);
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ VẤN ĐỀ: context.watch ở đây rebuild TOÀN BỘ MyApp
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      theme: themeProvider.currentTheme, // Theme thay đổi
      home: const HomePage(),
    );
  }
}
```

**⚠️ VẤN ĐỀ VỚI PROVIDER:**
1. **Phải tạo getter `currentTheme`:** Logic tạo ThemeData nằm trong Provider
2. **Phải nhớ context.watch:** Quên là toàn bộ app không đổi theme
3. **Khó debug:** Không biết ThemeData mới là gì, chỉ biết boolean `_isDarkMode`

**✅ GIẢI PHÁP VỚI PROVIDER (Consumer):**
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.currentTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
```

**Nhưng vẫn còn vấn đề:**
- Phải tạo getter `currentTheme`
- Logic tạo ThemeData lẫn với business logic
- Khó test ThemeData

### ✅ BƯỚC 2: NÂNG CẤP - CÁCH LÀM VỚI BLOC (CUBIT)

**Tư duy:** Nâng cấp từ Level 1!

**Level 1:** State là `int` (đơn giản)
**Level 2:** State là `ThemeData` (phức tạp hơn, nhưng cách làm giống hệt!)

**Ví dụ đời thường:**
- Level 1 = Đếm số (1, 2, 3...)
- Level 2 = Đổi màu (Sáng, Tối) → Phức tạp hơn nhưng logic giống nhau!

Với BLoC, chúng ta lưu `ThemeData` trực tiếp làm State (giống như Level 1 lưu `int`):

### 📝 Hướng dẫn từng bước (Làm theo Level 1):

**Bước 1:** Tạo `lib/cubits/theme_cubit.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// State ở đây là ThemeData luôn cho tiện
class ThemeCubit extends Cubit<ThemeData> {
  // Mặc định là Light Theme
  ThemeCubit() : super(ThemeData.light());

  void toggleTheme() {
    // Nếu đang là sáng thì chuyển tối, ngược lại
    if (state.brightness == Brightness.light) {
      emit(ThemeData.dark());
    } else {
      emit(ThemeData.light());
    }
  }
}
```

**Bước 2:** Cấu hình `main.dart` để bọc toàn bộ App.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/theme_cubit.dart';
import 'bai1_counter.dart'; // Tận dụng lại bài 1

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp ThemeCubit cho toàn bộ app
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Bloc Demo',
            theme: theme, // Theme thay đổi theo state
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theme Switcher")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Gọi hàm toggleTheme
            context.read<ThemeCubit>().toggleTheme();
          },
          child: const Text("Đổi Giao Diện"),
        ),
      ),
    );
  }
}
```

### 🔄 SO SÁNH CHI TIẾT: PROVIDER vs BLOC - THEME

**Provider cách:**
```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // ❌ Lưu boolean
  
  bool get isDarkMode => _isDarkMode;
  
  // ❌ Phải tạo getter để convert boolean -> ThemeData
  ThemeData get currentTheme => _isDarkMode 
      ? ThemeData.dark(useMaterial3: true) 
      : ThemeData.light(useMaterial3: true);
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // ❌ Không biết ThemeData mới là gì
  }
}

// UI: Phải gọi getter
theme: themeProvider.currentTheme,
```

**BLoC cách:**
```dart
class ThemeCubit extends Cubit<ThemeData> { // ✅ Lưu ThemeData trực tiếp
  ThemeCubit() : super(ThemeData.light());
  
  void toggleTheme() {
    // ✅ Biết chính xác ThemeData mới là gì
    if (state.brightness == Brightness.light) {
      emit(ThemeData.dark());
    } else {
      emit(ThemeData.light());
    }
  }
}

// UI: Dùng State trực tiếp
BlocBuilder<ThemeCubit, ThemeData>(
  builder: (context, theme) => MaterialApp(theme: theme),
)
```

**✅ ƯU ĐIỂM CỦA BLOC:**
1. **State là ThemeData:** Không cần convert, dùng trực tiếp
2. **Rõ ràng hơn:** Biết chính xác ThemeData nào đang được dùng
3. **Dễ test:** Test ThemeData trực tiếp, không cần test boolean
4. **Logic tập trung:** Logic tạo ThemeData nằm trong Cubit

**📊 BẢNG SO SÁNH:**

| Khía cạnh | Provider | BLoC | Nhận xét |
|-----------|----------|------|----------|
| **State type** | `bool` (gián tiếp) | `ThemeData` (trực tiếp) | BLoC rõ ràng hơn |
| **Getter** | Cần `currentTheme` | Không cần | BLoC gọn hơn |
| **Logic** | Nằm trong getter | Nằm trong `toggleTheme` | BLoC tập trung hơn |
| **Test** | Test boolean + getter | Test ThemeData trực tiếp | BLoC dễ hơn |
| **Code length** | Ngắn hơn | Dài hơn một chút | Provider thắng |

**💡 KẾT LUẬN:**
- ✅ **Provider:** Đơn giản, phù hợp cho Theme
- ✅ **BLoC:** Rõ ràng hơn, dễ test hơn, phù hợp khi cần nhiều theme khác nhau

---

## 🟠 LEVEL 3: LOGIN CUBIT (XỬ LÝ TRẠNG THÁI PHỨC TẠP)
**Độ khó:** ⭐⭐⭐ (Khó) - *Nâng cấp từ Level 1 & 2*

**Mục tiêu:** Giả lập quá trình đăng nhập.
**Vấn đề:** Đăng nhập có 3 giai đoạn: `Loading` (xoay xoay) -> `Success` (vào nhà) hoặc `Failure` (báo lỗi).
**Tư duy:** Dùng Class state chứ không dùng kiểu nguyên thủy nữa.

### 🎭 Liên tưởng đời thường:

**Tưởng tượng:** Bạn đang **gọi món ăn tại nhà hàng**

**Các giai đoạn:**
1. **Chờ đợi** (Loading) - Nhân viên nhận đơn, bạn chờ...
2. **Thành công** (Success) - Món đến, bạn ăn ngon!
3. **Thất bại** (Failure) - Hết món, nhân viên báo lỗi

**Với Provider:**
- Nhân viên chỉ nói: "Đã thay đổi!" → Bạn không biết đang ở giai đoạn nào
- Phải tự đoán: "Đang chờ? Hay đã xong? Hay lỗi?"

**Với BLoC:**
- Mỗi giai đoạn = một State riêng: `ĐangChờ()`, `ThànhCông()`, `ThấtBại("Hết món")`
- Biết chính xác đang ở giai đoạn nào!

### 📚 Xây dựng từ Level 1 & 2:

**Bạn đã học ở Level 1 & 2:**
- ✅ State đơn giản: `int`, `ThemeData`
- ✅ Mỗi lần chỉ có 1 State

**Bây giờ bạn sẽ học:**
- ✅ **Nhiều State khác nhau**: `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`
- ✅ Mỗi State = một Class riêng
- ✅ Đây là nơi **BLoC tỏa sáng** so với Provider!

> **💡 LƯU Ý:** Đây là nơi **BLoC tỏa sáng** so với Provider! Với logic phức tạp như Login (có nhiều State khác nhau), BLoC giúp code rõ ràng và dễ test hơn rất nhiều.

### 🔄 NẾU LÀM VỚI PROVIDER SẼ NHƯ THẾ NÀO?

Với Provider, bạn phải dùng **enum** hoặc **boolean flags**:

```dart
// lib/providers/login_provider.dart
enum LoginStatus { initial, loading, success, failure }

class LoginProvider extends ChangeNotifier {
  LoginStatus _status = LoginStatus.initial; // ❌ Enum
  String? _error; // ❌ Phải lưu error riêng
  
  // ❌ Phải tạo nhiều getters
  LoginStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == LoginStatus.loading;
  bool get isSuccess => _status == LoginStatus.success;
  bool get isFailure => _status == LoginStatus.failure;
  
  Future<void> login(String username, String password) async {
    _status = LoginStatus.loading;
    _error = null; // ❌ Phải reset error
    notifyListeners(); // ❌ Không rõ đang emit State nào
    
    await Future.delayed(Duration(seconds: 2));
    
    if (username == "admin" && password == "123456") {
      _status = LoginStatus.success;
      _error = null;
    } else {
      _status = LoginStatus.failure;
      _error = "Sai tài khoản hoặc mật khẩu!"; // ❌ Phải set error
    }
    notifyListeners(); // ❌ Vẫn không rõ đang emit State nào
  }
}
```

**UI với Provider:**
```dart
// lib/bai3_login_provider.dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>(); // ❌ Rebuild toàn bộ
    
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Nhập Provider")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ❌ Phải check nhiều điều kiện
            if (loginProvider.isLoading)
              const CircularProgressIndicator()
            else ...[
              const Icon(Icons.person, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: "Username (admin)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password (123456)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<LoginProvider>();
                    provider.login(
                      _userController.text,
                      _passController.text,
                    ).then((_) {
                      // ❌ Phải check status sau khi login
                      if (provider.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đăng nhập thành công!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Navigator.pushNamed(context, '/home');
                      } else if (provider.isFailure) {
                        // ❌ Phải check error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.error ?? "Lỗi không xác định"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                  child: const Text("LOGIN"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**⚠️ VẤN ĐỀ VỚI PROVIDER:**
1. **Phải dùng enum:** Không type-safe, dễ nhầm lẫn
2. **Phải tạo nhiều getters:** `isLoading`, `isSuccess`, `isFailure`
3. **Phải lưu error riêng:** `_error` riêng biệt với `_status`
4. **Khó biết State hiện tại:** `notifyListeners()` không cho biết State nào
5. **Code dài dòng:** Phải check nhiều điều kiện trong UI
6. **Khó test:** Phải test nhiều getters
7. **Side effects phức tạp:** Phải dùng `.then()` hoặc `addListener()` để xử lý SnackBar

### ✅ GIẢI PHÁP VỚI BLOC (CUBIT)

Với BLoC, mỗi State là một class riêng, rõ ràng và type-safe:

**✅ ƯU ĐIỂM CỦA BLOC:**
1. **Mỗi State là một class:** Rõ ràng, type-safe
2. **Biết chính xác State nào:** `emit(LoginLoading())` → Biết ngay là Loading
3. **Error gắn liền với State:** `LoginFailure(error)` → Error là part của State
4. **Code ngắn gọn:** Không cần nhiều getters
5. **Dễ test:** Test từng State class riêng biệt
6. **Side effects tách biệt:** `BlocListener` xử lý SnackBar/Navigate riêng

**📊 SO SÁNH CODE UI:**

| Khía cạnh | Provider | BLoC | Nhận xét |
|-----------|----------|------|----------|
| **Check state** | `if (provider.isLoading)` | `if (state is LoginLoading)` | BLoC type-safe hơn |
| **Show error** | `provider.error` (riêng biệt) | `state.error` (trong State) | BLoC rõ ràng hơn |
| **Side effects** | `.then()` hoặc `addListener()` | `BlocListener` (tách biệt) | BLoC tốt hơn |
| **Code length** | Dài hơn | Ngắn gọn hơn | BLoC thắng |
| **Readability** | Nhiều điều kiện | Rõ ràng, dễ đọc | BLoC thắng |

### 📝 Hướng dẫn từng bước (Làm chậm, từng bước một):

**Lưu ý:** Đây là bài khó hơn Level 1 & 2. Hãy làm từng bước, đừng vội!

**Bước 1:** Định nghĩa State (`lib/blocs/login/login_state.dart`).

```dart
abstract class LoginState {}

class LoginInitial extends LoginState {}      // Trạng thái ban đầu
class LoginLoading extends LoginState {}      // Đang xử lý
class LoginSuccess extends LoginState {}      // Thành công
class LoginFailure extends LoginState {       // Thất bại
  final String error;
  LoginFailure(this.error);
}
```

**Bước 2:** Viết Logic Cubit (`lib/blocs/login/login_cubit.dart`).

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String username, String password) async {
    // 1. Bắn ra trạng thái Loading
    emit(LoginLoading());

    // 2. Giả lập gọi API mất 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // 3. Kiểm tra kết quả
    if (username == "admin" && password == "123456") {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure("Sai tài khoản hoặc mật khẩu!"));
    }
  }
}
```

**Bước 3:** Tạo giao diện Login (`lib/bai3_login.dart`).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/login_cubit.dart';
import 'blocs/login/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginForm(), // Tách ra widget con để code gọn
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Nhập Bloc")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        
        // BlocConsumer = BlocBuilder + BlocListener
        // Vừa vẽ lại UI (builder), vừa lắng nghe sự kiện (listener)
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            // Xử lý sự kiện 1 lần (SnackBar, Dialog, Navigate)
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đăng nhập thành công!"), backgroundColor: Colors.green),
              );
              // Navigator.pushNamed(context, '/home'); // Chuyển màn hình ở đây
            }
          },
          builder: (context, state) {
            // Vẽ giao diện dựa trên state
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: "Username (admin)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password (123456)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<LoginCubit>().login(
                        _userController.text, 
                        _passController.text
                      );
                    },
                    child: const Text("LOGIN"),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code (Dùng ví dụ đời thường):**

**`BlocConsumer`** = Widget mạnh mẽ nhất (kết hợp `BlocBuilder` + `BlocListener`)

**Ví dụ đời thường:**
- **`builder`**: Giống như **vẽ tranh** → Vẽ những thứ hiển thị trên màn hình (nút bấm, ô nhập, vòng xoay loading)
- **`listener`**: Giống như **hệ thống cảnh báo** → Xử lý những thứ chỉ xảy ra 1 lần (Thông báo lỗi, Chuyển trang)

**Lưu ý quan trọng:**
- ✅ `builder`: Vẽ UI (Text, Button, Loading...)
- ✅ `listener`: Xử lý side effects (SnackBar, Dialog, Navigate)
- ❌ **KHÔNG BAO GIỜ** vẽ UI trong `listener` hoặc navigate trong `builder`!

**Tại sao tách biệt?**
- Giống như **tách bếp và phòng khách** → Bếp (listener) nấu ăn, phòng khách (builder) trưng bày
- Dễ debug, dễ maintain, code rõ ràng hơn!

### 🔄 SO SÁNH CHI TIẾT: PROVIDER vs BLOC - LOGIN

**📊 BẢNG SO SÁNH ĐẦY ĐỦ:**

| Khía cạnh | Provider | BLoC | Ví dụ |
|-----------|----------|------|-------|
| **State definition** | Enum hoặc boolean flags | State classes | `LoginState` vs `LoginStatus` |
| **Check state** | `if (provider.isLoading)` | `if (state is LoginLoading)` | BLoC type-safe |
| **Error handling** | `provider.error` (riêng) | `state.error` (trong State) | BLoC gắn liền |
| **Side effects** | `.then()` hoặc `addListener()` | `BlocListener` | BLoC tách biệt |
| **UI rebuild** | `context.watch` (toàn bộ) | `BlocBuilder` (chỉ phần cần) | BLoC tối ưu |
| **Code length** | Dài hơn | Ngắn gọn hơn | BLoC thắng |
| **Type safety** | Runtime check | Compile-time check | BLoC thắng |
| **Debug** | Khó biết State nào | Biết chính xác State | BLoC thắng |
| **Test** | Phải test nhiều getters | Test State class | BLoC dễ hơn |

**💡 VÍ DỤ CỤ THỂ: Xử lý Error**

**Provider cách:**
```dart
// ❌ Phải check nhiều điều kiện
provider.login(user, pass).then((_) {
  if (provider.isFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.error ?? "Lỗi")),
    );
  }
});
```

**BLoC cách:**
```dart
// ✅ BlocListener tự động xử lý
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginFailure) {
      // ✅ State chứa error luôn, không cần check null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: ...,
)
```

**✅ ƯU ĐIỂM CHÍNH CỦA BLOC:**
1. **Type-safe:** `state is LoginLoading` → Compiler check
2. **Rõ ràng:** Biết chính xác State nào đang được emit
3. **Tách biệt:** UI rendering (`builder`) vs Side effects (`listener`)
4. **Dễ test:** Test từng State class riêng biệt
5. **Dễ debug:** Trace từng State thay đổi với BlocObserver

---

## 🔴 LEVEL 4: MULTI-BLOCPROVIDER (NÂNG CAO)
**Độ khó:** ⭐⭐⭐⭐ (Rất khó) - *Tổng hợp tất cả kiến thức*

**Mục tiêu:** Quản lý nhiều Cubit/Bloc cùng lúc (giống `MultiProvider` trong Bài 09).

### 🎭 Liên tưởng đời thường:

**Tưởng tượng:** Bạn có một **ngôi nhà** với nhiều hệ thống:

- 💡 **Hệ thống đèn** (ThemeCubit) - Quản lý sáng/tối
- 🔢 **Hệ thống đếm** (CounterCubit) - Quản lý số đếm  
- 🔐 **Hệ thống bảo mật** (LoginCubit) - Quản lý đăng nhập

**Vấn đề:** Làm sao quản lý tất cả?

**Giải pháp:** Dùng `MultiBlocProvider` - Giống như **tổng đài điều khiển** quản lý tất cả hệ thống!

### 📚 Xây dựng từ tất cả Level trước:

**Bạn đã học:**
- ✅ Level 1: Tạo 1 Cubit (CounterCubit)
- ✅ Level 2: Dùng Cubit toàn cục (ThemeCubit)
- ✅ Level 3: Tạo Cubit phức tạp (LoginCubit)

**Bây giờ bạn sẽ học:**
- ✅ **Kết hợp tất cả:** Dùng nhiều Cubit cùng lúc
- ✅ **Giống MultiProvider:** Nếu bạn đã biết MultiProvider (Bài 09), cái này rất dễ!

Trong ứng dụng thực tế, bạn thường cần nhiều Cubit/Bloc (Theme, Auth, Cart...). Thay vì bọc lồng nhau, dùng `MultiBlocProvider`:

### 📝 Hướng dẫn:

**Cách 1: MultiBlocProvider (Khuyến nghị)**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/theme_cubit.dart';
import 'cubits/counter_cubit.dart';
import 'blocs/login/login_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        // Thêm bao nhiêu cũng được...
      ],
      child: const MyApp(),
    ),
  );
}
```

**Cách 2: BlocProvider.value (Khi cần truyền Cubit từ ngoài vào)**
```dart
// Khi bạn đã có Cubit instance và muốn dùng lại
final themeCubit = ThemeCubit();

MultiBlocProvider(
  providers: [
    BlocProvider.value(value: themeCubit), // Dùng lại instance
    BlocProvider(create: (_) => CounterCubit()), // Tạo mới
  ],
  child: MyApp(),
)
```

**Sử dụng:**
Bất kỳ widget nào trong `MyApp` đều có thể truy cập:
- `context.read<ThemeCubit>()`
- `context.read<CounterCubit>()`
- `context.read<LoginCubit>()`

### 🔄 So sánh với Provider:

| Provider | BLoC |
|----------|------|
| `MultiProvider` | `MultiBlocProvider` |
| `ChangeNotifierProvider` | `BlocProvider` |
| `Provider.value` | `BlocProvider.value` |

**Lưu ý:** Bạn có thể kết hợp cả Provider và BLoC:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()), // UI State
    ChangeNotifierProvider(create: (_) => CartProvider()),   // UI State
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthBloc()), // Business Logic
      BlocProvider(create: (_) => PaymentBloc()), // Business Logic
    ],
    child: MyApp(),
  ),
)
```

---

## 🏆 TỔNG KẾT

Bạn đã chạm tay vào **BLoC** - kiến trúc tiêu chuẩn công nghiệp.

### ✅ Những gì bạn đã học:
- **Cubit** là khởi đầu hoàn hảo: `Function` -> `State` (tương tự Provider nhưng mạnh hơn)
- **BlocConsumer** là công cụ đắc lực để vừa vẽ vừa xử lý sự kiện
- **MultiBlocProvider** để quản lý nhiều Cubit/Bloc cùng lúc

### 🔄 Provider vs BLoC - Khi nào dùng gì?

| Tình huống | Nên dùng |
|------------|----------|
| Theme switching | Provider (đơn giản) |
| Shopping cart đơn giản | Provider hoặc Cubit |
| Login/Authentication | BLoC (phức tạp, nhiều State) |
| Payment flow | BLoC (business logic phức tạp) |
| App nhỏ/trung bình | Provider |
| App lớn, team lớn | BLoC (dễ test, dễ debug) |
| UI State (Theme, Settings) | Provider |
| Business Logic (Auth, Payment) | BLoC |

### 💡 Lời khuyên học tập (Dựa trên nguyên tắc từ dễ đến khó):

**🎯 Lộ trình học:**
1. **Bắt đầu với Provider** (Bài 09) - Đơn giản, dễ hiểu
2. **Nâng cấp lên BLoC** (Bài này) - Phức tạp hơn, nhưng mạnh hơn
3. **Kết hợp cả 2** - Provider cho UI state, BLoC cho Business logic

**📚 Nguyên tắc học:**
- ✅ **Làm nhiều lần:** Mỗi Level làm ít nhất 2-3 lần để quen tay
- ✅ **Không nhảy cóc:** Phải hiểu Level 1 → Mới học Level 2
- ✅ **So sánh với Provider:** Luôn nhớ so sánh với kiến thức cũ
- ✅ **Thực hành nhiều:** Code nhiều sẽ nhớ lâu hơn đọc nhiều

**🏗️ Khi làm dự án thực tế:**
- BLoC giúp code cực kỳ ngăn nắp, dễ mở rộng
- Đặc biệt là **Debug siêu sướng** (vì biết chính xác dòng logic nào bắn ra state nào)
- Giống như có **hệ thống GPS** theo dõi mọi thay đổi trong app!

### 📚 Tiếp theo:
👉 **Bài tiếp theo:** [10b - Dự án Tổng hợp: Bloc + Provider + .NET API](10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) - Áp dụng BLoC vào dự án thực tế!

---

## 🎓 TÓM TẮT HỌC TẬP: NHỮNG GÌ BẠN ĐÃ HỌC

### 📖 Nguyên tắc học tập đã áp dụng:

**1. Đi từ dễ đến khó:**
```
Level 1: Counter (⭐) → Đơn giản nhất
    ↓
Level 2: Theme (⭐⭐) → Nâng cấp từ Level 1
    ↓
Level 3: Login (⭐⭐⭐) → Phức tạp, nhiều State
    ↓
Level 4: Multi-BlocProvider (⭐⭐⭐⭐) → Tổng hợp tất cả
```

**2. Liên tưởng cuộc sống:**
- Counter = Đồng hồ đếm số
- Theme = Công tắc đèn
- Login = Gọi món ăn (Chờ → Thành công/Thất bại)
- Multi-BlocProvider = Tổng đài điều khiển

**3. Từ đã biết đến chưa biết:**
- ✅ Bắt đầu từ Provider (đã biết)
- ✅ So sánh Provider vs BLoC
- ✅ Xây dựng BLoC dựa trên kiến thức Provider

**4. Xây dựng và nâng cấp:**
- Mỗi Level xây dựng trên Level trước
- Level 2 dùng kiến thức Level 1
- Level 3 dùng kiến thức Level 1 + 2
- Level 4 tổng hợp tất cả

### 🎯 Checklist kiến thức đã học:

**Level 1 - Counter:**
- [ ] Hiểu `Cubit<int>` là gì
- [ ] Biết dùng `emit()` thay vì `notifyListeners()`
- [ ] Biết dùng `BlocBuilder` thay vì `Consumer`
- [ ] So sánh được Provider vs BLoC cho Counter

**Level 2 - Theme:**
- [ ] Hiểu `Cubit<ThemeData>` (State phức tạp hơn)
- [ ] Biết dùng BLoC toàn cục trong `main.dart`
- [ ] So sánh được Provider vs BLoC cho Theme

**Level 3 - Login:**
- [ ] Hiểu State classes (`LoginInitial`, `LoginLoading`, ...)
- [ ] Biết dùng `BlocConsumer` (builder + listener)
- [ ] Hiểu tại sao BLoC tốt hơn Provider cho logic phức tạp

**Level 4 - Multi-BlocProvider:**
- [ ] Biết quản lý nhiều Cubit cùng lúc
- [ ] Hiểu `MultiBlocProvider` giống `MultiProvider`
- [ ] Biết kết hợp Provider và BLoC trong cùng 1 app

### 💡 Lời khuyên cuối cùng:

**Học theo nguyên tắc:**
1. ✅ **Làm nhiều lần** - Mỗi Level làm 2-3 lần
2. ✅ **Không nhảy cóc** - Phải hiểu Level trước mới học Level sau
3. ✅ **So sánh thường xuyên** - Luôn so sánh với Provider
4. ✅ **Dùng ví dụ đời thường** - Liên tưởng để nhớ lâu hơn

**Khi làm dự án:**
- Nhớ: Provider = Đơn giản, BLoC = Phức tạp nhưng mạnh mẽ
- Có thể dùng cả 2: Provider cho UI state, BLoC cho Business logic

**Chúc bạn học tốt!** 🎉

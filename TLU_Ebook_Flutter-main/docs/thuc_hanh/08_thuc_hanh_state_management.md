# 🟦 THỰC HÀNH CHI TIẾT: STATE MANAGEMENT CĂN BẢN (BÀI 08)

Tài liệu này giúp bạn hiểu sâu về "Linh hồn của Flutter" - đó chính là **State** (Trạng thái).
Nếu bạn thấy UI không chịu thay đổi dù bạn đã code đúng logic -> 99% lỗi do State.

> **⚠️ BẮT BUỘC:** Hãy gõ từng dòng code để hiểu cơ chế hoạt động. Đừng copy-paste!
> **💡 TƯ DUY:** State thay đổi -> Báo `setState` -> Flutter vẽ lại màn hình.

---

## 🎯 MỤC TIÊU SẢN PHẨM
1.  **Level 1 (Dễ): The Counter** - *Bài tập kinh điển để hiểu `setState`.*
2.  **Level 2 (Trung bình): Traffic Light** - *Thay đổi màu sắc UI dựa trên State.*
3.  **Level 3 (Khó): Todo List** - *Thêm/Xóa phần tử trong danh sách (List state).*
4.  **Level 4 (Rất khó): Parent & Child** - *Kỹ thuật Lifting State Up (Truyền state từ con lên cha).*

---

## 🛠️ CHUẨN BỊ
1.  Tạo dự án mới:
    ```bash
    flutter create thuc_hanh_state
    cd thuc_hanh_state
    ```
2.  Setup `main.dart` với khung sườn trống:

```dart
import 'package:flutter/material.dart';

// Import các file bài tập
// import 'bai1_counter.dart';
// import 'bai2_traffic_light.dart';
// import 'bai3_todo.dart';
// import 'bai4_parent_child.dart';

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

## 🟢 LEVEL 1: THE COUNTER (BÀI TẬP VỠ LÒNG)
**Mục tiêu:** Hiểu rõ tại sao cần `StatefulWidget` và `setState`.
**Tư duy:** Biến `count` thay đổi thì Text hiển thị số đó cũng phải thay đổi theo.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai1_counter.dart`.

**Bước 2:** Code logic Counter.

```dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // 1. Khai báo State (Dữ liệu có thể thay đổi)
  int _count = 0;

  // 2. Hàm thay đổi State
  void _increment() {
    // ⚠️ QUAN TRỌNG: Phải bọc trong setState()
    setState(() {
      _count++;
    });
    // Nếu quên setState, biến _count vẫn tăng, nhưng UI vẫn hiện số cũ!
  }

  void _decrement() {
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("UI đang được vẽ lại..."); // Tag log để kiểm chứng
    return Scaffold(
      appBar: AppBar(title: const Text("Counter App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bấm nút để thay đổi số:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            
            // 3. UI phụ thuộc vào State
            Text(
              "$_count", 
              style: TextStyle(
                fontSize: 80, 
                fontWeight: FontWeight.bold,
                // State cũng có thể quyết định màu sắc
                color: _count >= 0 ? Colors.blue : Colors.red,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _decrement,
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `setState(() { ... })`: Đây là "cái cò súng". Khi bóp cò, Flutter sẽ bắn tín hiệu "Vẽ lại đi!". Nếu bạn thay đổi `_count` mà không bóp cò, viên đạn vẫn ở trong nòng (biến đổi nhưng UI không đổi).
> - `build()`: Hàm này chạy lại MỖI LẦN `setState` được gọi. Đừng lo lắng về hiệu năng, Flutter rất thông minh, nó chỉ vẽ lại những gì cần thiết.

---

## 🟡 LEVEL 2: TRAFFIC LIGHT (ĐÈN GIAO THÔNG)
**Mục tiêu:** Quản lý State phức tạp hơn (Chuỗi loop: Đỏ -> Vàng -> Xanh). Dùng State để điều khiển màu sắc và nội dung.
**Tư duy:** 1 nút bấm điều khiển cả màu đèn và thông báo bên dưới.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai2_traffic_light.dart`.

**Bước 2:** Xây dựng logic đèn giao thông.

```dart
import 'package:flutter/material.dart';

class TrafficLightScreen extends StatefulWidget {
  const TrafficLightScreen({super.key});

  @override
  State<TrafficLightScreen> createState() => _TrafficLightScreenState();
}

class _TrafficLightScreenState extends State<TrafficLightScreen> {
  // State: 0 = Đỏ, 1 = Vàng, 2 = Xanh
  int _lightState = 0; 

  String get _instructionText {
    switch (_lightState) {
      case 0: return "DỪNG LẠI!";
      case 1: return "CHUẨN BỊ...";
      case 2: return "ĐI THÔI!";
      default: return "";
    }
  }

  Color get _lightColor {
    switch (_lightState) {
      case 0: return Colors.red;
      case 1: return Colors.amber;
      case 2: return Colors.green;
      default: return Colors.grey;
    }
  }

  void _changeLight() {
    setState(() {
      // Logic vòng lặp: 0 -> 1 -> 2 -> 0
      _lightState = (_lightState + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đèn Giao Thông")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bóng đèn (Container tròn)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Hiệu ứng chuyển màu mượt
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _lightColor, // Màu thay đổi theo State
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: _lightColor.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
                ]
              ),
              child: Icon(
                _lightState == 0 ? Icons.pan_tool : (_lightState == 1 ? Icons.warning : Icons.directions_run),
                size: 60,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),
            
            Text(
              _instructionText,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _lightColor),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: _changeLight,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text("Chuyển đèn", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `get _instructionText`: Sử dụng Getter để tính toán giá trị dựa trên State. Giúp code trong `build` gọn gàng hơn.
> - `AnimatedContainer`: Widget tự động tạo hiệu ứng chuyển động khi thuộc tính (màu sắc) thay đổi. Rất ngầu mà không cần code animation phức tạp.

---

## 🟠 LEVEL 3: TODO LIST (DANH SÁCH ĐỘNG)
**Mục tiêu:** Thao tác với List (Thêm, Xóa).
**Tư duy:** State không chỉ là số hay chuỗi, nó có thể là một Danh sách (List). Khi thêm phần tử vào List -> gọi `setState` -> List hiển thị thêm dòng mới.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai3_todo.dart`.

**Bước 2:** Code Todo List.

```dart
import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // 1. State là một danh sách String
  final List<String> _tasks = ["Làm bài tập Flutter", "Mua cà phê"];
  
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isEmpty) return; // Nếu rỗng thì không làm gì

    setState(() {
      // Thêm việc mới vào đầu danh sách
      _tasks.insert(0, _controller.text); 
    });
    
    _controller.clear(); // Xóa ô nhập sau khi thêm
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Việc Cần Làm (${_tasks.length})")),
      body: Column(
        children: [
          // Phần nhập liệu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Nhập công việc...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Phần danh sách
          Expanded(
            child: _tasks.isEmpty 
              ? const Center(child: Text("Hết việc rồi, chơi thôi! 🎉"))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(child: Text("${index + 1}")),
                        title: Text(_tasks[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(index),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `_tasks.insert(0, ...)`: Thêm vào vị trí 0 (đầu danh sách) để việc mới nhất luôn hiện trên cùng.
> - `_tasks.length` trong AppBar: Tự động cập nhật số lượng công việc khi thêm/xóa.
> - `ListView.builder`: Luôn dùng cái này khi làm việc với danh sách động (có thể thay đổi số lượng).

---

## 🔴 LEVEL 4: LIFTING STATE UP ( CHA QUẢN LÝ, CON HIỂN THỊ)
**Mục tiêu:** Hiểu kỹ thuật quan trọng nhất trong quản lý State căn bản.
**Vấn đề:** 
- Widget Cha chứa dữ liệu (Total Money).
- Widget Con A là nút bấm "Tiêu tiền".
- Widget Con B là Text hiển thị "Số dư".
- Làm sao Con A bấm -> Con B thay đổi? -> **Phải nhờ Cha quản lý**.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai4_parent_child.dart`.

**Bước 2:** Định nghĩa các Widget con (Nút bấm, Hiển thị) tách biệt.

```dart
import 'package:flutter/material.dart';

// ------------------------------------------------
// 1. WIDGET CON: Text hiển thị số dư
// Không có State, chỉ nhận dữ liệu từ cha để hiện
// ------------------------------------------------
class BalanceDisplay extends StatelessWidget {
  final int balance; // Nhận tiền từ cha
  
  const BalanceDisplay({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("Số dư hiện tại", style: TextStyle(fontSize: 16)),
          Text(
            "$balance \$", 
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 2. WIDGET CON: Nút bấm
// Không có State, khi bấm thì gọi hàm của cha
// ------------------------------------------------
class ActionButtons extends StatelessWidget {
  final VoidCallback onEarn;  // Hàm kiếm tiền (của cha)
  final VoidCallback onSpend; // Hàm tiêu tiền (của cha)

  const ActionButtons({super.key, required this.onEarn, required this.onSpend});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onEarn,
          icon: const Icon(Icons.attach_money),
          label: const Text("Kiếm thêm"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        ),
        ElevatedButton.icon(
          onPressed: onSpend,
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Mua sắm"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
        ),
      ],
    );
  }
}
```

**Bước 3:** WIDGET CHA quản lý tất cả (Lifting State Up).

```dart
// ------------------------------------------------
// 3. WIDGET CHA: Quản lý State và Logic
// ------------------------------------------------
class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // STATE NẰM Ở ĐÂY
  int _money = 1000; 

  void _earnMoney() {
    setState(() {
      _money += 100;
    });
  }

  void _spendMoney() {
    setState(() {
      _money -= 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản Lý Tài Chính (Lifting State)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Truyền State xuống cho con hiển thị
            BalanceDisplay(balance: _money),
            
            const SizedBox(height: 50),
            
            // Truyền Hàm xuống cho con bấm
            ActionButtons(
              onEarn: _earnMoney,
              onSpend: _spendMoney,
            ),
          ],
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - **Lifting State Up (Đưa State lên trên):** Vì Con A và Con B là anh em, không nói chuyện trực tiếp được. Nên ta đưa State (`_money`) lên cho Cha giữ.
> - Khi Con A bấm nút -> Gọi hàm `onSpend` -> Hàm này thực chất là `_spendMoney` của Cha.
> - `_spendMoney` gọi `setState` -> Widget Cha vẽ lại.
> - Khi Cha vẽ lại -> Nó tạo lại Con A và Con B với dữ liệu mới (`balance` mới).
> - Kết quả: Con B hiển thị số tiền mới.

---

## 🏆 TỔNG KẾT
Bạn đã nắm vững 4 bài tập quan trọng nhất để hiểu về State:
1.  **Counter:** Cơ chế `setState` cơ bản.
2.  **Traffic Light:** State quyết định logic hiển thị (Màu sắc, Text, Icon).
3.  **Todo List:** State dạng danh sách (List).
4.  **Parent-Child:** State được chia sẻ giữa các Widget.

Sau này khi học `Provider` hay `BLoC`, bạn sẽ thấy chúng chỉ là cách xịn xò hơn để làm việc "Lifting State Up" mà thôi!
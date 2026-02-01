# 🟦 THỰC HÀNH CHI TIẾT: WIDGET & LAYOUT (BÀI 04 - 05)

Tài liệu này được thiết kế dành riêng cho các bạn muốn **"học một hiểu mười"**, cầm tay chỉ việc từ những dòng code đầu tiên cho đến khi ra sản phẩm hoàn chỉnh. Chúng ta sẽ không chỉ code, mà còn học **tư duy** tại sao lại code như vậy.

> **⚠️ BẮT BUỘC:** Không được copy-paste toàn bộ code. Hãy gõ từng dòng để hiểu cấu trúc (trừ các data mẫu dài dòng).

---

## 🎯 MỤC TIÊU SẢN PHẨM
Chúng ta sẽ xây dựng 4 màn hình nhỏ, đi từ dễ đến khó:
1.  **Level 1 (Dễ): Personal Profile** - *Làm quen StatelessWidget, Text, Image, Container.*
2.  **Level 2 (Trung bình): Smart Counter** - *Làm quen StatefulWidget, Button, Xử lý sự kiện.*
3.  **Level 3 (Khó): Travel Album** - *Làm quen GridView, Stack, Positioned.*
4.  **Level 4 (Rất khó): Music Player UI** - *Làm quen ListView, Expanded, Flexible, Row/Column phức tạp.*

---

## 🛠️ CHUẨN BỊ
1.  Tạo một dự án Flutter mới (hoặc dùng dự án nháp):
    ```bash
    flutter create thuc_hanh_ui
    cd thuc_hanh_ui
    ```
2.  Mở thư mục `lib`, xóa hết code trong `main.dart` và thay bằng code khung sườn sau:

```dart
import 'package:flutter/material.dart';

// Import các màn hình bài tập (chúng ta sẽ tạo sau)
// import 'bai1_profile.dart'; // Bỏ comment khi làm xong bài 1
// import 'bai2_counter.dart'; // Bỏ comment khi làm xong bài 2
// import 'bai3_album.dart';   // Bỏ comment khi làm xong bài 3
// import 'bai4_music.dart';   // Bỏ comment khi làm xong bài 4

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Thay đổi widget 'home' để hiển thị bài tập bạn đang làm
      home: Scaffold(
        body: Center(child: Text("HÃY KHAI BÁO MÀN HÌNH Ở ĐÂY")),
      ),
    );
  }
}
```

---

## 🟢 LEVEL 1: PERSONAL PROFILE (THẺ THÔNG TIN)
**Mục tiêu:** Tạo một màn hình giới thiệu bản thân tĩnh.
**Tư duy:** Mọi thứ trong Flutter là cái hộp (`Container`). Chúng ta xếp các hộp dọc (`Column`) hoặc ngang (`Row`).

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai1_profile.dart`.

**Bước 2:** Nhập code sau và đọc kỹ phần chú thích:

```dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // 1. Màu nền tổng thể xám nhẹ
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center( // 2. Center để thẻ card luôn ở giữa màn hình
        child: Container(
          width: 300, // Chiều rộng cố định của thẻ
          height: 450, // Tăng chiều cao lên chút để thoải mái
          decoration: BoxDecoration( // 3. Trang trí cho cái hộp (Thẻ)
            color: Colors.white, // Nền trắng nổi bật trên nền xám
            borderRadius: BorderRadius.circular(20), // Bo tròn mềm mại
            boxShadow: const [ // Đổ bóng nhẹ tạo hiệu ứng nổi 3D
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column( // 4. Dùng Column vì các thông tin xếp dọc từ trên xuống
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa tất cả theo chiều dọc
            children: [
              // --- AVATAR ---
              const CircleAvatar(
                radius: 60, // Kích thước avatar
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
              const SizedBox(height: 20), // Khoảng cách giữa các phần tử
              
              // --- TÊN ---
              const Text(
                "Nguyễn Văn A",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Chữ đậm
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              
              // --- NGHỀ NGHIỆP ---
              const Text(
                "Flutter Developer",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic, // Chữ nghiêng nghệ thuật
                ),
              ),
              const SizedBox(height: 30),
              
              // --- THÔNG TIN LIÊN HỆ ---
              // Dùng Row để xếp Icon và Text nằm ngang nhau
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa dòng
                children: const [
                   Icon(Icons.email, color: Colors.blue),
                   SizedBox(width: 8), // Khoảng hở giữa icon và chữ
                   Text("email@example.com"),
                ],
              ),
              const SizedBox(height: 10),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                   Icon(Icons.phone, color: Colors.green), // Icon màu xanh lá
                   SizedBox(width: 8),
                   Text("0999.888.777"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `Scaffold`: Bộ giàn giáo chuẩn (có AppBar, Body).
> - `Container + BoxDecoration`: Cách tiêu chuẩn để tạo một khối có màu nền, bo góc và đổ bóng. Nếu chỉ cần kích thước mà không cần màu sắc, dùng `SizedBox` sẽ nhẹ hơn.
> - `Column`: Xếp dọc. `Row`: Xếp ngang.
> - `SizedBox(height: 20)`: Một widget tàng hình, công dụng duy nhất là tạo khoảng trống.

---

## 🟡 LEVEL 2: SMART COUNTER (BỘ ĐẾM THÔNG MINH)
**Mục tiêu:** Hiểu về `State` (Trạng thái).
**Vấn đề:** Ở Level 1, UI không thể thay đổi. Ở Level 2, số đếm thay đổi khi bấm nút -> Cần `StatefulWidget`.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai2_counter.dart`.

**Bước 2:** Code logic. Lưu ý kỹ hàm `setState`.

```dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // 1. Biến trạng thái (State)
  int count = 0;

  // 2. Các hàm xử lý logic
  void tang() {
    setState(() { // <--- Quan trọng: Báo cho Flutter biết dữ liệu đã đổi, hãy vẽ lại UI!
      count++;
    });
  }

  void giam() {
    setState(() {
      count--;
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Text("Giá trị hiện tại:", style: TextStyle(fontSize: 18)),
             const SizedBox(height: 10),
             
             // 3. UI thay đổi dựa theo biến count
             Text(
               "$count",
               style: TextStyle(
                 fontSize: 80,
                 fontWeight: FontWeight.bold,
                 // Logic: Nếu >= 0 màu xanh, ngược lại màu đỏ
                 color: count >= 0 ? Colors.green : Colors.red,
               ),
             ),
             
             // 4. Hiển thị thông báo khi đạt mốc
             if (count >= 10) // Dùng if ngay trong array của Column
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("🏆 Đạt chỉ tiêu!", style: TextStyle(color: Colors.orange, fontSize: 20)),
                ),

             const SizedBox(height: 30),
             
             // 5. Hàng nút bấm
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 _buildButton(icon: Icons.remove, color: Colors.red, func: giam),
                 const SizedBox(width: 20),
                 _buildButton(icon: Icons.refresh, color: Colors.grey, func: reset),
                 const SizedBox(width: 20),
                 _buildButton(icon: Icons.add, color: Colors.green, func: tang),
               ],
             )
          ],
        ),
      ),
    );
  }

  // 6. Hàm tiện ích để tạo nút cho nhanh (Tránh lặp code)
  Widget _buildButton({required IconData icon, required Color color, required VoidCallback func}) {
    return ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Nút hình tròn
        padding: const EdgeInsets.all(20),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Icon(icon),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `setState(() { ... })`: Câu thần chú. Nếu thay đổi biến `count` mà quên gọi hàm này, giao diện sẽ **đứng im** dù biến đã đổi.
> - `if (count >= 10) ...`: Tính năng "Collection if" của Dart, cho phép ẩn hiện widget theo điều kiện rất gọn.
> - `_buildButton(...)`: Kỹ thuật tách Widget con để code chính gọn gàng hơn.

---

## 🟠 LEVEL 3: TRAVEL ALBUM (LAYOUT GRID & STACK)
**Mục tiêu:** Ghép nhiều widget chồng lên nhau.
**Tư duy:** `Stack` giống như Photoshop layers. Cái nào viết sau thì đè lên cái trước.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai3_album.dart`.

**Bước 2:** Code `TravelAlbumScreen`.

```dart
import 'package:flutter/material.dart';

class TravelAlbumScreen extends StatelessWidget {
  const TravelAlbumScreen({super.key});

  final List<String> images = const [
    "https://picsum.photos/id/1011/300/300",
    "https://picsum.photos/id/1015/300/300",
    "https://picsum.photos/id/1016/300/300",
    "https://picsum.photos/id/1018/300/300",
    "https://picsum.photos/id/1019/300/300",
    "https://picsum.photos/id/1020/300/300",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Travel Album")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Chia làm 2 cột
            crossAxisSpacing: 10, // Khe hở dọc
            mainAxisSpacing: 10, // Khe hở ngang
            childAspectRatio: 1, // Tỷ lệ 1:1 (Hình vuông)
          ),
          itemBuilder: (context, index) {
            return _buildItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return ClipRRect( // ClipRRect giúp cắt bo tròn các góc của ảnh
      borderRadius: BorderRadius.circular(15),
      child: Stack( // <-- Stack xếp chồng các lớp
        fit: StackFit.expand, // Bắt con cái bung lụa hết cỡ
        children: [
          // Lớp 1: Ảnh nền (Dưới cùng)
          Image.network(
            images[index],
            fit: BoxFit.cover, // Cắt ảnh để lấp đầy khung
          ),
          
          // Lớp 2: Gradient mờ (Để chữ dễ đọc hơn)
          Positioned(
            bottom: 0, 
            left: 0, 
            right: 0,
            child: Container(
              height: 60, // Chỉ cao 60px ở đáy
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          
          // Lớp 3: Chữ tên địa điểm (Đè lên Gradient)
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              "Địa điểm ${index + 1}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          // Lớp 4: Icon trái tim (Góc trên phải)
          Positioned(
            top: 5,
            right: 5,
             child: Container( // Bọc icon trong Container để làm nền mờ
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `GridView.builder`: Dùng để vẽ lưới. `SliverGridDelegateWith...` là cái tên dài ngoằng nhưng ý nghĩa đơn giản: "Tôi muốn lưới có số cột cố định".
> - `Stack`: Là chìa khóa của bài này.
> - `Positioned`: Chỉ dùng được trong Stack. Nó định vị tuyệt đối (VD: cách đáy 0, cách trái 0).

---

## 🔴 LEVEL 4: MUSIC PLAYER UI (CHIA BỐ CỤC)
**Mục tiêu:** Chia màn hình thành 3 phần với kích thước linh hoạt.
**Tư duy:** Không gian màn hình là hữu hạn. `Expanded` giúp chiếm lấy phần thừa.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai4_music.dart`.

**Bước 2:** Nhập code. Hãy chú ý `Expanded`.

```dart
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Tránh bị tai thỏ che mất nội dung
        child: Column(
          children: [
            // ----------------------------------------
            // PHẦN 1: HEADER (Ảnh Album) - Chiều cao cố định
            // ----------------------------------------
            Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              color: Colors.deepPurple[900], 
              child: Center(
                child: Container(
                  width: 180, height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage("https://picsum.photos/300"),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black45)],
                  ),
                ),
              ),
            ),

            // ----------------------------------------
            // PHẦN 2: DANH SÁCH BÀI HÁT (List) - Chiếm hết phần còn lại
            // ----------------------------------------
            Expanded( // <--- KEYWORD: Nếu không có Expanded, ListView sẽ bị lỗi vì độ cao vô tận
              child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemCount: 20,
                separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 70), // Đường kẻ mờ
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: Text("${index + 1}", 
                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                    title: Text("Song Title ${index + 1}", 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Artist Name"),
                    trailing: const Icon(Icons.more_horiz),
                  );
                },
              ),
            ),

            // ----------------------------------------
            // PHẦN 3: MINI PLAYER (Thanh điều khiển) - Chiều cao cố định ở đáy
            // ----------------------------------------
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(top: BorderSide(color: Colors.black12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Ảnh nhỏ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network("https://picsum.photos/100", width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 15),
                  
                  // Thông tin bài hát (Dùng Expanded để text tự co giãn nếu tên bài quá dài)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Current Song Playing", maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Famous Artist", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  
                  // Nút Play
                  IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous, size: 30)),
                  Container(
                    decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.pause, color: Colors.white)),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next, size: 30)),
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

> **🧠 Giải thích code:**
> - `SafeArea`: Đảm bảo UI không bị chui vào vùng "tai thỏ" hoặc thanh điều hướng dưới đáy iPhone X+.
> - `Expanded` (bao quanh ListView): Đây là lỗi kinh điển của người mới. `ListView` mặc định muốn dài vô tận. `Column` cũng cho phép con dài vô tận. Kết quả là lỗi `Vertical viewport was given unbounded height`. `Expanded` fix lỗi này bằng cách nói: "ListView à, mày chỉ được cao bằng phần không gian còn dư thôi nhé".

---

## 🏆 KẾT THÚC
Bạn đã hoàn thành 4 bài tập cốt lõi. Đây không chỉ là code, đây là **nền tảng** của mọi app Flutter bạn sẽ làm sau này.

- **Profile:** Biết dựng layout tĩnh.
- **Counter:** Biết xử lý state động.
- **Album:** Biết xếp chồng (Stack) và lưới (Grid).
- **Music Player:** Biết chia bố cục (Expanded) và danh sách (List).

Hãy nghỉ ngơi 5 phút trước khi sang bài tiếp theo! ☕
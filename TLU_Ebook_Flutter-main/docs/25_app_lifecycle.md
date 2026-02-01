# 🟦 CHƯƠNG 25
# **APP LIFECYCLE**
*(Resume – Pause – Inactive – Detached)*

Bạn có bao giờ thắc mắc:
- Làm sao để **tạm dừng video** khi người dùng thoát ra màn hình chính?
- Làm sao để **cập nhật dữ liệu** khi người dùng mở lại app?
- Làm sao để **biết app đang chạy ngầm**?

Đó chính là lúc bạn cần xử lý **App Lifecycle**.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Hiểu các trạng thái sống của App: `resumed`, `inactive`, `paused`, `detached`.
- Sử dụng `WidgetsBindingObserver` để lắng nghe thay đổi trạng thái.
- Áp dụng vào thực tế: Dừng/phát nhạc tự động, cập nhật online status.

---

# 1. **Các trạng thái (State) của App**

App Flutter có 4 trạng thái chính (theo `AppLifecycleState`):

1. **`resumed`**: App đang hiển thị và **người dùng có thể tương tác**. (Trạng thái bình thường).
2. **`inactive`**: App đang hiển thị nhưng **mất tiêu điểm** (ví dụ: có cuộc gọi đến đè lên, hoặc đang vuốt thoát app trên iOS).
3. **`paused`**: App **đang chạy ngầm** (nhấn Home, chuyển tab). Người dùng không thấy app, UI không cập nhật.
4. **`detached`**: App vẫn còn trong bộ nhớ nhưng chưa được (hoặc đã bị) ngắt kết nối với Flutter engine. Thường là lúc app đang khởi động hoặc **sắp bị kill hoàn toàn**.

---

# 2. **Cách lắng nghe App Lifecycle**

Để lắng nghe, bạn cần dùng `WidgetsBindingObserver`.

**Công thức chung:**
1. Thêm `with WidgetsBindingObserver` vào State class.
2. Đăng ký trong `initState`: `WidgetsBinding.instance.addObserver(this)`.
3. Hủy đăng ký trong `dispose`: `WidgetsBinding.instance.removeObserver(this)`.
4. Override hàm `didChangeAppLifecycleState`.

### Code mẫu đầy đủ:

```dart
class MyLifecyclePage extends StatefulWidget {
  @override
  _MyLifecyclePageState createState() => _MyLifecyclePageState();
}

// BƯỚC 1: Thêm Mixin
class _MyLifecyclePageState extends State<MyLifecyclePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // BƯỚC 2: Đăng ký lắng nghe
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // BƯỚC 3: Hủy đăng ký (Rất quan trọng để tránh leak memory)
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // BƯỚC 4: Xử lý thay đổi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        print("🟢 App đã quay lại (Resumed)");
        // Ví dụ: Tiếp tục phát nhạc, load lại data
        break;
      case AppLifecycleState.inactive:
        print("🟡 App mất tiêu điểm (Inactive)");
        break;
      case AppLifecycleState.paused:
        print("🔴 App chạy ngầm (Paused)");
        // Ví dụ: Dừng nhạc, lưu game
        break;
      case AppLifecycleState.detached:
        print("⚫ App sắp đóng (Detached)");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Lifecycle Demo")),
      body: Center(child: Text("Thử nhấn Home rồi quay lại!")),
    );
  }
}
```

---

# 3. **Ví dụ thực tế: Ứng dụng phát nhạc**

Bạn muốn:
- Nhạc **tự dừng** khi người dùng ẩn app.
- Nhạc **tự phát** khi người dùng mở lại app.

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused) {
    musicPlayer.pause(); // Dừng nhạc khi ẩn app
  } else if (state == AppLifecycleState.resumed) {
    musicPlayer.play(); // Chơi lại khi mở app
  }
}
```

---

# 🧠 Tổng kết

- Sử dụng **`WidgetsBindingObserver`** để theo dõi trạng thái app.
- Luôn nhớ **removeObserver** trong `dispose`.
- Xử lý các logic quan trọng (lưu data, dừng timers/animation) trong trạng thái `paused`.

# 🟦 CHƯƠNG 24
# **SLIVERS & CUSTOM SCROLL VIEW**
*(SliverAppBar – SliverList – SliverGrid – Sticky Headers)*

Nếu bạn muốn tạo những hiệu ứng cuộn "xịn xò" như:
- Ảnh bìa co giãn khi cuộn (Parallax / Collapse)
- Thanh tiêu đề ẩn hiện (Floating AppBar)
- Danh sách kết hợp lưới chung một màn hình

Thì `ListView` hay `GridView` thông thường là **không đủ**. Bạn cần dùng **Slivers**.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Hiểu bản chất **Sliver** là gì.
- Dùng `CustomScrollView` để phối hợp nhiều kiểu cuộn.
- Tạo `SliverAppBar` co giãn đẹp mắt.
- Kết hợp List và Grid trong cùng một danh sách cuộn.
- Dùng `SliverToBoxAdapter` để chèn widget thường vào Slivers.

---

# 1. **Sliver là gì? Tại sao cần nó?**

### Vấn đề của ListView/GridView truyền thống:
Bạn không thể đặt một `ListView` nối tiếp một `GridView` trong cùng một `Column` mà mong chúng cuộn chung mượt mà (chúng sẽ cuộn riêng lẻ hoặc gây lỗi).

### Giải pháp: Slivers
- **Sliver** là một lát cắt (slice) của vùng có thể cuộn.
- Tất cả Slivers phải được đặt trong `CustomScrollView`.
- Chúng hoạt động phối hợp với nhau để tạo ra **một trải nghiệm cuộn duy nhất**.

---

# 2. **CustomScrollView & SliverAppBar**

Đây là combo kinh điển nhất.

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      // 1. App Bar co giãn
      SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true, // Giữ lại AppBar khi cuộn
        flexibleSpace: FlexibleSpaceBar(
          title: Text("Sliver App Bar"),
          background: Image.network(
            "https://picsum.photos/800/400",
            fit: BoxFit.cover,
          ),
        ),
      ),
      
      // 2. Danh sách bên dưới
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(title: Text("Item $index")),
          childCount: 20,
        ),
      ),
    ],
  ),
)
```

### Các thuộc tính quan trọng của SliverAppBar:
- **`pinned: true`**: AppBar sẽ ghim lại ở trên cùng khi cuộn xuống (giống Sticky header).
- **`floating: true`**: AppBar hiện ra ngay khi vuốt nhẹ lên, không cần cuộn lên đầu.
- **`snap: true`**: (Đi kèm floating) AppBar hiện ra *toàn bộ* ngay lập tức khi vuốt nhẹ.
- **`expandedHeight`**: Chiều cao tối đa khi mở rộng.

---

# 3. **Các Widget Sliver thông dụng**

Trong `CustomScrollView`, bạn **không thể** dùng widget thường (`Container`, `Text`...). Bạn phải dùng widget dòng **Sliver**.

### 3.1. SliverList (Thay thế ListView)

```dart
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      return Container(
        height: 50,
        color: index.isEven ? Colors.blue[100] : Colors.white,
        child: Center(child: Text("Item $index")),
      );
    },
    childCount: 50,
  ),
)
```

### 3.2. SliverGrid (Thay thế GridView)

```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 1.0,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      return Container(color: Colors.green, child: Center(child: Text("$index")));
    },
    childCount: 12,
  ),
)
```

### 3.3. SliverToBoxAdapter (Cầu nối quan trọng)
Dùng khi bạn muốn chèn **một widget thường** (như Container, Text, Button) vào danh sách Slivers.

```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text("Đây là tiêu đề section", style: TextStyle(fontSize: 24)),
  ),
),
```

---

# 4. **Ví dụ tổng hợp: Profile Screen**

Một màn hình Profile thường có:
1. Ảnh bìa + Avatar (SliverAppBar)
2. Thống kê (SliverToBoxAdapter)
3. Grid ảnh đã đăng (SliverGrid)
4. List bài viết (SliverList)

```dart
CustomScrollView(
  slivers: [
    // 1. Header ảnh bìa
    SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Profile"),
        background: Image.network("https://picsum.photos/id/1/800/600", fit: BoxFit.cover),
      ),
    ),

    // 2. Info user (Widget thường -> dùng Adapter)
    SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 10),
            Text("Nguyễn Văn A", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text("Flutter Developer"),
          ],
        ),
      ),
    ),

    // 3. Tiêu đề Gallery
    SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(16), child: Text("Gallery"))),

    // 4. Lưới ảnh
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(color: Colors.primaries[index % 18]),
        childCount: 9,
      ),
    ),

    // 5. Tiêu đề Posts
    SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(16), child: Text("Recent Posts"))),

    // 6. Danh sách bài viết
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          leading: Icon(Icons.article),
          title: Text("Bài viết số $index"),
          subtitle: Text("Nội dung tóm tắt..."),
        ),
        childCount: 10,
      ),
    ),
  ],
)
```

---

# 🧠 Tổng kết

- Dùng **`CustomScrollView`** khi muốn kết hợp nhiều kiểu scroll.
- Các con của nó **bắt buộc** phải là **Slivers**.
- Muốn nhét widget thường vào? Dùng **`SliverToBoxAdapter`**.
- Muốn header co giãn? Dùng **`SliverAppBar`**.

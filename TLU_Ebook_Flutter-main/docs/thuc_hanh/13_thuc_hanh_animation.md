# 🟦 THỰC HÀNH CHƯƠNG 13: ANIMATION CƠ BẢN TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này hướng dẫn cách tạo animation đơn giản nhưng hiệu quả trong Flutter.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Sử dụng AnimatedContainer để animate kích thước, màu sắc
- ✅ Sử dụng AnimatedOpacity để fade in/out
- ✅ Sử dụng AnimatedAlign để di chuyển widget
- ✅ Hiểu về Curves và Duration
- ✅ Tạo animation với AnimationController và Tween

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt
- [ ] Hiểu về StatefulWidget và setState
- [ ] Kiến thức cơ bản về Dart

---

## BÀI TẬP 1: ANIMATEDCONTAINER CƠ BẢN

### Mục đích
Tạo animation đơn giản với AnimatedContainer.

### Yêu cầu

1. **Tạo file:**
Tạo `lib/screens/animated_container_demo.dart`:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Demo',
      home: AnimatedContainerScreen(),
    );
  }
}

class AnimatedContainerScreen extends StatefulWidget {
  @override
  _AnimatedContainerScreenState createState() => _AnimatedContainerScreenState();
}

class _AnimatedContainerScreenState extends State<AnimatedContainerScreen> {
  bool isBig = false;
  Color boxColor = Colors.red;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedContainer Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: isBig ? 200 : 100,
              height: isBig ? 200 : 100,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(isBig ? 20 : 0),
              ),
              child: Center(
                child: Text(
                  'Tap me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isBig = !isBig;
                  boxColor = isBig ? Colors.blue : Colors.red;
                });
              },
              child: Text('Thay đổi kích thước'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Box thay đổi kích thước và màu mượt mà
- Hiểu cách dùng AnimatedContainer

---

## BÀI TẬP 2: ANIMATEDOPACITY

### Mục đích
Tạo hiệu ứng fade in/out.

### Yêu cầu

Tạo `lib/screens/animated_opacity_demo.dart`:
```dart
import 'package:flutter/material.dart';

class AnimatedOpacityScreen extends StatefulWidget {
  @override
  _AnimatedOpacityScreenState createState() => _AnimatedOpacityScreenState();
}

class _AnimatedOpacityScreenState extends State<AnimatedOpacityScreen> {
  bool isVisible = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedOpacity Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: isVisible ? 1.0 : 0.0,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Fade me',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Text(isVisible ? 'Ẩn' : 'Hiện'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Widget fade in/out mượt mà
- Hiểu cách dùng AnimatedOpacity

---

## BÀI TẬP 3: ANIMATEDALIGN

### Mục đích
Di chuyển widget mượt mà.

### Yêu cầu

Tạo `lib/screens/animated_align_demo.dart`:
```dart
import 'package:flutter/material.dart';

class AnimatedAlignScreen extends StatefulWidget {
  @override
  _AnimatedAlignScreenState createState() => _AnimatedAlignScreenState();
}

class _AnimatedAlignScreenState extends State<AnimatedAlignScreen> {
  bool isLeft = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedAlign Demo')),
      body: Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[200],
        child: AnimatedAlign(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLeft = !isLeft;
          });
        },
        child: Icon(Icons.swap_horiz),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Circle di chuyển từ trái sang phải mượt mà
- Hiểu cách dùng AnimatedAlign

---

## BÀI TẬP 4: TOGGLE SWITCH VỚI ANIMATION

### Mục đích
Tạo toggle switch đẹp với animation.

### Yêu cầu

Tạo `lib/widgets/animated_toggle_switch.dart`:
```dart
import 'package:flutter/material.dart';

class AnimatedToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  
  AnimatedToggleSwitch({
    required this.value,
    required this.onChanged,
  });
  
  @override
  _AnimatedToggleSwitchState createState() => _AnimatedToggleSwitchState();
}

class _AnimatedToggleSwitchState extends State<AnimatedToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: widget.value ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: widget.value 
              ? Alignment.centerRight 
              : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
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

Sử dụng:
```dart
AnimatedToggleSwitch(
  value: isOn,
  onChanged: (value) {
    setState(() {
      isOn = value;
    });
  },
)
```

### Kết quả mong đợi
- Toggle switch đẹp với animation mượt
- Circle di chuyển và màu thay đổi

---

## BÀI TẬP 5: ANIMATIONCONTROLLER VÀ TWEEN

### Mục đích
Tạo animation phức tạp hơn với AnimationController.

### Yêu cầu

Tạo `lib/screens/fade_animation_screen.dart`:
```dart
import 'package:flutter/material.dart';

class FadeAnimationScreen extends StatefulWidget {
  @override
  _FadeAnimationScreenState createState() => _FadeAnimationScreenState();
}

class _FadeAnimationScreenState extends State<FadeAnimationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
    
    controller.forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fade Animation')),
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Fade In',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.reset();
          controller.forward();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Widget fade in mượt mà khi mở màn hình
- Có thể restart animation

---

## BÀI TẬP 6: ROTATION ANIMATION

### Mục đích
Tạo loading indicator với rotation.

### Yêu cầu

Tạo `lib/widgets/rotating_loader.dart`:
```dart
import 'package:flutter/material.dart';

class RotatingLoader extends StatefulWidget {
  @override
  _RotatingLoaderState createState() => _RotatingLoaderState();
}

class _RotatingLoaderState extends State<RotatingLoader> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller,
      child: Icon(
        Icons.refresh,
        size: 40,
        color: Colors.blue,
      ),
    );
  }
}
```

### Kết quả mong đợi
- Icon quay liên tục
- Có thể dùng làm loading indicator

---

## BÀI TẬP 7: SCALE ANIMATION

### Mục đích
Tạo hiệu ứng phóng to/thu nhỏ khi nhấn.

### Yêu cầu

Tạo `lib/widgets/pressable_button.dart`:
```dart
import 'package:flutter/material.dart';

class PressableButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  
  PressableButton({
    required this.text,
    required this.onPressed,
  });
  
  @override
  _PressableButtonState createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isPressed ? Colors.blue[700] : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Button scale down khi nhấn
- Feedback tức thì cho user

---

## BÀI TẬP 8: TỔNG HỢP - ỨNG DỤNG VỚI ANIMATION

### Mục đích
Áp dụng tất cả kiến thức vào một ứng dụng thực tế.

### Yêu cầu

Xây dựng ứng dụng **Product Card với Animation**:
- Card có animation khi xuất hiện
- Scale effect khi nhấn
- Fade in khi load

Code mẫu trong `lib/screens/product_list_animated.dart`:
```dart
import 'package:flutter/material.dart';

class ProductListAnimatedScreen extends StatefulWidget {
  @override
  _ProductListAnimatedScreenState createState() => _ProductListAnimatedScreenState();
}

class _ProductListAnimatedScreenState extends State<ProductListAnimatedScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  List<Product> products = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      products = [
        Product(name: 'Laptop', price: 1000),
        Product(name: 'Phone', price: 500),
        Product(name: 'Tablet', price: 300),
      ];
      isLoading = false;
    });
    controller.forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: fadeAnimation,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return AnimatedProductCard(product: products[index]);
                },
              ),
            ),
    );
  }
}

class Product {
  final String name;
  final double price;
  
  Product({required this.name, required this.price});
}

class AnimatedProductCard extends StatefulWidget {
  final Product product;
  
  AnimatedProductCard({required this.product});
  
  @override
  _AnimatedProductCardState createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> {
  bool isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: isPressed ? 2 : 8,
          child: ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(widget.product.name),
            trailing: Text('\$${widget.product.price}'),
          ),
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Ứng dụng với nhiều animation
- UX mượt mà và chuyên nghiệp

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Sử dụng được AnimatedContainer
- [ ] Sử dụng được AnimatedOpacity
- [ ] Sử dụng được AnimatedAlign
- [ ] Hiểu về Curves và Duration
- [ ] Tạo được animation với AnimationController
- [ ] Xây dựng được ứng dụng với animation

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Animation.

👉 **Tiếp theo:** Bài 14 - Clean Architecture hoặc các bài nâng cao khác

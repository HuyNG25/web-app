# 📚 HƯỚNG DẪN SỬ DỤNG PROMPT TEMPLATE

## 🎯 MỤC ĐÍCH

Bộ prompt template này được tạo ra để giúp bạn **tự động hóa việc bổ sung và mở rộng nội dung** cho các tài liệu học tập (ebook, bài giảng, slide, v.v.) một cách nhất quán và chuyên nghiệp.

---

## 📁 CẤU TRÚC FILE

```
.
├── PROMPT_TEMPLATE.md    # Prompt chi tiết, có giải thích đầy đủ
├── PROMPT_SIMPLE.md      # Prompt ngắn gọn, dễ copy-paste
└── PROMPT_README.md      # File này - Hướng dẫn sử dụng
```

---

## 🚀 QUICK START

### Cách 1: Dùng Prompt Đơn Giản (Khuyến nghị)

1. Mở file `PROMPT_SIMPLE.md`
2. Copy toàn bộ prompt
3. Thay thế `[TÊN_FILE]` bằng tên file thực tế
4. Gửi cho AI (ChatGPT, Claude, Cursor, v.v.)

**Ví dụ:**
```
[... copy prompt từ PROMPT_SIMPLE.md ...]

Hãy bắt đầu với file: docs/09_provider_state.md
```

### Cách 2: Dùng Prompt Chi Tiết

1. Mở file `PROMPT_TEMPLATE.md`
2. Đọc và hiểu các phần
3. Tùy chỉnh theo nhu cầu
4. Copy và sử dụng

---

## 📋 QUY TRÌNH SỬ DỤNG

### Bước 1: Chuẩn bị

- ✅ Có sẵn các file chương/bài cần bổ sung
- ✅ Xác định file mẫu (file có nội dung tốt để làm chuẩn)
- ✅ Xác định phong cách mong muốn

### Bước 2: Sử dụng prompt lần đầu

```
[Copy prompt từ PROMPT_SIMPLE.md]

Hãy bắt đầu với file: docs/[tên_file_đầu_tiên].md
```

### Bước 3: Kiểm tra kết quả

- ✅ Đọc lại nội dung đã bổ sung
- ✅ Kiểm tra tính nhất quán với file gốc
- ✅ Kiểm tra code examples (nếu có)
- ✅ Điều chỉnh prompt nếu cần

### Bước 4: Tiếp tục các chương sau

```
Tiếp tục với [Tên chương/bài tiếp theo]
```

Ví dụ:
```
Tiếp tục với Bài 11
```

hoặc

```
Tiếp tục với chương 12
```

---

## 🎨 TÙY BIẾN THEO MÔN HỌC

### Môn Lập trình (Flutter, React, Python, v.v.)

**Thêm vào prompt:**
```
ĐẶC BIỆT:
- Tập trung vào code examples thực tế
- Thêm phần debugging tips
- Thêm phần performance optimization
- Ví dụ: Mini projects, real-world scenarios
```

### Môn Lý thuyết (Toán, Vật lý, v.v.)

**Thêm vào prompt:**
```
ĐẶC BIỆT:
- Tập trung vào định nghĩa, định lý rõ ràng
- Thêm phần chứng minh (nếu cần)
- Thêm phần ứng dụng thực tế
- Ví dụ: Bài toán minh họa, case studies
```

### Môn Ngoại ngữ

**Thêm vào prompt:**
```
ĐẶC BIỆT:
- Tập trung vào vocabulary, grammar points
- Thêm phần pronunciation tips
- Thêm phần practice exercises
- Ví dụ: Dialogues, reading passages
```

### Môn Kinh doanh/Kinh tế

**Thêm vào prompt:**
```
ĐẶC BIỆT:
- Tập trung vào case studies thực tế
- Thêm phần phân tích số liệu
- Thêm phần best practices từ doanh nghiệp
- Ví dụ: Case studies, real-world examples
```

---

## 💡 TIPS & TRICKS

### 1. Để AI hiểu rõ phong cách

**Cách tốt:**
```
[... prompt chuẩn ...]

THAM KHẢO PHONG CÁCH:
- File docs/08_state_management_can_ban.md có phong cách tốt
- Hãy tham khảo cấu trúc và tone của file đó
```

### 2. Yêu cầu cụ thể hơn

**Thay vì:**
```
Bổ sung nội dung
```

**Nên:**
```
Bổ sung:
- 5 ví dụ code đầy đủ
- 3 case studies thực tế
- 8 lỗi thường gặp với giải thích chi tiết
```

### 3. Xử lý file trống

**Nếu file trống:**
```
File docs/15_testing.md hiện đang trống.
Hãy tạo nội dung đầy đủ từ đầu, tham khảo cấu trúc của:
- docs/08_state_management_can_ban.md
- docs/09_provider_state.md
```

### 4. Điều chỉnh độ sâu nội dung

**Cho beginner:**
```
Đối tượng: Sinh viên năm nhất, chưa có kinh nghiệm
- Giải thích chi tiết từng bước
- Nhiều ví dụ đơn giản
- Tránh thuật ngữ phức tạp
```

**Cho advanced:**
```
Đối tượng: Sinh viên đã có kinh nghiệm
- Có thể bỏ qua phần cơ bản
- Tập trung vào best practices, advanced techniques
- Ví dụ phức tạp, thực tế
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

### ✅ NÊN LÀM

- ✅ Luôn đọc kết quả và kiểm tra trước khi chấp nhận
- ✅ Điều chỉnh prompt dựa trên kết quả thực tế
- ✅ Giữ lại prompt gốc để tham khảo
- ✅ Test với 1-2 chương trước khi áp dụng hàng loạt
- ✅ Review và chỉnh sửa nội dung sau khi AI tạo

### ❌ KHÔNG NÊN

- ❌ Chấp nhận kết quả mà không kiểm tra
- ❌ Dùng prompt cho môn học khác mà không điều chỉnh
- ❌ Bỏ qua bước review và chỉnh sửa
- ❌ Mong đợi kết quả hoàn hảo 100% (AI cần human review)

---

## 🔄 WORKFLOW ĐỀ XUẤT

```
1. Chuẩn bị
   ├── Xác định file cần bổ sung
   ├── Chọn file mẫu (nếu có)
   └── Điều chỉnh prompt theo môn học

2. Sử dụng prompt
   ├── Copy prompt từ PROMPT_SIMPLE.md
   ├── Thay thế [TÊN_FILE]
   └── Gửi cho AI

3. Review kết quả
   ├── Đọc nội dung đã bổ sung
   ├── Kiểm tra tính nhất quán
   ├── Kiểm tra code (nếu có)
   └── Chỉnh sửa nếu cần

4. Lặp lại
   ├── Tiếp tục với chương sau
   └── Điều chỉnh prompt nếu cần
```

---

## 📊 CHECKLIST

Trước khi sử dụng:
- [ ] Đã đọc và hiểu prompt
- [ ] Đã xác định file cần bổ sung
- [ ] Đã có file mẫu (nếu cần)
- [ ] Đã điều chỉnh prompt theo môn học

Sau khi nhận kết quả:
- [ ] Đã đọc toàn bộ nội dung
- [ ] Đã kiểm tra tính nhất quán
- [ ] Đã kiểm tra code examples
- [ ] Đã chỉnh sửa nếu cần
- [ ] Đã lưu lại prompt đã điều chỉnh

---

## 🆘 TROUBLESHOOTING

### Vấn đề: AI không hiểu phong cách

**Giải pháp:**
```
[... prompt ...]

THAM KHẢO:
- Đọc file docs/[file_mẫu].md để hiểu phong cách
- Giữ nguyên format, tone, cấu trúc như file đó
```

### Vấn đề: Nội dung quá ngắn/thiếu

**Giải pháp:**
```
[... prompt ...]

YÊU CẦU CỤ THỂ:
- Mỗi phần phải có ít nhất 500 từ
- Mỗi concept phải có ít nhất 2 ví dụ code
- Phải có ít nhất 5 lỗi thường gặp
```

### Vấn đề: Code không chính xác

**Giải pháp:**
```
[... prompt ...]

YÊU CẦU CODE:
- Code phải có thể chạy được ngay
- Phải có comment giải thích
- Phải test trước khi đưa vào
```

### Vấn đề: Nội dung không phù hợp với đối tượng

**Giải pháp:**
```
[... prompt ...]

ĐỐI TƯỢNG:
- Sinh viên năm [X]
- Đã có kiến thức về [Y]
- Cần tập trung vào [Z]

ĐIỀU CHỈNH:
- [Điều chỉnh cụ thể]
```

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề:

1. Đọc lại phần Troubleshooting ở trên
2. Xem lại ví dụ trong `PROMPT_SIMPLE.md`
3. Điều chỉnh prompt theo nhu cầu cụ thể
4. Test với 1 file nhỏ trước

---

## 📝 CHANGELOG

**Version 1.0** (2025)
- Tạo prompt template ban đầu
- Dựa trên quy trình đã thử nghiệm với ebook Flutter
- Bao gồm: PROMPT_TEMPLATE.md, PROMPT_SIMPLE.md, PROMPT_README.md

---

## 🎉 KẾT LUẬN

Prompt template này giúp bạn:
- ✅ Tự động hóa việc bổ sung nội dung
- ✅ Đảm bảo tính nhất quán
- ✅ Tiết kiệm thời gian
- ✅ Nâng cao chất lượng tài liệu

**Nhớ:** AI là công cụ hỗ trợ, không thay thế được human review và chỉnh sửa!

---

**Chúc bạn thành công! 🚀**


# 📋 PROMPT TEMPLATE - BỔ SUNG NỘI DUNG CHO EBOOK/TÀI LIỆU HỌC TẬP

## 🎯 MỤC ĐÍCH
Prompt này được thiết kế để bổ sung và mở rộng nội dung cho các chương/bài học trong ebook hoặc tài liệu học tập, đảm bảo tính nhất quán về phong cách, cấu trúc và độ sâu của nội dung.

---

## 📝 PROMPT CHUẨN

```
Bạn là một trợ lý AI chuyên nghiệp trong việc bổ sung và mở rộng nội dung cho tài liệu học tập.

NHIỆM VỤ:
Hãy đọc file [TÊN_FILE] và bổ sung nội dung chi tiết, đầy đủ theo phong cách và cấu trúc đã có sẵn.

YÊU CẦU:

1. ĐỌC VÀ PHÂN TÍCH:
   - Đọc toàn bộ nội dung file hiện tại để hiểu:
     * Cấu trúc chương/bài
     * Phong cách viết (ngôn ngữ, tone, format)
     * Các phần đã có và chưa có
     * Độ sâu của nội dung hiện tại
     * Các pattern về emoji, heading, code blocks

2. BỔ SUNG NỘI DUNG:
   Với mỗi phần/concept trong chương, bổ sung:

   a) GIẢNG GIẢI CHI TIẾT (🧠):
      - Giải thích khái niệm một cách dễ hiểu
      - So sánh với các khái niệm liên quan
      - Ví dụ minh họa từ đời sống (nếu phù hợp)
      - Lý do tại sao cần học phần này
      - Các trường hợp sử dụng thực tế

   b) VÍ DỤ CODE ĐẦY ĐỦ:
      - Code examples hoàn chỉnh, có thể chạy được
      - Comment giải thích các bước quan trọng
      - Nhiều ví dụ từ đơn giản đến phức tạp
      - Ví dụ "Sai vs Đúng" để so sánh

   c) CÁC LỖI THƯỜNG GẶP:
      - Liệt kê 5-10 lỗi sinh viên hay mắc phải
      - Mỗi lỗi gồm:
        * ❌ Vấn đề: Code/approach sai
        * ✅ Giải pháp: Code/approach đúng
        * 🔍 Giải thích chi tiết: Tại sao sai, tại sao đúng

   d) CASE STUDY / VÍ DỤ THỰC TẾ:
      - 3-5 ví dụ thực tế đa dạng
      - Mỗi ví dụ gồm:
        * Mô tả tình huống
        * Code implementation đầy đủ
        * Giải thích từng bước
        * Best practices áp dụng

   e) BEST PRACTICES:
      - Các quy tắc, nguyên tắc tốt
      - Performance tips
      - Security considerations
      - Code organization
      - Naming conventions

   f) BÀI TẬP THỰC HÀNH:
      - 5-8 bài tập từ dễ đến khó
      - Bài tập thực tế, có thể áp dụng ngay

   g) MINI TEST:
      - 10 câu hỏi ngắn gọn
      - Bao quát các concept chính
      - Có đáp án ngay sau câu hỏi

   h) QUICK NOTES:
      - Tóm tắt các điểm quan trọng
      - Dạng bullet points dễ nhớ
      - Các công thức, syntax quan trọng

3. NGUYÊN TẮC VIẾT:

   a) PHONG CÁCH:
      - Giữ nguyên tone và phong cách của file gốc
      - Sử dụng cùng format markdown
      - Giữ nguyên pattern emoji (nếu có)
      - Giữ nguyên cấu trúc heading (# ## ###)

   b) NGÔN NGỮ:
      - Sử dụng ngôn ngữ của file gốc (Tiếng Việt/Tiếng Anh)
      - Thuật ngữ chuyên ngành nhất quán
      - Giải thích rõ ràng, dễ hiểu cho người mới học

   c) CODE:
      - Code phải chính xác, có thể chạy được
      - Comment bằng ngôn ngữ của file gốc
      - Format code đúng chuẩn
      - Sử dụng syntax highlighting phù hợp

   d) CẤU TRÚC:
      - Tuân theo cấu trúc đã có trong file gốc
      - Thêm các phần mới vào đúng vị trí logic
      - Đảm bảo flow mạch lạc từ cơ bản đến nâng cao

4. XỬ LÝ FILE TRỐNG:
   - Nếu file trống hoặc chỉ có tiêu đề:
     * Tạo nội dung đầy đủ từ đầu
     * Tham khảo cấu trúc của các chương trước (nếu có)
     * Đảm bảo đầy đủ tất cả các phần: Mục tiêu, Nội dung chính, Ví dụ, Lỗi thường gặp, Best practices, Bài tập, Mini test, Quick notes

5. KIỂM TRA:
   - Đảm bảo không có lỗi syntax
   - Kiểm tra linter errors
   - Đảm bảo markdown format đúng
   - Code examples phải hợp lệ

QUY TRÌNH THỰC HIỆN:
1. Đọc file [TÊN_FILE]
2. Phân tích cấu trúc và phong cách
3. Xác định các phần cần bổ sung
4. Bổ sung nội dung chi tiết cho từng phần
5. Kiểm tra và sửa lỗi (nếu có)
6. Đảm bảo tính nhất quán với các chương trước

LƯU Ý:
- KHÔNG thay đổi nội dung đã có (trừ khi có lỗi)
- CHỈ bổ sung và mở rộng
- Giữ nguyên format và style
- Đảm bảo tính liên kết giữa các phần
```

---

## 🔄 CÁCH SỬ DỤNG

### Bước 1: Điều chỉnh prompt theo môn học
Thay thế các placeholder:
- `[TÊN_FILE]` → Tên file cụ thể
- Điều chỉnh các phần phù hợp với môn học (ví dụ: thêm phần "Lab" cho môn thực hành)

### Bước 2: Sử dụng prompt
```
[Tên file cần bổ sung]

Bạn là một trợ lý AI chuyên nghiệp trong việc bổ sung và mở rộng nội dung cho tài liệu học tập.

NHIỆM VỤ:
Hãy đọc file docs/[tên_file].md và bổ sung nội dung chi tiết, đầy đủ theo phong cách và cấu trúc đã có sẵn.

[... phần còn lại của prompt ...]
```

### Bước 3: Lặp lại cho các chương tiếp theo
```
Tiếp tục với [Chương/Bài tiếp theo]
```

---

## 📊 CHECKLIST KIỂM TRA

Sau khi bổ sung, đảm bảo:

- [ ] Đã đọc và hiểu cấu trúc file gốc
- [ ] Giữ nguyên phong cách và tone
- [ ] Bổ sung đầy đủ các phần: Giải thích chi tiết, Ví dụ, Lỗi thường gặp, Best practices
- [ ] Code examples chính xác và có thể chạy được
- [ ] Không có lỗi syntax hoặc linter errors
- [ ] Format markdown đúng chuẩn
- [ ] Tính nhất quán với các chương trước
- [ ] Độ sâu nội dung phù hợp với mục tiêu học tập

---

## 🎯 TÙY BIẾN THEO MÔN HỌC

### Cho môn Lập trình:
- Thêm phần: Code examples, Debugging tips, Performance optimization
- Ví dụ thực tế: Mini projects, Real-world scenarios

### Cho môn Lý thuyết:
- Thêm phần: Định nghĩa, Định lý, Chứng minh, Ứng dụng
- Ví dụ: Case studies, Bài toán minh họa

### Cho môn Thực hành:
- Thêm phần: Lab exercises, Step-by-step tutorials, Troubleshooting
- Ví dụ: Hands-on projects, Screenshots/GIFs

### Cho môn Ngoại ngữ:
- Thêm phần: Vocabulary, Grammar points, Practice exercises
- Ví dụ: Dialogues, Reading passages, Listening exercises

---

## 💡 VÍ DỤ SỬ DỤNG CỤ THỂ

### Ví dụ 1: Môn Lập trình Web
```
Bạn là một trợ lý AI chuyên nghiệp trong việc bổ sung và mở rộng nội dung cho tài liệu học tập.

NHIỆM VỤ:
Hãy đọc file docs/05_react_hooks.md và bổ sung nội dung chi tiết về React Hooks theo phong cách và cấu trúc đã có sẵn.

YÊU CẦU:
[... prompt chuẩn ...]

ĐẶC BIỆT CHO MÔN NÀY:
- Thêm ví dụ về: useState, useEffect, useContext, custom hooks
- Thêm phần: React DevTools tips, Performance optimization với hooks
- Ví dụ thực tế: Todo app với hooks, Form validation với hooks
```

### Ví dụ 2: Môn Database
```
Bạn là một trợ lý AI chuyên nghiệp trong việc bổ sung và mở rộng nội dung cho tài liệu học tập.

NHIỆM VỤ:
Hãy đọc file docs/07_sql_advanced.md và bổ sung nội dung chi tiết về SQL nâng cao theo phong cách và cấu trúc đã có sẵn.

YÊU CẦU:
[... prompt chuẩn ...]

ĐẶC BIỆT CHO MÔN NÀY:
- Thêm ví dụ về: JOINs, Subqueries, Stored Procedures, Triggers
- Thêm phần: Query optimization, Indexing best practices
- Ví dụ thực tế: E-commerce database queries, Reporting queries
```

---

## 🚀 TIPS ĐỂ PROMPT HIỆU QUẢ HƠN

1. **Cung cấp context**: Nếu có, đính kèm 1-2 file mẫu để AI hiểu rõ phong cách
2. **Chỉ định rõ mục tiêu**: Nêu rõ đối tượng học viên (beginner/intermediate/advanced)
3. **Yêu cầu cụ thể**: Thay vì "bổ sung nội dung", nêu rõ "bổ sung 5 ví dụ code, 3 case studies"
4. **Kiểm tra kết quả**: Luôn review output và điều chỉnh prompt nếu cần

---

## 📌 LƯU Ý QUAN TRỌNG

- Prompt này là template, cần điều chỉnh theo từng môn học cụ thể
- Luôn test prompt với 1-2 chương trước khi áp dụng hàng loạt
- Giữ lại prompt gốc để tham khảo và cải thiện
- Cập nhật prompt dựa trên feedback và kết quả thực tế

---

**Tác giả**: Được tạo dựa trên quy trình bổ sung nội dung cho ebook Flutter  
**Ngày tạo**: 2025  
**Phiên bản**: 1.0


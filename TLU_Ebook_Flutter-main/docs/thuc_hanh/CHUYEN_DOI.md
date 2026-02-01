# 📦 HƯỚNG DẪN CHUYỂN ĐỔI VÀ TỔ CHỨC LẠI

> **Mục đích:** Tổ chức lại các file thực hành vào thư mục riêng để dễ quản lý

---

## 📋 DANH SÁCH FILE CẦN DI CHUYỂN

Các file thực hành hiện đang nằm trong `docs/`:

1. `04_05_thuc_hanh_chi_tiet.md` → `thuc_hanh/04_thuc_hanh_widget_layout.md`
2. `06_thuc_hanh_chi_tiet.md` → `thuc_hanh/06_thuc_hanh_navigation.md`
3. `07_thuc_hanh_chi_tiet.md` → `thuc_hanh/07_thuc_hanh_form_input.md`
4. `08_thuc_hanh_chi_tiet.md` → `thuc_hanh/08_thuc_hanh_state_management.md`
5. `09_thuc_hanh_chi_tiet.md` → `thuc_hanh/09_thuc_hanh_provider.md`
6. `09_b_thuc_hanh_bloc.md` → `thuc_hanh/09b_thuc_hanh_bloc.md`
7. `10_thuc_hanh_bloc_provider_dotnet_api.md` → `thuc_hanh/10_thuc_hanh_api_dotnet.md`

---

## 🔄 CÁCH THỰC HIỆN

### Cách 1: Di chuyển file (Khuyến nghị)

**Windows (PowerShell):**
```powershell
cd docs
Move-Item "04_05_thuc_hanh_chi_tiet.md" "thuc_hanh/04_thuc_hanh_widget_layout.md"
Move-Item "06_thuc_hanh_chi_tiet.md" "thuc_hanh/06_thuc_hanh_navigation.md"
Move-Item "07_thuc_hanh_chi_tiet.md" "thuc_hanh/07_thuc_hanh_form_input.md"
Move-Item "08_thuc_hanh_chi_tiet.md" "thuc_hanh/08_thuc_hanh_state_management.md"
Move-Item "09_thuc_hanh_chi_tiet.md" "thuc_hanh/09_thuc_hanh_provider.md"
Move-Item "09_b_thuc_hanh_bloc.md" "thuc_hanh/09b_thuc_hanh_bloc.md"
Move-Item "10_thuc_hanh_bloc_provider_dotnet_api.md" "thuc_hanh/10_thuc_hanh_api_dotnet.md"
```

**macOS/Linux:**
```bash
cd docs
mv 04_05_thuc_hanh_chi_tiet.md thuc_hanh/04_thuc_hanh_widget_layout.md
mv 06_thuc_hanh_chi_tiet.md thuc_hanh/06_thuc_hanh_navigation.md
mv 07_thuc_hanh_chi_tiet.md thuc_hanh/07_thuc_hanh_form_input.md
mv 08_thuc_hanh_chi_tiet.md thuc_hanh/08_thuc_hanh_state_management.md
mv 09_thuc_hanh_chi_tiet.md thuc_hanh/09_thuc_hanh_provider.md
mv 09_b_thuc_hanh_bloc.md thuc_hanh/09b_thuc_hanh_bloc.md
mv 10_thuc_hanh_bloc_provider_dotnet_api.md thuc_hanh/10_thuc_hanh_api_dotnet.md
```

### Cách 2: Giữ nguyên và tạo link (Tạm thời)

Nếu không muốn di chuyển ngay, có thể:
- Giữ file ở vị trí cũ
- Cập nhật README.md để trỏ đến đúng vị trí
- Di chuyển sau khi đã kiểm tra mọi thứ hoạt động

---

## ⚠️ LƯU Ý SAU KHI DI CHUYỂN

1. **Cập nhật các link trong file:**
   - Kiểm tra các link `../` trong file đã di chuyển
   - Cập nhật đường dẫn nếu cần

2. **Cập nhật README.md:**
   - Sửa các đường dẫn trong README.md
   - Đảm bảo link hoạt động đúng

3. **Kiểm tra file tổng quan:**
   - Cập nhật `00_tong_quan.md` nếu có link đến file thực hành

---

## ✅ CHECKLIST SAU KHI DI CHUYỂN

- [ ] Tất cả file đã được di chuyển
- [ ] Đường dẫn trong file đã được cập nhật
- [ ] README.md đã được cập nhật
- [ ] Các link hoạt động đúng
- [ ] Không có file bị mất

---

**Lưu ý:** Có thể thực hiện từng bước một, không cần làm hết cùng lúc.

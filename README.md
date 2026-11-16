# Hệ Thống Quản Lý Cửa Hàng Bách Hóa Trực Tuyến (Online Department Store Management System)

> **Học phần:** Phân tích & Thiết kế Hệ thống Thông tin (PTTK)  
> **Sinh viên thực hiện:** Đỗ Minh Tiến  
> **Mã sinh viên:** B23DCDT254  
> **Mã đề (Subject No.):** 36  
> **Repository:** [PTTK-Online-Department-Store-Management-System](https://github.com/tubi22/PTTK-Online-Department-Store-Management-System.git)

---

## 📌 Giới thiệu dự án
Dự án được xây dựng theo đúng tài liệu báo cáo phân tích và thiết kế hệ thống quản lý cửa hàng bách hóa trực tuyến (Subject 36). Hệ thống tập trung triển khai đầy đủ các nghiệp vụ:

1. **Phân hệ xác thực người dùng:**
   - **Đăng nhập (`gddangnhap4.jsp`, `dodangnhap4.jsp`):** Kiểm tra thông tin, xác thực tài khoản và tự động phân quyền điều hướng đến trang chủ tương ứng (Khách hàng hoặc Quản lý).
   - **Đăng ký (`gddangky4.jsp`, `dodangky4.jsp`):** Cho phép người dùng đăng ký tài khoản thành viên Khách hàng mới.
   - **Đăng xuất (`dodangxuat4.jsp`):** Hủy phiên làm việc (`session`) an toàn.

2. **Module 1: Khách hàng tìm kiếm mặt hàng (`SearchForItems4`):**
   - **Trang chủ Khách hàng (`kh/gdchinhkh4.jsp`):** Chào mừng và điều hướng.
   - **Tìm kiếm mặt hàng (`kh/gdtimmathang4.jsp`):** Tìm kiếm theo từ khóa tên sản phẩm, hiển thị bảng kết quả (TT, Mã MH, Tên mặt hàng, ĐVT, Đơn giá, SL tồn, Thao tác).
   - **Chi tiết mặt hàng (`kh/gdchitietmathang4.jsp`):** Hiển thị chi tiết mã, tên, loại sản phẩm, đơn vị tính, đơn giá, số lượng tồn kho, mô tả và nút quay lại.

3. **Module 2: Quản lý xem thống kê khách hàng theo doanh thu (`ViewCustomerStatistics4`):**
   - **Trang chủ Quản lý (`ql/gdchinhql4.jsp`):** Chức năng xem báo cáo thống kê.
   - **Chọn loại thống kê (`ql/gdchontk4.jsp`):** Chọn loại thống kê khách hàng theo doanh thu.
   - **Thống kê khách hàng theo doanh thu (`ql/gdtkkhachhang4.jsp`):** Lọc theo khoảng ngày (Ngày bắt đầu, Ngày kết thúc), hiển thị bảng danh sách xếp hạng theo tổng doanh thu giảm dần (TT, Mã KH, Họ tên, Tổng số HĐ, Tổng doanh thu).
   - **Chi tiết khách hàng & Giao dịch (`ql/gdchitietkh4.jsp`):** Xem thông tin cá nhân khách hàng (Mã KH, Họ tên, SĐT, Email, Địa chỉ) và danh sách các hóa đơn mua hàng trong kỳ (Mã HĐ, Ngày lập, Trạng thái, Tổng tiền, Tổng cộng).

---

## 🏗️ Cấu trúc thư mục dự án (Tuân thủ chuẩn Báo cáo PTTK)
```text
PTTK-Online-Department-Store-Management-System/
├── 36B23DCDT254.pdf                     # Tài liệu Báo cáo gốc
├── README.md                            # Tài liệu hướng dẫn dự án
├── pom.xml                              # Cấu hình Maven
├── run.bat                              # File khởi chạy nhanh trên Windows
├── app.py                               # Web server chạy thử nghiệm trực tiếp
├── database/
│   ├── qlcuahang4.sql                   # Kịch bản DDL + DML CSDL MySQL
│   └── qlcuahang4.db                    # CSDL SQLite đi kèm khởi chạy tức thì
└── qlCuaHang4/                          # Cấu trúc Eclipse Dynamic Web Project
    ├── Java Resources/
    │   └── src/
    │       ├── dao/
    │       │   ├── DAO4.java            # Lớp kết nối CSDL cơ sở
    │       │   ├── ThanhVienDAO4.java    # Xử lý xác thực thành viên & đăng ký
    │       │   ├── MatHangDAO4.java      # Tìm kiếm và lấy chi tiết mặt hàng
    │       │   ├── TKKhachHangDAO4.java  # Thống kê khách hàng theo doanh thu
    │       │   └── HoaDonDAO4.java       # Lấy lịch sử hóa đơn & giao dịch KH
    │       ├── model/
    │       │   ├── ThanhVien4.java
    │       │   ├── KhachHang4.java
    │       │   ├── NhanVien4.java
    │       │   ├── NVQuanLi4.java
    │       │   ├── NVBanHang4.java
    │       │   ├── CuaHang4.java
    │       │   ├── LoaiMatHang4.java
    │       │   ├── MatHang4.java
    │       │   ├── HoaDon4.java
    │       │   ├── HoaDonChiTiet4.java
    │       │   └── TKKhachHang4.java
    │       └── unittest/
    │           ├── TestMatHangDAO4.java
    │           ├── TestTKKhachHangDAO4.java
    │           └── TestHoaDonDAO4.java
    └── WebContent/
        ├── index.jsp                    # Tự động chuyển hướng về trang đăng nhập
        ├── gddangnhap4.jsp              # Giao diện Đăng nhập
        ├── dodangnhap4.jsp              # Xử lý Đăng nhập
        ├── gddangky4.jsp                # Giao diện Đăng ký thành viên
        ├── dodangky4.jsp                # Xử lý Đăng ký
        ├── dodangxuat4.jsp              # Xử lý Đăng xuất
        ├── kh/                          # Phân hệ Khách hàng
        │   ├── gdchinhkh4.jsp
        │   ├── gdtimmathang4.jsp
        │   └── gdchitietmathang4.jsp
        ├── ql/                          # Phân hệ Quản lý
        │   ├── gdchinhql4.jsp
        │   ├── gdchontk4.jsp
        │   ├── gdtkkhachhang4.jsp
        │   └── gdchitietkh4.jsp
        └── WEB-INF/
            ├── web.xml                  # Deployment Descriptor
            └── lib/                     # Thư viện JAR (mysql-connector, junit)
```

---

## 🚀 Hướng dẫn chạy ứng dụng Web

### Cách 1: Khởi chạy trực tiếp tức thì (Khuyên dùng)
Hệ thống đã tích hợp sẵn web runner hoàn chỉnh, bạn có thể chạy ngay mà không cần cài đặt Tomcat:
1. Nhấp đúp chuột vào file `run.bat` (hoặc mở Terminal gõ `python app.py`).
2. Mở trình duyệt web và truy cập địa chỉ:
   ```text
   http://localhost:8080/
   ```
3. Toàn bộ các trang `.jsp`, form tìm kiếm, thống kê, đăng nhập, đăng ký và đăng xuất sẽ hoạt động trực tiếp.

### Cách 2: Triển khai trên Eclipse & Apache Tomcat
1. Mở Eclipse IDE (Java EE / Web Developers).
2. Chọn `File` $\rightarrow$ `Import` $\rightarrow$ `General` $\rightarrow$ `Projects from Folder or Archive` $\rightarrow$ Chọn thư mục `qlCuaHang4`.
3. Nhấp chuột phải vào Project `qlCuaHang4` $\rightarrow$ `Run As` $\rightarrow$ `Run on Server` (chọn Apache Tomcat v8.0 hoặc v9.0).
4. Khởi chạy CSDL MySQL qua XAMPP:
   - Mở XAMPP Control Panel, Start Apache và MySQL.
   - Nhập script tại `database/qlcuahang4.sql` vào phpMyAdmin hoặc MySQL Workbench.

---

## 🔑 Tài khoản thử nghiệm (Sẵn có trong CSDL)
| Vai trò | Tên đăng nhập | Mật khẩu | Họ và tên | Chức vụ / Mã |
| :--- | :--- | :--- | :--- | :--- |
| **Quản lý** | `quanly` | `123456` | Phạm Quốc Quản | NVQuanLi |
| **Khách hàng 1** | `an_nv` | `123456` | Nguyen Van An | KH01 (2 hóa đơn, tổng 4.500.000đ) |
| **Khách hàng 2** | `binh_tt` | `123456` | Tran Thi Binh | KH02 (1 hóa đơn, tổng 2.150.000đ) |

---

## 🧪 Chạy Kiểm thử Đơn vị (Unit Test)
Dự án cung cấp 3 bộ kiểm thử JUnit 4 cho các DAO:
- `TestMatHangDAO4`: Kiểm thử tìm kiếm theo tên và chi tiết mặt hàng.
- `TestTKKhachHangDAO4`: Kiểm thử thống kê doanh thu theo khoảng thời gian và sắp xếp giảm dần.
- `TestHoaDonDAO4`: Kiểm thử trích xuất hóa đơn của khách hàng.

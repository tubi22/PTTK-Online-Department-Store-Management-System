# Hệ Thống Quản Lý Cửa Hàng Bách Hóa Trực Tuyến (Online Department Store Management System)

> **Môn học:** Phân tích & Thiết kế Hệ thống Thông tin (PTTK)  
> **Sinh viên thực hiện:** Đỗ Minh Tiến - Mã SV: B23DCDT254  
> **Mã đề (Subject No.):** 36  

---

## 📌 Giới thiệu dự án
Dự án được xây dựng dựa trên tài liệu đặc tả, phân tích và thiết kế hệ thống quản lý cửa hàng bách hóa trực tuyến. Hệ thống tập trung triển khai hai phân hệ nghiệp vụ trọng tâm:
1. **Module 1 (Khách hàng):** Tìm kiếm mặt hàng và xem thông tin chi tiết mặt hàng.
2. **Module 2 (Quản lý):** Thống kê khách hàng theo doanh thu trong khoảng thời gian và xem chi tiết giao dịch / lịch sử đơn hàng của từng khách hàng.
3. **Phân hệ xác thực:** Đăng ký, Đăng nhập, Đăng xuất và phân quyền người dùng (Khách hàng / Nhân viên quản lý).

---

## 🏗️ Kiến trúc & Công nghệ
* **Kiến trúc:** MVC kết hợp mẫu thiết kế DAO (Data Access Object).
* **Ngôn ngữ & Nền tảng:** Java (Servlet / JSP), HTML5, CSS3, JavaScript.
* **Cơ sở dữ liệu:** MySQL / MariaDB (Bộ bảng `tbl*4`).
* **Kiểm thử:** JUnit 4 (Unit test cho các lớp DAO).

---

## 📁 Cấu trúc thư mục dự án
Tuân thủ chính xác theo báo cáo:
```text
qlCuaHang4/
├── Java Resources/
│   ├── src/
│   │   ├── dao/
│   │   │   ├── DAO4.java
│   │   │   ├── ThanhVienDAO4.java
│   │   │   ├── MatHangDAO4.java
│   │   │   ├── TKKhachHangDAO4.java
│   │   │   └── HoaDonDAO4.java
│   │   ├── model/
│   │   │   ├── ThanhVien4.java
│   │   │   ├── KhachHang4.java
│   │   │   ├── NhanVien4.java
│   │   │   ├── NVQuanLi4.java
│   │   │   ├── NVBanHang4.java
│   │   │   ├── CuaHang4.java
│   │   │   ├── LoaiMatHang4.java
│   │   │   ├── MatHang4.java
│   │   │   ├── HoaDon4.java
│   │   │   ├── HoaDonChiTiet4.java
│   │   │   └── TKKhachHang4.java
│   │   └── unittest/
│   │       ├── TestMatHangDAO4.java
│   │       ├── TestTKKhachHangDAO4.java
│   │       └── TestHoaDonDAO4.java
│   └── Libraries/
└── WebContent/
    ├── gddangnhap4.jsp
    ├── dodangnhap4.jsp
    ├── gddangky4.jsp
    ├── dodangky4.jsp
    ├── dodangxuat4.jsp
    ├── kh/
    │   ├── gdchinhkh4.jsp
    │   ├── gdtimmathang4.jsp
    │   └── gdchitietmathang4.jsp
    ├── ql/
    │   ├── gdchinhql4.jsp
    │   ├── gdchontk4.jsp
    │   ├── gdtkkhachhang4.jsp
    │   └── gdchitietkh4.jsp
    └── WEB-INF/
        └── web.xml
```

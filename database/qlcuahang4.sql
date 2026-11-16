-- =======================================================
-- Hệ Thống Quản Lý Cửa Hàng Bách Hóa Trực Tuyến
-- Script tạo Cơ sở dữ liệu qlcuahang4
-- Học phần: Phân tích Thiết kế Hệ thống Thông tin (PTTK)
-- Sinh viên: Đỗ Minh Tiến - B23DCDT254 - Đề số 36
-- =======================================================

CREATE DATABASE IF NOT EXISTS `qlcuahang4` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `qlcuahang4`;

-- 1. Bảng Cửa Hàng
DROP TABLE IF EXISTS `tblHoaDonChiTiet4`;
DROP TABLE IF EXISTS `tblHoaDon4`;
DROP TABLE IF EXISTS `tblMatHang4`;
DROP TABLE IF EXISTS `tblLoaiMatHang4`;
DROP TABLE IF EXISTS `tblNhanVien4`;
DROP TABLE IF EXISTS `tblKhachHang4`;
DROP TABLE IF EXISTS `tblCuaHang4`;
DROP TABLE IF EXISTS `tblThanhVien4`;

CREATE TABLE `tblThanhVien4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `hoten` VARCHAR(255) NOT NULL,
    `diachi` VARCHAR(255),
    `email` VARCHAR(255),
    `dt` VARCHAR(255),
    `vaitro` VARCHAR(255) NOT NULL COMMENT 'KhachHang, NVQuanLi, NVBanHang'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblCuaHang4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `ten` VARCHAR(255) NOT NULL,
    `diachi` VARCHAR(255),
    `mota` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblKhachHang4` (
    `makh` VARCHAR(50) NOT NULL UNIQUE,
    `tblThanhVien4Id` INT PRIMARY KEY,
    CONSTRAINT `fk_kh_thanhvien` FOREIGN KEY (`tblThanhVien4Id`) REFERENCES `tblThanhVien4`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblNhanVien4` (
    `vitri` VARCHAR(100),
    `tblThanhVien4Id` INT PRIMARY KEY,
    `tblCuaHang4id` INT,
    CONSTRAINT `fk_nv_thanhvien` FOREIGN KEY (`tblThanhVien4Id`) REFERENCES `tblThanhVien4`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_nv_cuahang` FOREIGN KEY (`tblCuaHang4id`) REFERENCES `tblCuaHang4`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblLoaiMatHang4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `ten` VARCHAR(255) NOT NULL,
    `mota` VARCHAR(255),
    `tblCuaHang4id` INT,
    CONSTRAINT `fk_loaimh_cuahang` FOREIGN KEY (`tblCuaHang4id`) REFERENCES `tblCuaHang4`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblMatHang4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `mamh` VARCHAR(255) NOT NULL UNIQUE,
    `ten` VARCHAR(255) NOT NULL,
    `donvitinh` VARCHAR(255),
    `dongia` FLOAT DEFAULT 0,
    `soluongton` INT DEFAULT 0,
    `mota` VARCHAR(255),
    `tblLoaiMatHang4id` INT,
    CONSTRAINT `fk_mh_loaimh` FOREIGN KEY (`tblLoaiMatHang4id`) REFERENCES `tblLoaiMatHang4`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblHoaDon4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `mahd` VARCHAR(255) NOT NULL UNIQUE,
    `ngaylap` DATE NOT NULL,
    `trangthai` VARCHAR(255) DEFAULT 'Da thanh toan',
    `tongtien` FLOAT DEFAULT 0,
    `ghichu` VARCHAR(255),
    `tblKhachHang4tblThanhVien4Id` INT NOT NULL,
    `tblNhanVien4tblThanhVien4Id` INT,
    CONSTRAINT `fk_hd_khachhang` FOREIGN KEY (`tblKhachHang4tblThanhVien4Id`) REFERENCES `tblThanhVien4`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_hd_nhanvien` FOREIGN KEY (`tblNhanVien4tblThanhVien4Id`) REFERENCES `tblThanhVien4`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tblHoaDonChiTiet4` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `soluong` INT NOT NULL,
    `dongia` FLOAT NOT NULL,
    `tblHoaDon4id` INT NOT NULL,
    `tblMatHang4id` INT NOT NULL,
    CONSTRAINT `fk_hdct_hoadon` FOREIGN KEY (`tblHoaDon4id`) REFERENCES `tblHoaDon4`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_hdct_mathang` FOREIGN KEY (`tblMatHang4id`) REFERENCES `tblMatHang4`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- DỮ LIỆU MẪU (THEO ĐÚNG BÁO CÁO VÀ TEST CASE)
-- =======================================================

-- Cửa hàng
INSERT INTO `tblCuaHang4` (`id`, `ten`, `diachi`, `mota`) VALUES
(1, 'Cửa hàng Bách Hóa Trực Tuyến Số 4', '120 Yên Lãng, Đống Đa, Hà Nội', 'Cửa hàng bách hóa tổng hợp trực tuyến phục vụ 24/7');

-- Thành viên: Quản lý, Nhân viên, Khách hàng
INSERT INTO `tblThanhVien4` (`id`, `username`, `password`, `hoten`, `diachi`, `email`, `dt`, `vaitro`) VALUES
(1, 'quanly', '123456', 'Phạm Quốc Quản', 'Hà Nội', 'quanly@cuahang4.com', '0988888888', 'NVQuanLi'),
(2, 'banhang', '123456', 'Lê Thị Mai', 'Hà Nội', 'mai@cuahang4.com', '0977777777', 'NVBanHang'),
(3, 'an_nv', '123456', 'Nguyen Van An', 'Ngo 120 Yen Lang', 'an@gmail.com', '0912345678', 'KhachHang'),
(4, 'binh_tt', '123456', 'Tran Thi Binh', 'Cau Giay, Ha Noi', 'binh@gmail.com', '0933333333', 'KhachHang'),
(5, 'cuong_nv', '123456', 'Nguyen Van Cuong', 'Dong Da, Ha Noi', 'cuong@gmail.com', '0944444444', 'KhachHang');

-- Phân loại Thành viên
INSERT INTO `tblNhanVien4` (`vitri`, `tblThanhVien4Id`, `tblCuaHang4id`) VALUES
('Quản lý cửa hàng', 1, 1),
('Nhân viên thu ngân / đóng gói', 2, 1);

INSERT INTO `tblKhachHang4` (`makh`, `tblThanhVien4Id`) VALUES
('KH01', 3),
('KH02', 4),
('KH03', 5);

-- Loại mặt hàng
INSERT INTO `tblLoaiMatHang4` (`id`, `ten`, `mota`, `tblCuaHang4id`) VALUES
(1, 'Sua va che pham tu sua', 'Các loại sữa chua, sữa tươi, sữa đặc tiệt trùng', 1),
(2, 'Banh keo va do an vat', 'Bánh quy, bánh mềm, snack các loại', 1),
(3, 'Nuoc giai khat', 'Nước ngọt có gas, nước khoáng, trà xanh', 1);

-- Mặt hàng
INSERT INTO `tblMatHang4` (`id`, `mamh`, `ten`, `donvitinh`, `dongia`, `soluongton`, `mota`, `tblLoaiMatHang4id`) VALUES
(1, 'MH01', 'Sua tuoi Vinamilk 1L', 'Hop', 32000, 120, 'Sua tuoi tiet trung nguyen chat 100%, hop giay 1 lit', 1),
(2, 'MH02', 'Sua chua TH True Yogurt', 'Loc', 28000, 85, 'Sua chua tu nhien len men tu sua tuoi TH True Milk', 1),
(3, 'MH03', 'Sua dac Ong Tho do', 'Lon', 24000, 150, 'Sua dac co duong Ong Tho truyen thong 380g', 1),
(4, 'MH04', 'Banh quy Cosy Marie', 'Goi', 45000, 60, 'Banh quy sua thom gion thom ngon', 2),
(5, 'MH05', 'Nuoc ngot Coca Cola 1.5L', 'Chai', 20000, 200, 'Nuoc giai khat co gas Coca Cola vi nguyen ban', 3),
(6, 'MH06', 'Sua tuoi tiet trung TH True Milk it duong 1L', 'Hop', 34000, 95, 'Sua tuoi it duong dinh duong tu nhien', 1);

-- Hóa đơn
-- Khách hàng KH01 (Nguyen Van An): 2 hóa đơn, tổng 4,500,000đ trong tháng 11/2026
INSERT INTO `tblHoaDon4` (`id`, `mahd`, `ngaylap`, `trangthai`, `tongtien`, `ghichu`, `tblKhachHang4tblThanhVien4Id`, `tblNhanVien4tblThanhVien4Id`) VALUES
(1, 'HD102', '2026-11-15', 'Da thanh toan', 1200000, 'Giao gio hanh chinh', 3, 2),
(2, 'HD089', '2026-11-23', 'Da thanh toan', 3300000, 'Giao truoc 17h', 3, 2),
-- Khách hàng KH02 (Tran Thi Binh): 1 hóa đơn, tổng 2,150,000đ trong tháng 11/2026
(3, 'HD075', '2026-11-20', 'Da thanh toan', 2150000, 'Giao tan nha', 4, 2),
-- Khách hàng KH03 (Nguyen Van Cuong): 1 hóa đơn ngoài khoảng thời gian
(4, 'HD050', '2026-10-10', 'Da thanh toan', 950000, 'Giao buoi sang', 5, 2);

-- Chi tiết hóa đơn
INSERT INTO `tblHoaDonChiTiet4` (`id`, `soluong`, `dongia`, `tblHoaDon4id`, `tblMatHang4id`) VALUES
(1, 20, 32000, 1, 1),
(2, 20, 28000, 1, 2),
(3, 50, 32000, 2, 1),
(4, 30, 45000, 2, 4),
(5, 17, 20000, 2, 5),
(6, 25, 34000, 3, 6),
(7, 30, 40000, 3, 4),
(8, 10, 10000, 3, 5);

-- =======================================================
-- CÁC STORED PROCEDURES (CHUẨN JDBC CALLABLESTATEMENT)
-- =======================================================

DELIMITER //

-- 1. Kiểm tra đăng nhập
DROP PROCEDURE IF EXISTS `sp_kiemTraDangNhap4` //
CREATE PROCEDURE `sp_kiemTraDangNhap4`(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT id, username, password, hoten, diachi, email, dt, vaitro
    FROM tblThanhVien4
    WHERE username = p_username AND password = p_password;
END //

-- 2. Đăng ký thành viên Khách hàng
DROP PROCEDURE IF EXISTS `sp_dangKyKhachHang4` //
CREATE PROCEDURE `sp_dangKyKhachHang4`(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_hoten VARCHAR(255),
    IN p_diachi VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_dt VARCHAR(255),
    IN p_makh VARCHAR(50),
    OUT p_status INT
)
BEGIN
    DECLARE v_tv_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
    END;

    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM tblThanhVien4 WHERE username = p_username) OR
       EXISTS (SELECT 1 FROM tblKhachHang4 WHERE makh = p_makh) THEN
        SET p_status = 0;
        ROLLBACK;
    ELSE
        INSERT INTO tblThanhVien4 (username, password, hoten, diachi, email, dt, vaitro)
        VALUES (p_username, p_password, p_hoten, p_diachi, p_email, p_dt, 'KhachHang');
        SET v_tv_id = LAST_INSERT_ID();

        INSERT INTO tblKhachHang4 (makh, tblThanhVien4Id)
        VALUES (p_makh, v_tv_id);

        COMMIT;
        SET p_status = v_tv_id;
    END IF;
END //

-- 3. Tìm kiếm mặt hàng theo tên (Module 1)
DROP PROCEDURE IF EXISTS `sp_timMatHangTheoTen4` //
CREATE PROCEDURE `sp_timMatHangTheoTen4`(
    IN p_ten VARCHAR(255)
)
BEGIN
    SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota,
           lmh.id AS loai_id, lmh.ten AS loai_ten, lmh.mota AS loai_mota
    FROM tblMatHang4 mh
    LEFT JOIN tblLoaiMatHang4 lmh ON mh.tblLoaiMatHang4id = lmh.id
    WHERE mh.ten LIKE CONCAT('%', p_ten, '%')
    ORDER BY mh.ten ASC;
END //

-- 4. Lấy chi tiết mặt hàng theo id (Module 1)
DROP PROCEDURE IF EXISTS `sp_getChiTietMatHang4` //
CREATE PROCEDURE `sp_getChiTietMatHang4`(
    IN p_id INT
)
BEGIN
    SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota,
           lmh.id AS loai_id, lmh.ten AS loai_ten, lmh.mota AS loai_mota
    FROM tblMatHang4 mh
    LEFT JOIN tblLoaiMatHang4 lmh ON mh.tblLoaiMatHang4id = lmh.id
    WHERE mh.id = p_id;
END //

-- 5. Thống kê khách hàng theo doanh thu (Module 2)
DROP PROCEDURE IF EXISTS `sp_getTKKhachHangTheoDoanhThu4` //
CREATE PROCEDURE `sp_getTKKhachHangTheoDoanhThu4`(
    IN p_ngayBD DATE,
    IN p_ngayKT DATE
)
BEGIN
    SELECT tv.id, kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt, tv.vaitro,
           COUNT(hd.id) AS tongsoHD, SUM(hd.tongtien) AS tongDoanhThu
    FROM tblHoaDon4 hd
    JOIN tblKhachHang4 kh ON hd.tblKhachHang4tblThanhVien4Id = kh.tblThanhVien4Id
    JOIN tblThanhVien4 tv ON kh.tblThanhVien4Id = tv.id
    WHERE hd.ngaylap >= p_ngayBD AND hd.ngaylap <= p_ngayKT
    GROUP BY tv.id, kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt, tv.vaitro
    ORDER BY tongDoanhThu DESC;
END //

-- 6. Lấy danh sách hóa đơn theo khách hàng và ngày (Module 2)
DROP PROCEDURE IF EXISTS `sp_getHoaDonCuaKH4` //
CREATE PROCEDURE `sp_getHoaDonCuaKH4`(
    IN p_idKH INT,
    IN p_ngayBD DATE,
    IN p_ngayKT DATE
)
BEGIN
    SELECT hd.id, hd.mahd, hd.ngaylap, hd.trangthai, hd.tongtien, hd.ghichu,
           kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt
    FROM tblHoaDon4 hd
    JOIN tblKhachHang4 kh ON hd.tblKhachHang4tblThanhVien4Id = kh.tblThanhVien4Id
    JOIN tblThanhVien4 tv ON kh.tblThanhVien4Id = tv.id
    WHERE hd.tblKhachHang4tblThanhVien4Id = p_idKH
      AND (p_ngayBD IS NULL OR hd.ngaylap >= p_ngayBD)
      AND (p_ngayKT IS NULL OR hd.ngaylap <= p_ngayKT)
    ORDER BY hd.ngaylap DESC;
END //

-- 7. Lấy chi tiết các mặt hàng trong hóa đơn
DROP PROCEDURE IF EXISTS `sp_getChiTietHoaDon4` //
CREATE PROCEDURE `sp_getChiTietHoaDon4`(
    IN p_idHD INT
)
BEGIN
    SELECT ct.id, ct.soluong, ct.dongia,
           mh.id AS mh_id, mh.mamh, mh.ten AS mh_ten, mh.donvitinh
    FROM tblHoaDonChiTiet4 ct
    JOIN tblMatHang4 mh ON ct.tblMatHang4id = mh.id
    WHERE ct.tblHoaDon4id = p_idHD;
END //

DELIMITER ;



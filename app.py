#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Web Server cho Hệ Thống Quản Lý Cửa Hàng Bách Hóa Trực Tuyến (qlCuaHang4)
Phục vụ chạy thử nghiệm trực tiếp giao diện Web với đầy đủ:
- Đăng nhập (gddangnhap4.jsp, dodangnhap4.jsp)
- Đăng ký (gddangky4.jsp, dodangky4.jsp)
- Đăng xuất (dodangxuat4.jsp)
- Module 1: Khách hàng tìm kiếm & xem chi tiết mặt hàng (kh/gdchinhkh4.jsp, kh/gdtimmathang4.jsp, kh/gdchitietmathang4.jsp)
- Module 2: Quản lý xem thống kê doanh thu & chi tiết giao dịch (ql/gdchinhql4.jsp, ql/gdchontk4.jsp, ql/gdtkkhachhang4.jsp, ql/gdchitietkh4.jsp)
"""

import http.server
import socketserver
import urllib.parse
import sqlite3
import os
import sys
import uuid
from datetime import datetime

PORT = 8080
DB_FILE = os.path.join(os.path.dirname(__file__), "database", "qlcuahang4.db")
SESSIONS = {}

def init_db():
    os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()

    cur.executescript("""
    CREATE TABLE IF NOT EXISTS tblThanhVien4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        hoten TEXT NOT NULL,
        diachi TEXT,
        email TEXT,
        dt TEXT,
        vaitro TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS tblCuaHang4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ten TEXT NOT NULL,
        diachi TEXT,
        mota TEXT
    );

    CREATE TABLE IF NOT EXISTS tblKhachHang4 (
        makh TEXT UNIQUE NOT NULL,
        tblThanhVien4Id INTEGER PRIMARY KEY,
        FOREIGN KEY (tblThanhVien4Id) REFERENCES tblThanhVien4(id)
    );

    CREATE TABLE IF NOT EXISTS tblNhanVien4 (
        vitri TEXT,
        tblThanhVien4Id INTEGER PRIMARY KEY,
        tblCuaHang4id INTEGER,
        FOREIGN KEY (tblThanhVien4Id) REFERENCES tblThanhVien4(id),
        FOREIGN KEY (tblCuaHang4id) REFERENCES tblCuaHang4(id)
    );

    CREATE TABLE IF NOT EXISTS tblLoaiMatHang4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ten TEXT NOT NULL,
        mota TEXT,
        tblCuaHang4id INTEGER,
        FOREIGN KEY (tblCuaHang4id) REFERENCES tblCuaHang4(id)
    );

    CREATE TABLE IF NOT EXISTS tblMatHang4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mamh TEXT UNIQUE NOT NULL,
        ten TEXT NOT NULL,
        donvitinh TEXT,
        dongia REAL DEFAULT 0,
        soluongton INTEGER DEFAULT 0,
        mota TEXT,
        tblLoaiMatHang4id INTEGER,
        FOREIGN KEY (tblLoaiMatHang4id) REFERENCES tblLoaiMatHang4(id)
    );

    CREATE TABLE IF NOT EXISTS tblHoaDon4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mahd TEXT UNIQUE NOT NULL,
        ngaylap TEXT NOT NULL,
        trangthai TEXT DEFAULT 'Da thanh toan',
        tongtien REAL DEFAULT 0,
        ghichu TEXT,
        tblKhachHang4tblThanhVien4Id INTEGER NOT NULL,
        tblNhanVien4tblThanhVien4Id INTEGER,
        FOREIGN KEY (tblKhachHang4tblThanhVien4Id) REFERENCES tblThanhVien4(id),
        FOREIGN KEY (tblNhanVien4tblThanhVien4Id) REFERENCES tblThanhVien4(id)
    );

    CREATE TABLE IF NOT EXISTS tblHoaDonChiTiet4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        soluong INTEGER NOT NULL,
        dongia REAL NOT NULL,
        tblHoaDon4id INTEGER NOT NULL,
        tblMatHang4id INTEGER NOT NULL,
        FOREIGN KEY (tblHoaDon4id) REFERENCES tblHoaDon4(id),
        FOREIGN KEY (tblMatHang4id) REFERENCES tblMatHang4(id)
    );
    """)

    # Seed initial data if empty
    cur.execute("SELECT COUNT(*) FROM tblThanhVien4")
    if cur.fetchone()[0] == 0:
        cur.execute("INSERT INTO tblCuaHang4 (id, ten, diachi, mota) VALUES (1, 'Cửa hàng Bách Hóa Trực Tuyến Số 4', '120 Yên Lãng, Đống Đa, Hà Nội', 'Cửa hàng bách hóa tổng hợp trực tuyến phục vụ 24/7')")
        
        # Thanh vien
        cur.executemany("INSERT INTO tblThanhVien4 (id, username, password, hoten, diachi, email, dt, vaitro) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [
            (1, 'quanly', '123456', 'Phạm Quốc Quản', 'Hà Nội', 'quanly@cuahang4.com', '0988888888', 'NVQuanLi'),
            (2, 'banhang', '123456', 'Lê Thị Mai', 'Hà Nội', 'mai@cuahang4.com', '0977777777', 'NVBanHang'),
            (3, 'an_nv', '123456', 'Nguyen Van An', 'Ngo 120 Yen Lang', 'an@gmail.com', '0912345678', 'KhachHang'),
            (4, 'binh_tt', '123456', 'Tran Thi Binh', 'Cau Giay, Ha Noi', 'binh@gmail.com', '0933333333', 'KhachHang'),
            (5, 'cuong_nv', '123456', 'Nguyen Van Cuong', 'Dong Da, Ha Noi', 'cuong@gmail.com', '0944444444', 'KhachHang'),
        ])

        cur.executemany("INSERT INTO tblNhanVien4 (vitri, tblThanhVien4Id, tblCuaHang4id) VALUES (?, ?, ?)", [
            ('Quản lý cửa hàng', 1, 1),
            ('Nhân viên bán hàng', 2, 1)
        ])

        cur.executemany("INSERT INTO tblKhachHang4 (makh, tblThanhVien4Id) VALUES (?, ?)", [
            ('KH01', 3),
            ('KH02', 4),
            ('KH03', 5)
        ])

        cur.executemany("INSERT INTO tblLoaiMatHang4 (id, ten, mota, tblCuaHang4id) VALUES (?, ?, ?, ?)", [
            (1, 'Sua va che pham tu sua', 'Các loại sữa chua, sữa tươi, sữa đặc tiệt trùng', 1),
            (2, 'Banh keo va do an vat', 'Bánh quy, bánh mềm, snack các loại', 1),
            (3, 'Nuoc giai khat', 'Nước ngọt có gas, nước khoáng, trà xanh', 1)
        ])

        cur.executemany("INSERT INTO tblMatHang4 (id, mamh, ten, donvitinh, dongia, soluongton, mota, tblLoaiMatHang4id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [
            (1, 'MH01', 'Sua tuoi Vinamilk 1L', 'Hop', 32000, 120, 'Sua tuoi tiet trung nguyen chat 100%, hop giay 1 lit', 1),
            (2, 'MH02', 'Sua chua TH True Yogurt', 'Loc', 28000, 85, 'Sua chua tu nhien len men tu sua tuoi TH True Milk', 1),
            (3, 'MH03', 'Sua dac Ong Tho do', 'Lon', 24000, 150, 'Sua dac co duong Ong Tho truyen thong 380g', 1),
            (4, 'MH04', 'Banh quy Cosy Marie', 'Goi', 45000, 60, 'Banh quy sua thom gion thom ngon', 2),
            (5, 'MH05', 'Nuoc ngot Coca Cola 1.5L', 'Chai', 20000, 200, 'Nuoc giai khat co gas Coca Cola vi nguyen ban', 3),
            (6, 'MH06', 'Sua tuoi tiet trung TH True Milk it duong 1L', 'Hop', 34000, 95, 'Sua tuoi it duong dinh duong tu nhien', 1)
        ])

        cur.executemany("INSERT INTO tblHoaDon4 (id, mahd, ngaylap, trangthai, tongtien, ghichu, tblKhachHang4tblThanhVien4Id, tblNhanVien4tblThanhVien4Id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [
            (1, 'HD102', '2026-11-15', 'Da thanh toan', 1200000, 'Giao gio hanh chinh', 3, 2),
            (2, 'HD089', '2026-11-23', 'Da thanh toan', 3300000, 'Giao truoc 17h', 3, 2),
            (3, 'HD075', '2026-11-20', 'Da thanh toan', 2150000, 'Giao tan nha', 4, 2),
            (4, 'HD050', '2026-10-10', 'Da thanh toan', 950000, 'Giao buoi sang', 5, 2)
        ])

        conn.commit()
    conn.close()

def get_db():
    return sqlite3.connect(DB_FILE)

class DepartmentStoreHandler(http.server.BaseHTTPRequestHandler):
    def get_session(self):
        cookies = self.headers.get('Cookie', '')
        for c in cookies.split(';'):
            c = c.strip()
            if c.startswith('SESSIONID='):
                sid = c[len('SESSIONID='):]
                if sid in SESSIONS:
                    return SESSIONS[sid], sid
        return None, None

    def set_session(self, user):
        sid = str(uuid.uuid4())
        SESSIONS[sid] = user
        return sid

    def send_html(self, content, status=200, cookie=None):
        self.send_response(status)
        self.send_header('Content-Type', 'text/html; charset=UTF-8')
        if cookie:
            self.send_header('Set-Cookie', cookie)
        self.end_headers()
        self.wfile.write(content.encode('utf-8'))

    def redirect(self, location, cookie=None):
        self.send_response(302)
        self.send_header('Location', location)
        if cookie:
            self.send_header('Set-Cookie', cookie)
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        qs = urllib.parse.parse_qs(parsed.query)

        user, sid = self.get_session()

        if path in ['/', '/index.jsp', '/index.html']:
            # Bat buoc dang nhap lai moi khi truy cap trang chu
            if sid and sid in SESSIONS:
                del SESSIONS[sid]
            self.redirect('/gddangnhap4.jsp', cookie="SESSIONID=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT")
            return

        elif path == '/gddangnhap4.jsp':
            # Khi vao trang dang nhap, luon xoa phien cu de yeu cau nhap lai
            if sid and sid in SESSIONS:
                del SESSIONS[sid]
            error = qs.get('error', [''])[0]
            msg = qs.get('message', [''])[0]
            self.render_login(error, msg, cookie="SESSIONID=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT" if sid else None)

        elif path == '/gddangky4.jsp':
            error = qs.get('error', [''])[0]
            self.render_register(error)

        elif path == '/dodangxuat4.jsp':
            if sid and sid in SESSIONS:
                del SESSIONS[sid]
            self.redirect('/gddangnhap4.jsp?message=' + urllib.parse.quote('Đã đăng xuất an toàn khỏi hệ thống.'), cookie="SESSIONID=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT")

        elif path == '/kh/gdchinhkh4.jsp':
            if not user:
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập để tiếp tục!'))
                return
            self.render_kh_chinh(user)

        elif path == '/kh/gdtimmathang4.jsp':
            if not user:
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập để tiếp tục!'))
                return
            tenMH = qs.get('txtTenMH', [None])[0]
            self.render_kh_tim_mathang(user, tenMH)

        elif path == '/kh/gdchitietmathang4.jsp':
            if not user:
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập để tiếp tục!'))
                return
            id_str = qs.get('id', ['0'])[0]
            self.render_kh_chitiet_mathang(user, int(id_str) if id_str.isdigit() else 0)

        elif path == '/ql/gdchinhql4.jsp':
            if not user or user['vaitro'] != 'NVQuanLi':
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập với quyền Quản lý!'))
                return
            self.render_ql_chinh(user)

        elif path == '/ql/gdchontk4.jsp':
            if not user or user['vaitro'] != 'NVQuanLi':
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập với quyền Quản lý!'))
                return
            self.render_ql_chontk(user)

        elif path == '/ql/gdtkkhachhang4.jsp':
            if not user or user['vaitro'] != 'NVQuanLi':
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập với quyền Quản lý!'))
                return
            ngayBD = qs.get('inNgayBD', ['2026-11-01'])[0]
            ngayKT = qs.get('inNgayKT', ['2026-11-30'])[0]
            self.render_ql_tk_khachhang(user, ngayBD, ngayKT)

        elif path == '/ql/gdchitietkh4.jsp':
            if not user or user['vaitro'] != 'NVQuanLi':
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Vui lòng đăng nhập với quyền Quản lý!'))
                return
            id_str = qs.get('id', ['0'])[0]
            ngayBD = qs.get('ngayBD', ['2026-11-01'])[0]
            ngayKT = qs.get('ngayKT', ['2026-11-30'])[0]
            self.render_ql_chitiet_kh(user, int(id_str) if id_str.isdigit() else 0, ngayBD, ngayKT)

        else:
            self.send_error(404, "Page Not Found")

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(length).decode('utf-8')
        form = urllib.parse.parse_qs(body)

        if path == '/dodangnhap4.jsp':
            u = form.get('username', [''])[0].strip()
            p = form.get('password', [''])[0].strip()

            conn = get_db()
            cur = conn.cursor()
            cur.execute("SELECT id, username, hoten, diachi, email, dt, vaitro FROM tblThanhVien4 WHERE username = ? AND password = ?", (u, p))
            row = cur.fetchone()
            conn.close()

            if row:
                user = {
                    'id': row[0],
                    'username': row[1],
                    'hoten': row[2],
                    'diachi': row[3],
                    'email': row[4],
                    'dt': row[5],
                    'vaitro': row[6]
                }
                sid = self.set_session(user)
                cookie = f"SESSIONID={sid}; Path=/; HttpOnly"
                if user['vaitro'] == 'NVQuanLi':
                    self.redirect('/ql/gdchinhql4.jsp', cookie=cookie)
                else:
                    self.redirect('/kh/gdchinhkh4.jsp', cookie=cookie)
            else:
                self.redirect('/gddangnhap4.jsp?error=' + urllib.parse.quote('Sai tên đăng nhập hoặc mật khẩu!'))

        elif path == '/dodangky4.jsp':
            u = form.get('username', [''])[0].strip()
            p = form.get('password', [''])[0].strip()
            hoten = form.get('hoten', [''])[0].strip()
            makh = form.get('makh', [''])[0].strip()
            email = form.get('email', [''])[0].strip()
            dt = form.get('dt', [''])[0].strip()
            diachi = form.get('diachi', [''])[0].strip()

            if not u or not p or not hoten or not makh:
                self.redirect('/gddangky4.jsp?error=' + urllib.parse.quote('Vui lòng điền đầy đủ các thông tin bắt buộc!'))
                return

            conn = get_db()
            cur = conn.cursor()
            try:
                cur.execute("INSERT INTO tblThanhVien4 (username, password, hoten, diachi, email, dt, vaitro) VALUES (?, ?, ?, ?, ?, ?, ?)",
                            (u, p, hoten, diachi, email, dt, 'KhachHang'))
                tv_id = cur.lastrowid
                cur.execute("INSERT INTO tblKhachHang4 (makh, tblThanhVien4Id) VALUES (?, ?)", (makh, tv_id))
                conn.commit()
                conn.close()
                self.redirect('/gddangnhap4.jsp?message=' + urllib.parse.quote('Đăng ký thành công! Vui lòng đăng nhập.'))
            except sqlite3.IntegrityError:
                conn.close()
                self.redirect('/gddangky4.jsp?error=' + urllib.parse.quote('Tên đăng nhập hoặc Mã KH đã tồn tại!'))

        else:
            self.send_error(404, "Action Not Found")

    # Render methods
    def render_login(self, error, message, cookie=None):
        alert_err = f'<div style="background:#ffebee;color:#c62828;padding:10px 14px;border-radius:6px;margin-bottom:15px;border:1px solid #ffcdd2;">{error}</div>' if error else ''
        alert_msg = f'<div style="background:#e8f5e9;color:#2e7d32;padding:10px 14px;border-radius:6px;margin-bottom:15px;border:1px solid #c8e6c9;">{message}</div>' if message else ''
        
        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Đăng nhập hệ thống - Cửa Hàng Bách Hóa Số 4</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }}
        .card {{ background: #fff; width: 100%; max-width: 420px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }}
        h2 {{ color: #1e3c72; text-align: center; margin-bottom: 6px; }}
        p.sub {{ color: #666; text-align: center; font-size: 14px; margin-bottom: 25px; }}
        .form-group {{ margin-bottom: 18px; }}
        label {{ display: block; margin-bottom: 6px; font-weight: 600; color: #333; font-size: 14px; }}
        input {{ width: 100%; padding: 12px 14px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }}
        button {{ width: 100%; padding: 12px; background: #0088cc; color: #fff; border: none; border-radius: 6px; font-size: 16px; font-weight: 600; cursor: pointer; }}
        button:hover {{ background: #006699; }}
        .footer {{ text-align: center; margin-top: 20px; font-size: 14px; color: #666; }}
        .footer a {{ color: #0088cc; text-decoration: none; font-weight: 600; }}
        .demo {{ background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 6px; padding: 12px; margin-top: 20px; font-size: 12px; color: #555; }}
    </style>
</head>
<body>
    <div class="card">
        <h2>HỆ THỐNG BÁCH HÓA</h2>
        <p class="sub">Đăng nhập tài khoản để tiếp tục</p>
        {alert_err}
        {alert_msg}
        <form action="/dodangnhap4.jsp" method="POST">
            <div class="form-group">
                <label>Tên đăng nhập (Username):</label>
                <input type="text" name="username" placeholder="Nhập tên đăng nhập..." required autofocus>
            </div>
            <div class="form-group">
                <label>Mật khẩu (Password):</label>
                <input type="password" name="password" placeholder="Nhập mật khẩu..." required>
            </div>
            <button type="submit">Đăng nhập</button>
        </form>
        <div class="footer">
            Chưa có tài khoản? <a href="/gddangky4.jsp">Đăng ký ngay</a>
        </div>
        <div class="demo">
            <strong>Tài khoản thử nghiệm sẵn có:</strong><br>
            • Quản lý: <code>quanly</code> / <code>123456</code><br>
            • Khách hàng: <code>an_nv</code> / <code>123456</code> (KH01)<br>
            • Khách hàng: <code>binh_tt</code> / <code>123456</code> (KH02)
        </div>
    </div>
</body>
</html>"""
        self.send_html(html, cookie=cookie)

    def render_register(self, error):
        alert_err = f'<div style="background:#ffebee;color:#c62828;padding:10px 14px;border-radius:6px;margin-bottom:15px;">{error}</div>' if error else ''
        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Đăng ký tài khoản Khách Hàng</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }}
        .card {{ background: #fff; width: 100%; max-width: 520px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }}
        h2 {{ color: #1e3c72; text-align: center; margin-bottom: 6px; }}
        p.sub {{ color: #666; text-align: center; font-size: 14px; margin-bottom: 25px; }}
        .row {{ display: flex; gap: 15px; margin-bottom: 14px; }}
        .col {{ flex: 1; }}
        label {{ display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; }}
        input {{ width: 100%; padding: 10px 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }}
        button {{ width: 100%; padding: 12px; background: #28a745; color: #fff; border: none; border-radius: 6px; font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 10px; }}
        button:hover {{ background: #218838; }}
        .footer {{ text-align: center; margin-top: 20px; font-size: 14px; }}
        .footer a {{ color: #0088cc; text-decoration: none; font-weight: 600; }}
    </style>
</head>
<body>
    <div class="card">
        <h2>ĐĂNG KÝ KHÁCH HÀNG</h2>
        <p class="sub">Tạo tài khoản thành viên để mua sắm trực tuyến</p>
        {alert_err}
        <form action="/dodangky4.jsp" method="POST">
            <div class="row">
                <div class="col"><label>Tên đăng nhập (*):</label><input type="text" name="username" required></div>
                <div class="col"><label>Mật khẩu (*):</label><input type="password" name="password" required></div>
            </div>
            <div class="row">
                <div class="col"><label>Họ và tên (*):</label><input type="text" name="hoten" required></div>
                <div class="col"><label>Mã khách hàng (*):</label><input type="text" name="makh" placeholder="vd: KH04" required></div>
            </div>
            <div class="row">
                <div class="col"><label>Email:</label><input type="email" name="email"></div>
                <div class="col"><label>Số điện thoại:</label><input type="tel" name="dt"></div>
            </div>
            <div style="margin-bottom:14px;"><label>Địa chỉ nhận hàng:</label><input type="text" name="diachi"></div>
            <button type="submit">Đăng ký tài khoản</button>
        </form>
        <div class="footer">Đã có tài khoản? <a href="/gddangnhap4.jsp">Đăng nhập</a></div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_kh_chinh(self, user):
        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Giao diện chính khách hàng - GDCHINHKHACHHANG4</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 900px; margin: 60px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); text-align: center; }}
        h1 {{ color: #1e3c72; margin-bottom: 12px; font-size: 26px; }}
        p {{ color: #555; line-height: 1.6; margin-bottom: 30px; }}
        .btn-search {{ display: inline-block; padding: 16px 36px; background: #0088cc; color: #fff; text-decoration: none; font-size: 18px; font-weight: 600; border-radius: 8px; }}
        .info {{ margin-top: 35px; text-align: left; background: #f8f9fa; border-radius: 8px; padding: 20px; border-left: 4px solid #0088cc; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">CỬA HÀNG BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Xin chào, <strong>{user['hoten']}</strong> (Khách hàng) &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h1>GDCHINHKHACHHANG4</h1>
            <p>Chào mừng quý khách đến với hệ thống bách hóa trực tuyến. Bạn có thể tra cứu thông tin sản phẩm, kiểm tra giá, số lượng tồn kho và xem chi tiết mặt hàng.</p>
            <div><a href="/kh/gdtimmathang4.jsp" class="btn-search">Tìm kiếm mặt hàng</a></div>
            <div class="info">
                <h3>Thông tin tài khoản</h3>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:10px;font-size:14px;">
                    <div><strong>Họ tên:</strong> {user['hoten']}</div>
                    <div><strong>Email:</strong> {user['email'] or 'N/A'}</div>
                    <div><strong>Số điện thoại:</strong> {user['dt'] or 'N/A'}</div>
                    <div><strong>Địa chỉ:</strong> {user['diachi'] or 'N/A'}</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_kh_tim_mathang(self, user, tenMH):
        items = []
        if tenMH is not None:
            conn = get_db()
            cur = conn.cursor()
            cur.execute("""
            SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota
            FROM tblMatHang4 mh
            WHERE mh.ten LIKE ? ORDER BY mh.ten ASC
            """, (f"%{tenMH.strip()}%",))
            items = cur.fetchall()
            conn.close()

        table_rows = ""
        if tenMH is not None:
            if not items:
                table_rows = f'<tr><td colspan="7" style="text-align:center;padding:25px;color:#777;">Không tìm thấy mặt hàng nào khớp với từ khóa "{tenMH}"</td></tr>'
            else:
                for idx, row in enumerate(items, 1):
                    price_fmt = f"{int(row[4]):,}".replace(",", ".")
                    table_rows += f"""<tr>
                        <td style="text-align:center;">{idx}</td>
                        <td style="text-align:center;"><strong>{row[1]}</strong></td>
                        <td>{row[2]}</td>
                        <td style="text-align:center;">{row[3]}</td>
                        <td style="text-align:right;">{price_fmt}</td>
                        <td style="text-align:center;">{row[5]}</td>
                        <td style="text-align:center;"><a href="/kh/gdchitietmathang4.jsp?id={row[0]}" style="color:#0088cc;font-weight:600;">Xem chi tiết</a></td>
                    </tr>"""

        result_section = ""
        if tenMH is not None:
            result_section = f"""<table style="width:100%;border-collapse:collapse;margin-bottom:25px;">
                <thead>
                    <tr style="background:#f8f9fa;">
                        <th style="padding:10px;border:1px solid #dee2e6;">TT</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">Ma MH</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">Ten mat hang</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">DVT</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">Don gia</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">SL ton</th>
                        <th style="padding:10px;border:1px solid #dee2e6;">Thao tac</th>
                    </tr>
                </thead>
                <tbody>{table_rows}</tbody>
            </table>"""

        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Tim kiem mat hang (gdtimmathang4)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 1000px; margin: 40px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }}
        h2 {{ text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; margin-bottom: 25px; color: #1e3c72; }}
        .search-row {{ display: flex; justify-content: center; align-items: center; gap: 15px; margin-bottom: 30px; }}
        input[type="text"] {{ width: 300px; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; }}
        .btn-search {{ padding: 10px 24px; background: #0088cc; color: #fff; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }}
        .btn-home {{ display: inline-block; padding: 10px 24px; background: #e53935; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; }}
        td, th {{ border: 1px solid #dee2e6; padding: 12px; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">CỬA HÀNG BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Xin chào, <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h2>Tim kiem mat hang (gdtimmathang4)</h2>
            <form action="/kh/gdtimmathang4.jsp" method="GET" class="search-row">
                <label><strong>Ten mat hang:</strong></label>
                <input type="text" name="txtTenMH" value="{tenMH or ''}" placeholder="VD : sua" autofocus>
                <button type="submit" class="btn-search">Tìm kiếm</button>
            </form>
            {result_section}
            <div><a href="/kh/gdchinhkh4.jsp" class="btn-home">Ve trang chu</a></div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_kh_chitiet_mathang(self, user, item_id):
        conn = get_db()
        cur = conn.cursor()
        cur.execute("""
        SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota, lmh.ten
        FROM tblMatHang4 mh
        LEFT JOIN tblLoaiMatHang4 lmh ON mh.tblLoaiMatHang4id = lmh.id
        WHERE mh.id = ?
        """, (item_id,))
        row = cur.fetchone()
        conn.close()

        if row:
            price_fmt = f"{int(row[4]):,}".replace(",", ".") + " VND"
            detail_html = f"""<table style="width:100%;border-collapse:collapse;margin-bottom:25px;">
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;width:30%;text-align:left;">Ma mat hang:</th><td style="padding:12px;border:1px solid #dee2e6;"><strong>{row[1]}</strong></td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">Ten mat hang:</th><td style="padding:12px;border:1px solid #dee2e6;">{row[2]}</td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">Loai mat hang:</th><td style="padding:12px;border:1px solid #dee2e6;">{row[7] or 'N/A'}</td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">Don vi tinh:</th><td style="padding:12px;border:1px solid #dee2e6;">{row[3]}</td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">Don gia:</th><td style="padding:12px;border:1px solid #dee2e6;color:#e53935;font-weight:bold;">{price_fmt}</td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">So luong ton:</th><td style="padding:12px;border:1px solid #dee2e6;">{row[5]}</td></tr>
                <tr><th style="padding:12px;border:1px solid #dee2e6;background:#f8f9fa;text-align:left;">Mo ta:</th><td style="padding:12px;border:1px solid #dee2e6;">{row[6] or 'Chưa có mô tả'}</td></tr>
            </table>"""
        else:
            detail_html = '<p style="text-align:center;padding:30px;color:#777;">Không tìm thấy thông tin mặt hàng!</p>'

        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Thong tin chi tiet mat hang (gdchitietmathang4.jsp)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 800px; margin: 40px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }}
        h2 {{ text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; margin-bottom: 25px; color: #1e3c72; }}
        .btn-back {{ display: inline-block; padding: 10px 24px; background: #e53935; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">CỬA HÀNG BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Xin chào, <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h2>Thong tin chi tiet mat hang (gdchitietmathang4.jsp)</h2>
            {detail_html}
            <div><a href="/kh/gdtimmathang4.jsp" class="btn-back">quay lai</a></div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_ql_chinh(self, user):
        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Trang chu quan li (gdchinhql4.jsp)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 900px; margin: 60px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 45px 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); text-align: center; }}
        h1 {{ color: #203a43; margin-bottom: 12px; font-size: 26px; }}
        p {{ color: #555; line-height: 1.6; margin-bottom: 35px; }}
        .btn-stat {{ display: inline-block; padding: 16px 36px; background: #203a43; color: #fff; text-decoration: none; font-size: 18px; font-weight: 600; border-radius: 8px; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Quản lý: <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h1>Trang chu quan li (gdchinhql4.jsp)</h1>
            <p>Hệ thống hỗ trợ phân tích hiệu quả hoạt động kinh doanh, báo cáo khách hàng và doanh thu.</p>
            <div><a href="/ql/gdchontk4.jsp" class="btn-stat">Xem bao cao thong ke</a></div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_ql_chontk(self, user):
        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Chon loai thong ke (gdchontk4.jsp)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 650px; margin: 60px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 35px 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }}
        h2 {{ text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; color: #203a43; }}
        .row {{ display: flex; align-items: center; justify-content: center; gap: 15px; margin-bottom: 30px; }}
        select {{ width: 320px; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; }}
        .btn-view {{ padding: 10px 30px; background: #203a43; color: #fff; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }}
        .btn-back {{ padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Quản lý: <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h2>Chon loai thong ke (gdchontk4.jsp)</h2>
            <form action="/ql/gdtkkhachhang4.jsp" method="GET">
                <div class="row">
                    <label><strong>Loai TK:</strong></label>
                    <select name="slLoaiTK">
                        <option value="tk_kh_doanhthu" selected>TK khach hang theo doanh thu</option>
                    </select>
                </div>
                <div style="display:flex;justify-content:center;gap:15px;">
                    <button type="submit" class="btn-view">Xem</button>
                    <a href="/ql/gdchinhql4.jsp" class="btn-back">Quay lại</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_ql_tk_khachhang(self, user, ngayBD, ngayKT):
        conn = get_db()
        cur = conn.cursor()
        cur.execute("""
        SELECT tv.id, kh.makh, tv.hoten, COUNT(hd.id) AS tongsoHD, SUM(hd.tongtien) AS tongDoanhThu
        FROM tblHoaDon4 hd
        JOIN tblKhachHang4 kh ON hd.tblKhachHang4tblThanhVien4Id = kh.tblThanhVien4Id
        JOIN tblThanhVien4 tv ON kh.tblThanhVien4Id = tv.id
        WHERE hd.ngaylap >= ? AND hd.ngaylap <= ?
        GROUP BY tv.id, kh.makh, tv.hoten
        ORDER BY tongDoanhThu DESC
        """, (ngayBD, ngayKT))
        rows = cur.fetchall()
        conn.close()

        table_rows = ""
        if not rows:
            table_rows = '<tr><td colspan="5" style="text-align:center;padding:25px;color:#777;">Không có dữ liệu trong khoảng thời gian đã chọn!</td></tr>'
        else:
            for idx, r in enumerate(rows, 1):
                rev_fmt = f"{int(r[4]):,}".replace(",", ".")
                table_rows += f"""<tr>
                    <td style="text-align:center;">{idx}</td>
                    <td style="text-align:center;">{r[1]}</td>
                    <td><a href="/ql/gdchitietkh4.jsp?id={r[0]}&ngayBD={ngayBD}&ngayKT={ngayKT}" style="color:#0088cc;font-weight:600;text-decoration:underline;">{r[2]}</a></td>
                    <td style="text-align:center;">{r[3]}</td>
                    <td style="text-align:right;">{rev_fmt}</td>
                </tr>"""

        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Thong ke khach hang theo doanh thu (gdtkkhachhang4.jsp)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 950px; margin: 40px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }}
        h2 {{ text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; color: #203a43; }}
        .form-row {{ display: flex; justify-content: center; align-items: center; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; }}
        input[type="date"] {{ padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px; }}
        .btn-submit {{ padding: 9px 24px; background: #203a43; color: #fff; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }}
        table {{ width: 100%; border-collapse: collapse; margin-bottom: 25px; }}
        th, td {{ border: 1px solid #dee2e6; padding: 12px; }}
        th {{ background: #f8f9fa; }}
        .btn-back {{ display: inline-block; padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Quản lý: <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h2>Thong ke khach hang theo doanh thu (gdtkkhachhang4.jsp)</h2>
            <form action="/ql/gdtkkhachhang4.jsp" method="GET" class="form-row">
                <label>Ngay bat dau: <input type="date" name="inNgayBD" value="{ngayBD}"></label>
                <label>Ngay ket thuc: <input type="date" name="inNgayKT" value="{ngayKT}"></label>
                <button type="submit" class="btn-submit">Xem</button>
            </form>
            <table>
                <thead>
                    <tr>
                        <th style="width:60px;">TT</th>
                        <th style="width:120px;">Ma KH</th>
                        <th>Ho ten</th>
                        <th style="width:140px;">Tong so HD</th>
                        <th style="width:180px;">Tong doanh thu</th>
                    </tr>
                </thead>
                <tbody>{table_rows}</tbody>
            </table>
            <div><a href="/ql/gdchontk4.jsp" class="btn-back">Quay lai</a></div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

    def render_ql_chitiet_kh(self, user, cust_id, ngayBD, ngayKT):
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT tv.hoten, kh.makh, tv.dt, tv.email, tv.diachi FROM tblThanhVien4 tv JOIN tblKhachHang4 kh ON tv.id = kh.tblThanhVien4Id WHERE tv.id = ?", (cust_id,))
        cust = cur.fetchone()

        cur.execute("""
        SELECT hd.id, hd.mahd, hd.ngaylap, hd.trangthai, hd.tongtien
        FROM tblHoaDon4 hd
        WHERE hd.tblKhachHang4tblThanhVien4Id = ? AND hd.ngaylap >= ? AND hd.ngaylap <= ?
        ORDER BY hd.ngaylap DESC
        """, (cust_id, ngayBD, ngayKT))
        invoices = cur.fetchall()
        conn.close()

        total = sum(r[4] for r in invoices)
        total_fmt = f"{int(total):,}".replace(",", ".")

        table_rows = ""
        for idx, inv in enumerate(invoices, 1):
            date_obj = datetime.strptime(inv[2], "%Y-%m-%d")
            date_fmt = date_obj.strftime("%d/%m/%Y")
            money_fmt = f"{int(inv[4]):,}".replace(",", ".")
            table_rows += f"""<tr>
                <td style="text-align:center;">{idx}</td>
                <td style="text-align:center;"><strong>{inv[1]}</strong></td>
                <td style="text-align:center;">{date_fmt}</td>
                <td style="text-align:center;">{inv[3]}</td>
                <td style="text-align:right;">{money_fmt}</td>
            </tr>"""

        cust_block = ""
        if cust:
            cust_block = f"""<div style="background:#f8f9fa;border:1px solid #dee2e6;padding:15px;border-radius:6px;margin-bottom:20px;font-size:15px;line-height:1.8;">
                <div>Ma Kh: <strong>{cust[1]}</strong> &nbsp;&nbsp;&nbsp;&nbsp; Ho ten: <strong>{cust[0]}</strong></div>
                <div>SDT: {cust[2] or 'N/A'} &nbsp;&nbsp;&nbsp;&nbsp; Email: {cust[3] or 'N/A'}</div>
                <div>Dia chi: {cust[4] or 'N/A'}</div>
            </div>"""

        html = f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Chi tiet khach hang & Giao dich (gdchitietkh4.jsp)</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }}
        body {{ background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }}
        .nav {{ background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }}
        .btn-out {{ background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; }}
        .main {{ max-width: 950px; margin: 40px auto; padding: 0 20px; width: 100%; }}
        .card {{ background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }}
        h2 {{ text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 20px; color: #203a43; }}
        table {{ width: 100%; border-collapse: collapse; margin-bottom: 25px; }}
        th, td {{ border: 1px solid #dee2e6; padding: 12px; }}
        th {{ background: #f8f9fa; }}
        .total-row {{ background: #f1f3f5; font-weight: bold; }}
        .btn-back {{ display: inline-block; padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; }}
    </style>
</head>
<body>
    <div class="nav">
        <div style="font-size:20px;font-weight:700;">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div>Quản lý: <strong>{user['hoten']}</strong> &nbsp; <a href="/dodangxuat4.jsp" class="btn-out">Đăng xuất</a></div>
    </div>
    <div class="main">
        <div class="card">
            <h2>Chi tiet khach hang & Giao dich (gdchitietkh4.jsp)</h2>
            {cust_block}
            <table>
                <thead>
                    <tr>
                        <th style="width:60px;">TT</th>
                        <th style="width:140px;">Ma HD</th>
                        <th style="width:140px;">Ngay lap</th>
                        <th style="width:160px;">Trang thai</th>
                        <th style="width:180px;">Tong tien</th>
                    </tr>
                </thead>
                <tbody>
                    {table_rows}
                    <tr class="total-row">
                        <td></td><td></td><td></td>
                        <td style="text-align:right;">Tong cong:</td>
                        <td style="text-align:right;">{total_fmt}</td>
                    </tr>
                </tbody>
            </table>
            <div><a href="/ql/gdtkkhachhang4.jsp?inNgayBD={ngayBD}&inNgayKT={ngayKT}" class="btn-back">Quay lai</a></div>
        </div>
    </div>
</body>
</html>"""
        self.send_html(html)

def run():
    init_db()
    with socketserver.TCPServer(("", PORT), DepartmentStoreHandler) as httpd:
        print(f"============================================================")
        print(f"  HE THONG QUAN LY CUA HANG BACH HOA TRUC TUYEN (qlCuaHang4)")
        print(f"  Server dang chay tai: http://localhost:{PORT}")
        print(f"  Nhan Ctrl + C de dung server.")
        print(f"============================================================")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer da dung.")

if __name__ == "__main__":
    run()


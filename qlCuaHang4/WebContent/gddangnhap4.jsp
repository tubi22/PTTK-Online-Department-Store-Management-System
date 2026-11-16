<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ThanhVien4" %>
<%
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user != null) {
        if ("NVQuanLi".equalsIgnoreCase(user.getVaitro())) {
            response.sendRedirect(request.getContextPath() + "/ql/gdchinhql4.jsp");
            return;
        } else {
            response.sendRedirect(request.getContextPath() + "/kh/gdchinhkh4.jsp");
            return;
        }
    }
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = request.getParameter("error");
    }
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống - Cửa Hàng Bách Hóa Số 4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .login-card { background: #fff; width: 100%; max-width: 420px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
        .brand-header { text-align: center; margin-bottom: 25px; }
        .brand-header h2 { color: #1e3c72; font-size: 24px; margin-bottom: 6px; }
        .brand-header p { color: #666; font-size: 14px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #333; font-size: 14px; }
        .form-control { width: 100%; padding: 12px 14px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #2a5298; box-shadow: 0 0 0 3px rgba(42,82,152,0.15); }
        .btn-submit { width: 100%; padding: 12px; background: #0088cc; color: #fff; border: none; border-radius: 6px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: #006699; }
        .alert { padding: 10px 14px; border-radius: 6px; font-size: 14px; margin-bottom: 15px; }
        .alert-error { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
        .footer-links a { color: #0088cc; text-decoration: none; font-weight: 600; }
        .footer-links a:hover { text-decoration: underline; }
        .demo-accounts { background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 6px; padding: 12px; margin-top: 20px; font-size: 12px; color: #555; }
        .demo-accounts strong { display: block; margin-bottom: 4px; color: #333; }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="brand-header">
            <h2>HỆ THỐNG BÁCH HÓA</h2>
            <p>Đăng nhập tài khoản để tiếp tục</p>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/dodangnhap4.jsp" method="POST">
            <div class="form-group">
                <label for="username">Tên đăng nhập (Username):</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tên đăng nhập..." required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu (Password):</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu..." required>
            </div>
            <button type="submit" class="btn-submit">Đăng nhập</button>
        </form>

        <div class="footer-links">
            Chưa có tài khoản? <a href="<%= request.getContextPath() %>/gddangky4.jsp">Đăng ký ngay</a>
        </div>

        <div class="demo-accounts">
            <strong>Tài khoản mẫu từ cơ sở dữ liệu:</strong>
            • Quản lý: <code>quanly</code> / <code>123456</code><br>
            • Khách hàng: <code>an_nv</code> / <code>123456</code> (KH01)<br>
            • Khách hàng: <code>binh_tt</code> / <code>123456</code> (KH02)
        </div>
    </div>
</body>
</html>

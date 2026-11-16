<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản Khách Hàng</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .reg-card { background: #fff; width: 100%; max-width: 520px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
        .brand-header { text-align: center; margin-bottom: 25px; }
        .brand-header h2 { color: #1e3c72; font-size: 24px; margin-bottom: 6px; }
        .brand-header p { color: #666; font-size: 14px; }
        .form-row { display: flex; gap: 15px; }
        .form-group { margin-bottom: 16px; flex: 1; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #333; font-size: 13px; }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }
        .form-control:focus { outline: none; border-color: #2a5298; box-shadow: 0 0 0 3px rgba(42,82,152,0.15); }
        .btn-submit { width: 100%; padding: 12px; background: #28a745; color: #fff; border: none; border-radius: 6px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: #218838; }
        .alert-error { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; padding: 10px 14px; border-radius: 6px; font-size: 14px; margin-bottom: 15px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
        .footer-links a { color: #0088cc; text-decoration: none; font-weight: 600; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="reg-card">
        <div class="brand-header">
            <h2>ĐĂNG KÝ KHÁCH HÀNG</h2>
            <p>Tạo tài khoản thành viên để mua sắm trực tuyến</p>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert-error"><%= error %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/dodangky4.jsp" method="POST">
            <div class="form-row">
                <div class="form-group">
                    <label for="username">Tên đăng nhập (*):</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="vd: user123" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu (*):</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hoten">Họ và tên (*):</label>
                    <input type="text" id="hoten" name="hoten" class="form-control" placeholder="Nguyễn Văn A" required>
                </div>
                <div class="form-group">
                    <label for="makh">Mã khách hàng (*):</label>
                    <input type="text" id="makh" name="makh" class="form-control" placeholder="KH..." required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="email@gmail.com">
                </div>
                <div class="form-group">
                    <label for="dt">Số điện thoại:</label>
                    <input type="tel" id="dt" name="dt" class="form-control" placeholder="09xxxxxxxx">
                </div>
            </div>

            <div class="form-group">
                <label for="diachi">Địa chỉ nhận hàng:</label>
                <input type="text" id="diachi" name="diachi" class="form-control" placeholder="Số nhà, đường, quận/huyện...">
            </div>

            <button type="submit" class="btn-submit">Đăng ký tài khoản</button>
        </form>

        <div class="footer-links">
            Đã có tài khoản? <a href="<%= request.getContextPath() %>/gddangnhap4.jsp">Đăng nhập</a>
        </div>
    </div>
</body>
</html>


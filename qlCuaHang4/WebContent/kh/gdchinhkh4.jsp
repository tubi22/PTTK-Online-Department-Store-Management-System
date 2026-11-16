<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ThanhVien4" %>
<%
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giao diện chính khách hàng - GDCHINHKHACHHANG4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .navbar-brand { font-size: 20px; font-weight: 700; letter-spacing: 0.5px; }
        .navbar-user { display: flex; align-items: center; gap: 20px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 7px 14px; border-radius: 4px; text-decoration: none; font-weight: 600; font-size: 13px; transition: background 0.2s; }
        .btn-logout:hover { background: #bd2130; }
        .container { flex: 1; max-width: 900px; margin: 60px auto; padding: 0 20px; width: 100%; }
        .welcome-box { background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; border: 1px solid #e1e4e8; }
        .welcome-box h1 { color: #1e3c72; font-size: 26px; margin-bottom: 12px; }
        .welcome-box p { color: #555; font-size: 15px; margin-bottom: 30px; line-height: 1.6; }
        .action-container { display: flex; justify-content: center; gap: 20px; }
        .btn-action { display: inline-block; padding: 16px 36px; background: #0088cc; color: #fff; text-decoration: none; font-size: 18px; font-weight: 600; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,136,204,0.3); transition: all 0.2s; }
        .btn-action:hover { background: #0070a8; transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,136,204,0.4); }
        .user-info-card { margin-top: 35px; text-align: left; background: #f8f9fa; border-radius: 8px; padding: 20px; border-left: 4px solid #0088cc; }
        .user-info-card h3 { font-size: 16px; margin-bottom: 10px; color: #333; }
        .user-info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 14px; color: #555; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">CỬA HÀNG BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div class="navbar-user">
            <span>Xin chào, <strong><%= user.getHoten() %></strong> (Khách hàng)</span>
            <a href="<%= request.getContextPath() %>/dodangxuat4.jsp" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-box">
            <h1>GDCHINHKHACHHANG4</h1>
            <p>Chào mừng quý khách đến với hệ thống bách hóa trực tuyến. Bạn có thể tra cứu thông tin sản phẩm, kiểm tra giá, số lượng tồn kho và xem chi tiết mặt hàng tại đây.</p>

            <div class="action-container">
                <a href="<%= request.getContextPath() %>/kh/gdtimmathang4.jsp" class="btn-action">Tìm kiếm mặt hàng</a>
            </div>

            <div class="user-info-card">
                <h3>Thông tin tài khoản</h3>
                <div class="user-info-grid">
                    <div><strong>Họ và tên:</strong> <%= user.getHoten() %></div>
                    <div><strong>Email:</strong> <%= user.getEmail() != null ? user.getEmail() : "Chưa cập nhật" %></div>
                    <div><strong>Điện thoại:</strong> <%= user.getDt() != null ? user.getDt() : "Chưa cập nhật" %></div>
                    <div><strong>Địa chỉ:</strong> <%= user.getDiachi() != null ? user.getDiachi() : "Chưa cập nhật" %></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ThanhVien4" %>
<%
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user == null || !"NVQuanLi".equalsIgnoreCase(user.getVaitro())) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập với quyền Quản lý!", "UTF-8"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ quản lí - gdchinhql4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: #0f2027; background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar-brand { font-size: 20px; font-weight: 700; letter-spacing: 0.5px; }
        .navbar-user { display: flex; align-items: center; gap: 20px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 7px 14px; border-radius: 4px; text-decoration: none; font-weight: 600; font-size: 13px; transition: background 0.2s; }
        .btn-logout:hover { background: #bd2130; }
        .container { flex: 1; max-width: 900px; margin: 60px auto; padding: 0 20px; width: 100%; }
        .dashboard-box { background: #fff; padding: 45px 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); text-align: center; border: 1px solid #e1e4e8; }
        .dashboard-box h1 { color: #203a43; font-size: 26px; margin-bottom: 12px; }
        .dashboard-box p { color: #555; font-size: 15px; margin-bottom: 35px; line-height: 1.6; }
        .action-container { display: flex; justify-content: center; gap: 20px; }
        .btn-action { display: inline-block; padding: 16px 36px; background: #203a43; color: #fff; text-decoration: none; font-size: 18px; font-weight: 600; border-radius: 8px; box-shadow: 0 4px 12px rgba(32,58,67,0.3); transition: all 0.2s; }
        .btn-action:hover { background: #2c5364; transform: translateY(-2px); box-shadow: 0 6px 16px rgba(32,58,67,0.4); }
        .manager-info { margin-top: 40px; text-align: left; background: #f8f9fa; border-radius: 8px; padding: 20px; border-left: 4px solid #203a43; }
        .manager-info h3 { font-size: 16px; margin-bottom: 12px; color: #333; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; font-size: 14px; color: #555; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div class="navbar-user">
            <span>Quản trị viên: <strong><%= user.getHoten() %></strong> (NVQuanLi)</span>
            <a href="<%= request.getContextPath() %>/dodangxuat4.jsp" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="dashboard-box">
            <h1>Trang chu quan li (gdchinhql4.jsp)</h1>
            <p>Phân hệ dành riêng cho Nhân viên Quản lý. Tại đây bạn có thể theo dõi và kết xuất các báo cáo doanh số, thống kê hoạt động kinh doanh và hiệu quả bán hàng của cửa hàng.</p>

            <div class="action-container">
                <a href="<%= request.getContextPath() %>/ql/gdchontk4.jsp" class="btn-action">Xem bao cao thong ke</a>
            </div>

            <div class="manager-info">
                <h3>Thông tin nhân viên quản lý</h3>
                <div class="info-grid">
                    <div><strong>Họ và tên:</strong> <%= user.getHoten() %></div>
                    <div><strong>Tài khoản:</strong> <%= user.getUsername() %></div>
                    <div><strong>Vai trò:</strong> Quản lý hệ thống (<%= user.getVaitro() %>)</div>
                    <div><strong>Email:</strong> <%= user.getEmail() != null ? user.getEmail() : "N/A" %></div>
                    <div><strong>Điện thoại:</strong> <%= user.getDt() != null ? user.getDt() : "N/A" %></div>
                    <div><strong>Địa chỉ:</strong> <%= user.getDiachi() != null ? user.getDiachi() : "N/A" %></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

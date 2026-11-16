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
    <title>Chon loai thong ke - gdchontk4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 20px; font-weight: 700; }
        .navbar-user { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        .container { flex: 1; max-width: 650px; margin: 60px auto; padding: 0 20px; width: 100%; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); padding: 35px 30px; }
        .card-header { text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; }
        .card-header h2 { color: #203a43; font-size: 22px; }
        .form-group { display: flex; align-items: center; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .form-group label { font-weight: 600; color: #333; font-size: 15px; }
        .form-select { width: 320px; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; background: #fff; }
        .form-select:focus { outline: none; border-color: #203a43; }
        .btn-group { display: flex; justify-content: center; gap: 15px; }
        .btn-view { padding: 10px 30px; background: #203a43; color: #fff; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-view:hover { background: #2c5364; }
        .btn-back { padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-size: 15px; font-weight: 600; transition: background 0.2s; }
        .btn-back:hover { background: #5a6268; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">HỆ THỐNG QUẢN TRỊ BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div class="navbar-user">
            <span>Quản lý: <strong><%= user.getHoten() %></strong></span>
            <a href="<%= request.getContextPath() %>/dodangxuat4.jsp" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <div class="card-header">
                <h2>Chon loai thong ke (gdchontk4.jsp)</h2>
            </div>

            <form action="<%= request.getContextPath() %>/ql/gdtkkhachhang4.jsp" method="GET">
                <div class="form-group">
                    <label for="slLoaiTK">Loai TK:</label>
                    <select id="slLoaiTK" name="slLoaiTK" class="form-select">
                        <option value="tk_kh_doanhthu" selected>TK khach hang theo doanh thu</option>
                    </select>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-view">Xem</button>
                    <a href="<%= request.getContextPath() %>/ql/gdchinhql4.jsp" class="btn-back">Quay lại</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

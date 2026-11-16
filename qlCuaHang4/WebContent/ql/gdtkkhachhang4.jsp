<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.ThanhVien4" %>
<%@ page import="model.TKKhachHang4" %>
<%@ page import="dao.TKKhachHangDAO4" %>
<%
    request.setCharacterEncoding("UTF-8");
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user == null || !"NVQuanLi".equalsIgnoreCase(user.getVaitro())) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập với quyền Quản lý!", "UTF-8"));
        return;
    }

    String ngayBDStr = request.getParameter("inNgayBD");
    String ngayKTStr = request.getParameter("inNgayKT");

    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,###");

    // Mặc định tháng 11/2026 theo kịch bản bài tập
    if (ngayBDStr == null || ngayBDStr.trim().isEmpty()) {
        ngayBDStr = "2026-11-01";
    }
    if (ngayKTStr == null || ngayKTStr.trim().isEmpty()) {
        ngayKTStr = "2026-11-30";
    }

    Date ngayBD = null;
    Date ngayKT = null;
    ArrayList<TKKhachHang4> listTKKH = null;

    try {
        ngayBD = sdfInput.parse(ngayBDStr.trim());
        ngayKT = sdfInput.parse(ngayKTStr.trim());
        TKKhachHangDAO4 dao = new TKKhachHangDAO4();
        listTKKH = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê khách hàng theo doanh thu - gdtkkhachhang4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: linear-gradient(to right, #2c5364, #203a43, #0f2027); color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 20px; font-weight: 700; }
        .navbar-user { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        .container { flex: 1; max-width: 950px; margin: 40px auto; padding: 0 20px; width: 100%; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); padding: 30px; }
        .card-header { text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; }
        .card-header h2 { color: #203a43; font-size: 22px; text-transform: uppercase; }
        .filter-form { display: flex; justify-content: center; align-items: center; gap: 20px; flex-wrap: wrap; margin-bottom: 30px; }
        .form-item { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 600; color: #333; }
        .form-control { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; }
        .form-control:focus { outline: none; border-color: #203a43; }
        .btn-submit { padding: 9px 24px; background: #203a43; color: #fff; border: none; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-submit:hover { background: #2c5364; }
        .table-responsive { width: 100%; overflow-x: auto; margin-bottom: 25px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 12px 14px; border: 1px solid #dee2e6; font-size: 14px; }
        th { background: #f8f9fa; color: #333; font-weight: 600; text-align: center; }
        tr:hover { background: #f9fbfd; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .kh-link { color: #0088cc; font-weight: 600; text-decoration: underline; cursor: pointer; }
        .kh-link:hover { color: #005580; }
        .btn-back { display: inline-block; padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background 0.2s; }
        .btn-back:hover { background: #5a6268; }
        .no-data { text-align: center; padding: 30px; color: #777; font-style: italic; }
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
                <h2>Thong ke khach hang theo doanh thu (gdtkkhachhang4.jsp)</h2>
            </div>

            <form action="<%= request.getContextPath() %>/ql/gdtkkhachhang4.jsp" method="GET" class="filter-form">
                <div class="form-item">
                    <label for="inNgayBD">Ngay bat dau:</label>
                    <input type="date" id="inNgayBD" name="inNgayBD" class="form-control" value="<%= ngayBDStr %>" required>
                </div>
                <div class="form-item">
                    <label for="inNgayKT">Ngay ket thuc:</label>
                    <input type="date" id="inNgayKT" name="inNgayKT" class="form-control" value="<%= ngayKTStr %>" required>
                </div>
                <button type="submit" class="btn-submit">Xem</button>
            </form>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 60px;">TT</th>
                            <th style="width: 120px;">Ma KH</th>
                            <th>Ho ten</th>
                            <th style="width: 140px;">Tong so HD</th>
                            <th style="width: 180px;">Tong doanh thu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listTKKH == null || listTKKH.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="no-data">Không có dữ liệu hóa đơn nào phát sinh trong khoảng thời gian đã chọn!</td>
                            </tr>
                        <% } else {
                            int stt = 1;
                            for (TKKhachHang4 tk : listTKKH) {
                        %>
                            <tr>
                                <td class="text-center"><%= stt++ %></td>
                                <td class="text-center"><strong><%= tk.getMakh() %></strong></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/ql/gdchitietkh4.jsp?id=<%= tk.getId() %>&ngayBD=<%= ngayBDStr %>&ngayKT=<%= ngayKTStr %>" class="kh-link">
                                        <%= tk.getHoten() %>
                                    </a>
                                </td>
                                <td class="text-center"><%= tk.getTongsoHD() %></td>
                                <td class="text-right"><strong><%= df.format(tk.getTongDoanhThu()) %></strong></td>
                            </tr>
                        <%  }
                           } %>
                    </tbody>
                </table>
            </div>

            <div>
                <a href="<%= request.getContextPath() %>/ql/gdchontk4.jsp" class="btn-back">Quay lại</a>
            </div>
        </div>
    </div>
</body>
</html>

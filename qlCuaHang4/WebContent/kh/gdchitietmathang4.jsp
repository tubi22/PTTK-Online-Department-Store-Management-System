<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.ThanhVien4" %>
<%@ page import="model.MatHang4" %>
<%@ page import="dao.MatHangDAO4" %>
<%
    request.setCharacterEncoding("UTF-8");
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
        return;
    }

    String idStr = request.getParameter("id");
    MatHang4 mh = null;
    if (idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr.trim());
            MatHangDAO4 dao = new MatHangDAO4();
            mh = dao.getChiTietMatHang(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    DecimalFormat df = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin chi tiết mặt hàng - gdchitietmathang4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 20px; font-weight: 700; }
        .navbar-user { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        .container { flex: 1; max-width: 800px; margin: 40px auto; padding: 0 20px; width: 100%; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); padding: 30px; }
        .card-header { text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; }
        .card-header h2 { color: #1e3c72; font-size: 22px; text-transform: uppercase; }
        .detail-table { width: 100%; border-collapse: collapse; margin-bottom: 25px; }
        .detail-table th, .detail-table td { padding: 14px 18px; border: 1px solid #dee2e6; font-size: 15px; }
        .detail-table th { width: 30%; background: #f8f9fa; color: #333; font-weight: 600; text-align: left; }
        .detail-table td { color: #444; }
        .btn-back { display: inline-block; padding: 10px 24px; background: #e53935; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background 0.2s; }
        .btn-back:hover { background: #c62828; }
        .no-data { text-align: center; padding: 30px; color: #777; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">CỬA HÀNG BÁCH HÓA TRỰC TUYẾN SỐ 4</div>
        <div class="navbar-user">
            <span>Xin chào, <strong><%= user.getHoten() %></strong></span>
            <a href="<%= request.getContextPath() %>/dodangxuat4.jsp" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <div class="card-header">
                <h2>Thông tin chi tiết mặt hàng (gdchitietmathang4.jsp)</h2>
            </div>

            <% if (mh != null) { %>
                <table class="detail-table">
                    <tr>
                        <th>Mã mặt hàng:</th>
                        <td><strong><%= mh.getMamh() %></strong></td>
                    </tr>
                    <tr>
                        <th>Tên mặt hàng:</th>
                        <td><%= mh.getTen() %></td>
                    </tr>
                    <tr>
                        <th>Loại mặt hàng:</th>
                        <td><%= (mh.getLoaiMH() != null) ? mh.getLoaiMH().getTen() : "Không xác định" %></td>
                    </tr>
                    <tr>
                        <th>Đơn vị tính:</th>
                        <td><%= mh.getDonvitinh() %></td>
                    </tr>
                    <tr>
                        <th>Đơn giá:</th>
                        <td><strong style="color: #e53935; font-size: 17px;"><%= df.format(mh.getDongia()) %> VND</strong></td>
                    </tr>
                    <tr>
                        <th>Số lượng tồn:</th>
                        <td><%= mh.getSoluongton() %></td>
                    </tr>
                    <tr>
                        <th>Mô tả:</th>
                        <td><%= mh.getMota() != null && !mh.getMota().isEmpty() ? mh.getMota() : "Không có mô tả chi tiết" %></td>
                    </tr>
                </table>
            <% } else { %>
                <div class="no-data">
                    <p>Không tìm thấy thông tin mặt hàng yêu cầu!</p>
                </div>
            <% } %>

            <div>
                <a href="<%= request.getContextPath() %>/kh/gdtimmathang4.jsp" class="btn-back">quay lại</a>
            </div>
        </div>
    </div>
</body>
</html>


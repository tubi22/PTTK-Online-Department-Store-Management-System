<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.ThanhVien4" %>
<%@ page import="model.HoaDon4" %>
<%@ page import="model.KhachHang4" %>
<%@ page import="dao.HoaDonDAO4" %>
<%
    request.setCharacterEncoding("UTF-8");
    ThanhVien4 user = (ThanhVien4) session.getAttribute("user");
    if (user == null || !"NVQuanLi".equalsIgnoreCase(user.getVaitro())) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập với quyền Quản lý!", "UTF-8"));
        return;
    }

    String idStr = request.getParameter("id");
    String ngayBDStr = request.getParameter("ngayBD");
    String ngayKTStr = request.getParameter("ngayKT");

    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,###");

    Date ngayBD = null;
    Date ngayKT = null;
    int idKH = -1;
    ArrayList<HoaDon4> listHD = null;
    KhachHang4 khInfo = null;
    float tongCong = 0;

    if (idStr != null && !idStr.trim().isEmpty()) {
        try {
            idKH = Integer.parseInt(idStr.trim());
            if (ngayBDStr != null && !ngayBDStr.trim().isEmpty()) {
                ngayBD = sdfInput.parse(ngayBDStr.trim());
            }
            if (ngayKTStr != null && !ngayKTStr.trim().isEmpty()) {
                ngayKT = sdfInput.parse(ngayKTStr.trim());
            }

            HoaDonDAO4 dao = new HoaDonDAO4();
            listHD = dao.getHoaDonCuaKH(idKH, ngayBD, ngayKT);

            if (listHD != null && !listHD.isEmpty()) {
                khInfo = listHD.get(0).getKh();
                for (HoaDon4 hd : listHD) {
                    tongCong += hd.getTongtien();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khách hàng & Giao dịch - gdchitietkh4</title>
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
        .card-header h2 { color: #203a43; font-size: 22px; }
        .customer-info-box { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin-bottom: 25px; }
        .info-row { display: flex; flex-wrap: wrap; gap: 30px; margin-bottom: 12px; font-size: 15px; }
        .info-row:last-child { margin-bottom: 0; }
        .info-item { flex: 1; min-width: 250px; }
        .info-label { font-weight: 600; color: #333; }
        .table-responsive { width: 100%; overflow-x: auto; margin-bottom: 25px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 12px 14px; border: 1px solid #dee2e6; font-size: 14px; }
        th { background: #f8f9fa; color: #333; font-weight: 600; text-align: center; }
        tr:hover { background: #f9fbfd; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .total-row { background: #f1f3f5; font-weight: bold; }
        .total-row td { border-top: 2px solid #ced4da; }
        .btn-back { display: inline-block; padding: 10px 24px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background 0.2s; }
        .btn-back:hover { background: #5a6268; }
        .no-data { text-align: center; padding: 30px; color: #777; }
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
                <h2>Chi tiet khach hang & Giao dich (gdchitietkh4.jsp)</h2>
            </div>

            <% if (khInfo != null) { %>
                <div class="customer-info-box">
                    <div class="info-row">
                        <div class="info-item"><span class="info-label">Ma Kh:</span> <%= khInfo.getMakh() %></div>
                        <div class="info-item"><span class="info-label">Ho ten:</span> <%= khInfo.getHoten() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-item"><span class="info-label">SDT:</span> <%= khInfo.getDt() != null ? khInfo.getDt() : "N/A" %></div>
                        <div class="info-item"><span class="info-label">Email:</span> <%= khInfo.getEmail() != null ? khInfo.getEmail() : "N/A" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-item"><span class="info-label">Dia chi:</span> <%= khInfo.getDiachi() != null ? khInfo.getDiachi() : "N/A" %></div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 60px;">TT</th>
                                <th style="width: 140px;">Ma HD</th>
                                <th style="width: 140px;">Ngay lap</th>
                                <th style="width: 160px;">Trang thai</th>
                                <th style="width: 180px;">Tong tien</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int stt = 1;
                                for (HoaDon4 hd : listHD) {
                            %>
                                <tr>
                                    <td class="text-center"><%= stt++ %></td>
                                    <td class="text-center"><strong><%= hd.getMahd() %></strong></td>
                                    <td class="text-center"><%= hd.getNgaylap() != null ? sdfDisplay.format(hd.getNgaylap()) : "" %></td>
                                    <td class="text-center"><%= hd.getTrangthai() %></td>
                                    <td class="text-right"><%= df.format(hd.getTongtien()) %></td>
                                </tr>
                            <% } %>
                            <tr class="total-row">
                                <td></td>
                                <td></td>
                                <td></td>
                                <td class="text-right"><strong>Tong cong:</strong></td>
                                <td class="text-right"><strong><%= df.format(tongCong) %></strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-data">
                    <p>Không tìm thấy thông tin khách hàng hoặc không có hóa đơn trong khoảng thời gian này!</p>
                </div>
            <% } %>

            <div>
                <a href="<%= request.getContextPath() %>/ql/gdtkkhachhang4.jsp?inNgayBD=<%= ngayBDStr != null ? ngayBDStr : "" %>&inNgayKT=<%= ngayKTStr != null ? ngayKTStr : "" %>" class="btn-back">Quay lại</a>
            </div>
        </div>
    </div>
</body>
</html>

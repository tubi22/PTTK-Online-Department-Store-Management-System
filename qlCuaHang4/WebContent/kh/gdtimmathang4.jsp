<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
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

    String tenMH = request.getParameter("txtTenMH");
    ArrayList<MatHang4> listMH = null;
    MatHangDAO4 dao = new MatHangDAO4();

    if (tenMH != null) {
        listMH = dao.timMatHangTheoTen(tenMH);
    }
    DecimalFormat df = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm mặt hàng - gdtimmathang4</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f4f6f9; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: #1e3c72; color: #fff; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 20px; font-weight: 700; }
        .navbar-user { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .btn-logout { background: #dc3545; color: #fff; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        .container { flex: 1; max-width: 1000px; margin: 40px auto; padding: 0 20px; width: 100%; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); padding: 30px; }
        .card-header { text-align: center; border-bottom: 2px solid #eef2f5; padding-bottom: 18px; margin-bottom: 25px; }
        .card-header h2 { color: #1e3c72; font-size: 22px; text-transform: uppercase; }
        .search-box { display: flex; justify-content: center; align-items: center; gap: 15px; margin-bottom: 30px; }
        .search-box label { font-weight: 600; color: #333; font-size: 15px; }
        .search-box input[type="text"] { width: 320px; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; }
        .search-box input[type="text"]:focus { outline: none; border-color: #0088cc; box-shadow: 0 0 0 3px rgba(0,136,204,0.15); }
        .btn-search { padding: 10px 24px; background: #0088cc; color: #fff; border: none; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-search:hover { background: #0070a8; }
        .table-responsive { width: 100%; overflow-x: auto; margin-bottom: 25px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 12px 14px; border: 1px solid #dee2e6; font-size: 14px; }
        th { background: #f8f9fa; color: #333; font-weight: 600; text-align: center; }
        tr:hover { background: #f9fbfd; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .action-link { color: #0088cc; text-decoration: none; font-weight: 600; }
        .action-link:hover { text-decoration: underline; }
        .btn-home { display: inline-block; padding: 10px 24px; background: #e53935; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background 0.2s; }
        .btn-home:hover { background: #c62828; }
        .no-data { text-align: center; padding: 30px; color: #777; font-style: italic; }
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
                <h2>Tìm kiếm mặt hàng (gdtimmathang4)</h2>
            </div>

            <form action="<%= request.getContextPath() %>/kh/gdtimmathang4.jsp" method="GET" class="search-box">
                <label for="txtTenMH">Tên mặt hàng:</label>
                <input type="text" id="txtTenMH" name="txtTenMH" value="<%= tenMH != null ? tenMH : "" %>" placeholder="VD : sữa" autofocus>
                <button type="submit" class="btn-search">Tìm kiếm</button>
            </form>

            <% if (listMH != null) { %>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">TT</th>
                                <th style="width: 100px;">Mã MH</th>
                                <th>Tên mặt hàng</th>
                                <th style="width: 90px;">ĐVT</th>
                                <th style="width: 120px;">Đơn giá</th>
                                <th style="width: 90px;">SL tồn</th>
                                <th style="width: 130px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listMH.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="no-data">Không tìm thấy mặt hàng nào phù hợp với từ khóa "<%= tenMH %>"</td>
                                </tr>
                            <% } else {
                                int stt = 1;
                                for (MatHang4 mh : listMH) {
                            %>
                                <tr>
                                    <td class="text-center"><%= stt++ %></td>
                                    <td class="text-center"><strong><%= mh.getMamh() %></strong></td>
                                    <td><%= mh.getTen() %></td>
                                    <td class="text-center"><%= mh.getDonvitinh() %></td>
                                    <td class="text-right"><%= df.format(mh.getDongia()) %> đ</td>
                                    <td class="text-center"><%= mh.getSoluongton() %></td>
                                    <td class="text-center">
                                        <a href="<%= request.getContextPath() %>/kh/gdchitietmathang4.jsp?id=<%= mh.getId() %>" class="action-link">Xem chi tiết</a>
                                    </td>
                                </tr>
                            <%  }
                               } %>
                        </tbody>
                    </table>
                </div>
            <% } %>

            <div>
                <a href="<%= request.getContextPath() %>/kh/gdchinhkh4.jsp" class="btn-home">Về trang chủ</a>
            </div>
        </div>
    </div>
</body>
</html>

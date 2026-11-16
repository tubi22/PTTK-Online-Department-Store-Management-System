<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ThanhVien4" %>
<%@ page import="model.KhachHang4" %>
<%@ page import="dao.ThanhVienDAO4" %>
<%
    request.setCharacterEncoding("UTF-8");
    String u = request.getParameter("username");
    String p = request.getParameter("password");
    String hoten = request.getParameter("hoten");
    String makh = request.getParameter("makh");
    String email = request.getParameter("email");
    String dt = request.getParameter("dt");
    String diachi = request.getParameter("diachi");

    if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() ||
        hoten == null || hoten.trim().isEmpty() || makh == null || makh.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/gddangky4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng nhập đầy đủ các trường bắt buộc (*)", "UTF-8"));
        return;
    }

    ThanhVien4 tv = new ThanhVien4();
    tv.setUsername(u.trim());
    tv.setPassword(p.trim());
    tv.setHoten(hoten.trim());
    tv.setEmail(email != null ? email.trim() : "");
    tv.setDt(dt != null ? dt.trim() : "");
    tv.setDiachi(diachi != null ? diachi.trim() : "");
    tv.setVaitro("KhachHang");

    KhachHang4 kh = new KhachHang4();
    kh.setMakh(makh.trim());

    ThanhVienDAO4 dao = new ThanhVienDAO4();
    boolean ok = dao.dangKy(tv, kh);

    if (ok) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?message=" + java.net.URLEncoder.encode("Đăng ký thành công! Vui lòng đăng nhập với tài khoản vừa tạo.", "UTF-8"));
    } else {
        response.sendRedirect(request.getContextPath() + "/gddangky4.jsp?error=" + java.net.URLEncoder.encode("Tên đăng nhập hoặc Mã khách hàng đã tồn tại trên hệ thống!", "UTF-8"));
    }
%>

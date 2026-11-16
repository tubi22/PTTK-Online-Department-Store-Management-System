<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ThanhVien4" %>
<%@ page import="dao.ThanhVienDAO4" %>
<%
    request.setCharacterEncoding("UTF-8");
    String u = request.getParameter("username");
    String p = request.getParameter("password");

    if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Vui lòng điền đầy đủ tên đăng nhập và mật khẩu!", "UTF-8"));
        return;
    }

    ThanhVien4 tv = new ThanhVien4();
    tv.setUsername(u.trim());
    tv.setPassword(p.trim());

    ThanhVienDAO4 dao = new ThanhVienDAO4();
    boolean ok = dao.kiemTraDangNhap(tv);

    if (ok) {
        session.setAttribute("user", tv);
        if ("NVQuanLi".equalsIgnoreCase(tv.getVaitro())) {
            response.sendRedirect(request.getContextPath() + "/ql/gdchinhql4.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/kh/gdchinhkh4.jsp");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?error=" + java.net.URLEncoder.encode("Sai tên đăng nhập hoặc mật khẩu! Vui lòng thử lại.", "UTF-8"));
    }
%>


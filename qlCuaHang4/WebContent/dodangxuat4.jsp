<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect(request.getContextPath() + "/gddangnhap4.jsp?message=" + java.net.URLEncoder.encode("Đã đăng xuất an toàn khỏi hệ thống.", "UTF-8"));
%>


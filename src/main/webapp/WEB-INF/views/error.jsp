<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Error | Codegnan E-Commerce" scope="request"/>
<jsp:include page="header.jsp" />

<div class="container py-5 text-center" style="max-width: 640px;">
    <div class="display-6 fw-bold mb-2">${not empty status ? status : 'Error'}</div>
    <h1 class="h4 fw-bold mb-3"><c:out value="${not empty errorTitle ? errorTitle : 'Something went wrong'}"/></h1>
    <p class="text-muted mb-4"><c:out value="${not empty errorMessage ? errorMessage : 'An unexpected error occurred.'}"/></p>
    <a href="/products" class="btn btn-primary">Back to products</a>
</div>

<jsp:include page="footer.jsp" />

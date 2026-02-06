<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Test Servlet Access</title></head>
<body>
    <h1>Test if AuthServlet is reachable</h1>
    
    <h2>Test 1: Direct Link to Auth Servlet</h2>
    <a href="${pageContext.request.contextPath}/auth/login">Test GET /auth/login</a>
    
    <h2>Test 2: Simple Form</h2>
    <form action="${pageContext.request.contextPath}/auth/login" method="POST">
        <input type="hidden" name="test" value="true">
        <button type="submit">Test POST to /auth/login</button>
    </form>
    
    <h2>Test 3: With Credentials</h2>
    <form action="${pageContext.request.contextPath}/auth/login" method="POST">
        Username: <input type="text" name="username" value="admin"><br>
        Password: <input type="password" name="password" value="admin123"><br>
        <button type="submit">Test Login</button>
    </form>
    
    <p>Check Tomcat logs for "AuthController.doPost() called"</p>
</body>
</html>

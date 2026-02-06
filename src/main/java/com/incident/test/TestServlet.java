package com.incident.test;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class TestServlet extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        System.out.println("=== TestServlet INIT called successfully! ===");
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        out.println("<html><body>");
        out.println("<h1>Test Servlet WORKS!</h1>");
        out.println("<p>If you see this, servlets are loading correctly.</p>");
        out.println("<p>Timestamp: " + new java.util.Date() + "</p>");
        out.println("</body></html>");
        out.close();
    }
}
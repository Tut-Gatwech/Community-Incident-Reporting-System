package com.incident.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class DashboardController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>DashboardController Works!</h1>");
        out.println("<p>Simple version - working</p>");
        out.println("</body></html>");
        out.close();
    }
}
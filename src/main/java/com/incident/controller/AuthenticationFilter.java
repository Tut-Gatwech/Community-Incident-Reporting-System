package com.incident.controller;

import com.incident.model.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Check if user is trying to access a protected resource
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String userRole = user.getRole();
        
        // Check role-based access control
        if (requestURI.startsWith(contextPath + "/admin/") && !userRole.equals("ADMIN")) {
            httpResponse.sendRedirect(contextPath + "/access-denied.jsp");
            return;
        }
        
        if (requestURI.startsWith(contextPath + "/officer/") && !userRole.equals("OFFICER")) {
            httpResponse.sendRedirect(contextPath + "/access-denied.jsp");
            return;
        }
        
        if (requestURI.startsWith(contextPath + "/citizen/") && !userRole.equals("CITIZEN")) {
            httpResponse.sendRedirect(contextPath + "/access-denied.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}

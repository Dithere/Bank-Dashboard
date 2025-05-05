package cop;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class register extends HttpServlet {
    private static final long serialVersionUID = 1L;  // Add serialVersionUID

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        data myData = new dataimp();
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");

        // Input validation
        if(username == null || username.trim().isEmpty() || 
           password == null || password.trim().isEmpty()) {
            resp.sendRedirect("index2.jsp?error=3");  // Empty fields error
            return;
        }

        user user = new user();
        user.setUsername(username);
        user.setPassword(password);

        try {
            if(!password.equals(repassword)) {
                resp.sendRedirect("index2.jsp?error=2");  // Password mismatch
            } else if (myData.addUser(user)) {
                resp.sendRedirect("index.jsp?registration=success");
            } else {
                resp.sendRedirect("index2.jsp?error=1");  // Registration failed
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("index2.jsp?error=4");  // Server error
        }
    }
}

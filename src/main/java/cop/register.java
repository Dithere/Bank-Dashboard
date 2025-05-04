package cop;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/register")
public class register extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		data myData = new dataimp(); 
		// TODO Auto-generated method stub
		String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        String repassword = req.getParameter("repassword");

        user user = new user();
        user.setUsername(username);
        
        user.setPassword(password);

        //UserDao userDao = new UserDaoImpl();
        if(password.equals(repassword)) {
        	if (myData.addUser(user)) {
                resp.sendRedirect("index.jsp?registration=success");
            } else {
                resp.sendRedirect("index2.jsp?error=1");
            }
        }
        else {
        	resp.sendRedirect("index2.jsp?error=2");
        }
        
	}
	

}

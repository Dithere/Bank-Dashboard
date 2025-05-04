package cop;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
@WebServlet("/login")
public class login extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		data myData = new dataimp(); 
		// TODO Auto-generated method stub
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		if (myData.isValidUser(username, password)) {
			 // or wherever you get it from
			HttpSession session = req.getSession(); // create session if not exists
			session.setAttribute("username", username);

            user user=new user();
    		
   		 
   		 	if(myData.account_ex(username)) {
   		 		resp.sendRedirect("welcome.jsp?registration=success");
   		 	}
   		 	else {
            resp.sendRedirect("bank.jsp");
   		 	}
            //System.out.println("Hi - "+username);
        } else {
            resp.sendRedirect("index.jsp?error=1");
        	System.out.println("Error A gya");
        }
}
		
	}
	



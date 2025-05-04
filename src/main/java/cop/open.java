package cop;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/open")
public class open extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false); // get session if it exists

	    if (session == null || session.getAttribute("username") == null) {
	      resp.sendRedirect("/"); // or show an error
	      return;
	    }

	    String username = (String) session.getAttribute("username");
		String name=req.getParameter("name");
		double ammount = Double.parseDouble(req.getParameter("ammount"));

		String pin=req.getParameter("pin");
		// In FirstServlet.java
		user user=new user();
		
		 data pro = new dataimp();
		 System.out.print(username);
		 
			 Ac ac=new Ac();
			 ac.setname(name);
			 ac.setAmt(ammount);
			 ac.setPin(pin);
			 
			 if(pro.open_accounts(username, ac)!=0) {
				 
				 resp.sendRedirect("welcome.jsp?registration=success");
			 }
			 else {
	             resp.sendRedirect("bank.jsp?error=1");
	         }
		 
		 
		 
		 

		// TODO Auto-generated method stub
		
	}
	

}

package cop;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/addmoney")
public class addmoney extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false); // get session if it exists

	    if (session == null || session.getAttribute("username") == null) {
	      resp.sendRedirect("/"); // or show an error
	      return;
	    }

	    String username = (String) session.getAttribute("username");
		// TODO Auto-generated method stub
		double amt = Double.parseDouble(req.getParameter("amt"));
		amu amu = new amu();
		amu.setAmt(amt);
		data im =new dataimp();
		long account_number;
		user user=new user();
		
		
		account_number=im.getAccountNumber(username);
		
		System.out.print(im.getBalance(account_number));
		im.credit(account_number, amu);
		System.out.print(im.getBalance(account_number));
		resp.sendRedirect("welcome.jsp");
		
	}

}

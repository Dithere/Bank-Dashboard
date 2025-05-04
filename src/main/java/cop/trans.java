package cop;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/trans")
public class trans extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = req.getSession(false); // get session if it exists

	    if (session == null || session.getAttribute("username") == null) {
	      resp.sendRedirect("/"); // or show an error
	      return;
	    }

	    String username = (String) session.getAttribute("username");
	    double amt = Double.parseDouble(req.getParameter("amt"));
	    
	    long rac = Long.parseLong(req.getParameter("rac"));

	    data im =new dataimp();
	    long account_number=im.getAccountNumber(username);
	    im.transfermoney(account_number, rac, amt);
	    resp.sendRedirect("welcome.jsp");
	}

}

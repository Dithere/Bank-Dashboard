package cop;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/cb")
public class cb extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = req.getSession(false); // get session if it exists

	    if (session == null || session.getAttribute("username") == null) {
	      resp.sendRedirect("/"); // or show an error
	      return;
	    }

	    String username = (String) session.getAttribute("username");
		data my = new dataimp();
		long acc;
		Ac ac =new Ac();
		user user=new user();
		
		double bal = my.getBalance(my.getAccountNumber(username));
		System.out.print(my.getBalance(my.getAccountNumber(username)));
		req.setAttribute("bal", bal);

	    // Forward to JSP
	    req.getRequestDispatcher("welcome.jsp").forward(req, resp);
	}

}

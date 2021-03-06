package ws.initialjiang.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Description 描述：网上找的样例
 *
 * @author  JRH
 * @date    2014年5月27日 下午5:29:49
 * @version v1.0.0
 */
@SuppressWarnings("serial")
public class ChatPointServlet2 extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		handleReq(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		handleReq(req, resp);
	}

	private void handleReq(HttpServletRequest req, HttpServletResponse resp) {
		try {
			req.getRequestDispatcher("/WEB-INF/views/chat2.jsp").forward(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

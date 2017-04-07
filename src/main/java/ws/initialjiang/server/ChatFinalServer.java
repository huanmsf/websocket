package ws.initialjiang.server;

import java.util.concurrent.atomic.AtomicInteger;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import ws.initialjiang.utils.ChatFinalServerPool;
import ws.initialjiang.utils.HTMLFilter;

/**
 * @Description 描述：通过注解的方式来注册WebSocket 服务器的端点 。这个端点也被称为注释的终点
 *
 *   使用js 创建WebSocket 的连接方式时的路径为 ： ws://ip/ws/websocket/chatfinal
 *   
 *   该类实现了P2P的聊天方式，即，你可以指定跟哪一个用户进行聊天。
 *   
 * @author  JRH
 * @date    2014年6月8日 上午10:48:20
 * @version v1.0.0
 */
@ServerEndpoint("/websocket/chatfinal")
public class ChatFinalServer {

	private static final String GUEST_PREFIX = "Rover-Guest";
	private static final AtomicInteger connectionIds = new AtomicInteger(1);

	private final String nickname;
	private Session session;

	public ChatFinalServer() {
		nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
	}

	@OnOpen
	public void onOpen(Session session) {
		this.session = session;
		
		ChatFinalServerPool.addChatFinalServer(this);
		
		String message = String.format("* %s %s", nickname, "has joined.");
		System.out.println("onOpen---message--->"+message);
		ChatFinalServerPool.sendMessage(message);
	}

	@OnClose
	public void onClose() {
		ChatFinalServerPool.removeMessageInbound(this); 		// 从内存中移除维护的关系
		
		String message = String.format("* %s %s", nickname, " has disconnected.");
		System.out.println("onClose---message--->"+message);
		ChatFinalServerPool.sendMessage(message);
	}

	/**
	 * maxMessageSize: 限制消息内容的最大字节数
	 * 
	 * 在这个程序中，如果超过1024个字节的信息被接收，就报告错误 和连接关闭。
	 * 使用@OnClose生命周期回调拦截，你还可以得到精确的错误代码和消息的。默认值为1指示 没有最大值。
	 * 
	 * MaxMessageSize属性不适用使用流 或reader获取的传入消息
	 * 
	 */
    @OnMessage(maxMessageSize=1024)	// 消息内容的最大字节数： 1KB 
	public void onMsg(String message) {
		// Never trust the client
		System.out.println("onMsg---message--->"+message);
		
		// 从接收到的消息当中截取出，需要沟通的对象的nickname
		int cursor = message.indexOf("-->>");
		String receiver = "";
		String msg = "";
		if(cursor > 0) {
			receiver = message.substring(0, cursor);
			msg = message.substring(cursor);
		} else {
			msg = message;
		}
		
		String filteredMessage = String.format("%s %s", nickname, HTMLFilter.filter(msg.toString()));
		System.out.println("onMsg---message--->"+filteredMessage);

		if(!"".equals(receiver) && receiver.startsWith(GUEST_PREFIX)) {
			ChatFinalServerPool.sendMessageToUser(nickname, filteredMessage); 	// 给自己发送信息
			ChatFinalServerPool.sendMessageToUser(receiver, filteredMessage); 	// 给对方发送信息
		} else {
			ChatFinalServerPool.sendMessage(filteredMessage);
		}
	}

	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}

	public String getNickname() {
		return nickname;
	}

}

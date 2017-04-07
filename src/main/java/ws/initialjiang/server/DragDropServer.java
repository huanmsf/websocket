package ws.initialjiang.server;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import ws.initialjiang.utils.HTMLFilter;

/**
 * @Description 描述：通过注解的方式来注册WebSocket 服务器的端点 。这个端点也被称为注释的终点
 *
 *   使用js 创建WebSocket 的连接方式时的路径为 ： ws://ip/ws/websocket/dragdrop
 *   
 *   该类主要实现了向浏览器中拖拽文件的功能，这里目前限于拖拽文件大小低于8KB的图片
 *   
 * @author  JRH
 * @date    2014年6月8日 上午10:48:20
 * @version v1.0.0
 */
@ServerEndpoint("/websocket/dragdrop")
public class DragDropServer {

    private static final String GUEST_PREFIX = "Guest";
    private static final AtomicInteger connectionIds = new AtomicInteger(0);

    private final String nickname;
    private Session session;

    public DragDropServer() {
        nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
    }

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        String message = String.format("* %s %s", nickname, "has joined.");
        sendToSelf(message);
    }
    @OnClose
    public void onClose() {
        String message = String.format("* %s %s", nickname, "has disconnected.");
        sendToSelf(message);
    }

	/**
	 * maxMessageSize: 限制消息内容的最大字节数
	 * 
	 * 在这个程序中，MaxMessageSize 的配置将不起作用
	 * 
	 * 原因：该属性不适用使用流 或reader获取的传入消息，而这里的消息内容是通过reader 获取的
	 * 
	 */
    //@OnMessage(maxMessageSize=20000000)	// 不起作用
    @OnMessage
    public void onMessage(String message) {
        // Never trust the client
    	System.out.println("message-----------------"+message);
        String filteredMessage = String.format("%s: %s", nickname, HTMLFilter.filter(message.toString()));
        System.out.println("filteredMessage-----------------"+filteredMessage);
        sendToSelf(filteredMessage);
    }

    //@OnMessage(maxMessageSize=20000000)	// 不起作用
    @OnMessage
    public void onBinaryMessage(ByteBuffer bbMsg) {
    	System.out.println("ByteBuffer Message------------------"+bbMsg);
    	try {
			session.getBasicRemote().sendBinary(bbMsg);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
    private void sendToSelf(String message) {
        try {
        	System.out.println(message);
        	session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            try {
            	session.close();
            } catch (IOException e1) {
                // Ignore
            }
            String msg = String.format("* %s %s", nickname, "has been disconnected.");
            sendToSelf(msg);
        }
    }
    
}

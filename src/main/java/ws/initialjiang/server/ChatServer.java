package ws.initialjiang.server;

import ws.initialjiang.utils.HTMLFilter;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;


/**
 * @Description 描述：通过注解的方式来注册WebSocket 服务器的端点 。这个端点也被称为注释的终点
 *
 *   使用js 创建WebSocket 的连接方式时的路径为 ： ws://ip/ws/websocket/chat
 *   
 *   该类实现了广播的形式发起聊天，有点类似于群聊。
 *   
 * @author  JRH
 * @date    2014年6月8日 上午10:48:20
 * @version v1.0.0
 */
@ServerEndpoint("/websocket/chat")
public class ChatServer {

    private static final String GUEST_PREFIX = "Guest";
    private static final AtomicInteger connectionIds = new AtomicInteger(0);
    private static final Set<ChatServer> connections = new CopyOnWriteArraySet<ChatServer>();

    private final String nickname;
    private Session session;

    public ChatServer() {
        nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
    }

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        connections.add(this);
        String message = String.format("* %s %s", nickname, "has joined.");
        broadcast(message);
    }


    @OnClose
    public void onClose() {
        connections.remove(this);
        String message = String.format("* %s %s", nickname, "has disconnected.");
        broadcast(message);
    }


    @OnMessage
    public void onMsg(String message) {
        // Never trust the client
        String filteredMessage = String.format("%s: %s", nickname, HTMLFilter.filter(message.toString()));
        broadcast(filteredMessage);
    }


    private static void broadcast(String msg) {
        for (ChatServer client : connections) {
            try {
                client.session.getBasicRemote().sendText(msg);
            } catch (Exception e) {
                connections.remove(client);
                try {
                    client.session.close();
                } catch (Exception e1) {
                    // Ignore
                }
                String message = String.format("* %s %s", client.nickname, "has been disconnected.");
                broadcast(message);
            }
        }
    }
    
}

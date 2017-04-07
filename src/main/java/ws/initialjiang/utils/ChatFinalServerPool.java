package ws.initialjiang.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import ws.initialjiang.server.ChatFinalServer;


/**
 * @Description 描述：用于维护各WebSocket 服务端点与各端点昵称之间的关系
 * 
 * 主要作用是，可以根据昵称找到 WebSocket 端点，然后进行消息发送等操作。
 *
 * @author  JRH
 * @date    2014年6月8日 上午10:46:26
 * @version v1.0.0
 */
public class ChatFinalServerPool {
	
	//保存连接的MAP容器  
	public static final Map<String, ChatFinalServer> clientToConnectionMap = new HashMap<String,ChatFinalServer>();  
      
    //向连接池中添加连接  
    public static void addChatFinalServer(ChatFinalServer server){  
        //添加连接  
        System.out.println("Client : " + server.getNickname() + " has joined.");  
        clientToConnectionMap.put(server.getNickname(), server);  
    }  
      
    //获取所有的在线用户  
    public static Set<String> getOnlineClient(){  
        return clientToConnectionMap.keySet();  
    }  
      
    public static void removeMessageInbound(ChatFinalServer server){  
        //移除连接  
        System.out.println("Client : " + server.getNickname() + " has disconnected.");  
        clientToConnectionMap.remove(server.getNickname());  
    }  
      
    public static void sendMessageToUser(String nickname, String message){  
        try {  
            //向特定的用户发送数据  
            System.out.println("send message to nickname : " + nickname + " , message content : " + message);  
            ChatFinalServer server = clientToConnectionMap.get(nickname);  
            if(server != null){  
                server.getSession().getBasicRemote().sendText(message);  
            }  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
      
    //向所有的用户发送消息  
    public static void sendMessage(String message){  
        try {  
            for (String nickname : clientToConnectionMap.keySet()) {  
                ChatFinalServer server = clientToConnectionMap.get(nickname);  
                if(server != null){  
                    System.out.println("send message to nickname : " + nickname + " , message content : " + message);
                    server.getSession().getBasicRemote().sendText(message);  
                }  
            }  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
    
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="ws.initialjiang.utils.ChatFinalServerPool"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	<head>
		<title>Chat-WebScoket-Final</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<meta name="description" content="overview &amp; stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<style type="text/css">
			#client_point {
	           width: 620px;
			}
			#chat {
	           width: 620px;
			}
	
	       #console-container {
	           width: 700px;
	       }
	
	       #console {
	           border: 1px solid #CCCCCC;
	           border-right-color: #999999;
	           border-bottom-color: #999999;
	           height: 170px;
	           overflow-y: scroll;
	           padding: 5px;
	           width: 100%;
	       }
	
	       #console p {
	           padding: 0;
	           margin: 0;
	       }
    	</style>
    
	</head>
	
	<body>
	
		<div class="noscript">
			<h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets rely on Javascript being enabled. Please enable Javascript and reload this page!</h2>
		</div>
		
		<div>
			<div>
				<label>联系对象：</label>
				<input type="text" id="client_point" name="client_point" value="Rover-Guest"/>
			</div>
			<div>
				<label>发送内容：</label>
	        	<input id="chat" type="text" placeholder="发送消息" />
			</div>
	   	</div>
	   	
		<div id="console-container">
	        <div id="console" ></div>
	    </div>
	    
  
	    <script type="text/javascript">
		    var Chat = {};
	
	        Chat.socket = null;
	
	        Chat.connect = (function(host) {
	            
	        	//alert("host---------"+host);
	        	
	            if ('WebSocket' in window) {
	                Chat.socket = new WebSocket(host);
	            } else if ('MozWebSocket' in window) {
	                Chat.socket = new MozWebSocket(host);
	            } else {
	                Console.log('该浏览器暂不支持WebSocket');
	                return;
	            }
	            
	            Chat.socket.onopen = function () {
	                Console.log('WebSocket 处于链接开启状态');
	                
	                document.getElementById('chat').onkeydown = function(event) {
	                    if (event.keyCode == 13) {
	                        Chat.sendMessage();
	                    }
	                };
	            };
	
	            Chat.socket.onclose = function () {
	                document.getElementById('chat').onkeydown = null;
	                Console.log('WebSocket 处于关闭状态');
	            };
	
	            Chat.socket.onmessage = function (message) {
	                Console.log(message.data);
	            };
	        });
	
	        Chat.initialize = function() {
	            if (window.location.protocol == 'http:') {
	                Chat.connect('ws://' + window.location.host + '/ws/websocket/chatfinal');
	            } else {
	                Chat.connect('wss://' + window.location.host + '/ws/websocket/chatfinal');
	            }
	        };
	
	        Chat.sendMessage = (function() {
                var client_point = document.getElementById('client_point');
                var c_info = client_point.value.replace(/(^\s*)|(\s*$)/g,"");
                //alert(">>>>"+c_info+"<<<");
                
                var pattern = new RegExp("^Rover\\-Guest\\d+$", "g"); 
                if(c_info.length > 0 && !c_info.match(pattern)) {
                	alert("联系对象必须以Rover-Guest开头，以数字结尾，如Rover-Guest12");
                	return;
                }
                
                var content = document.getElementById('chat').value;
                if(content.length == 0) {
                	alert("对不起，发送的消息不能为空！");
                	return;
                }
                
	            var message = client_point.value+"-->>"+content;
	            if (message != '') {
	                Chat.socket.send(message);
	                document.getElementById('chat').value = '';
	            }
	        });
	
	        var Console = {};
	
	        Console.log = (function(message) {
	            var console = document.getElementById('console');
	            var p = document.createElement('p');
	            p.style.wordWrap = 'break-word';
	            p.innerHTML = message;
	            console.appendChild(p);
	            while (console.childNodes.length > 9) {
	                console.removeChild(console.firstChild);
	            }
	            console.scrollTop = console.scrollHeight;
	        });
	
	        Chat.initialize();
	
	        document.addEventListener("DOMContentLoaded", function() {
	            // Remove elements with "noscript" class - <noscript> is not allowed in XHTML
	            var noscripts = document.getElementsByClassName("noscript");
	            for (var i = 0; i < noscripts.length; i++) {
	                noscripts[i].parentNode.removeChild(noscripts[i]);
	            }
	        }, false);
	    </script>
	    
	</body>
	
</html>
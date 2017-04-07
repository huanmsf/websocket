<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	<head>
		<title>Chat-WebScoket2</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<meta name="description" content="overview &amp; stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<style type="text/css">
			#chat {
	           width: 400px;
			}
	
	       #console-container {
	           width: 400px;
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
	    	<p>
	        	<input id="chat" type="text" placeholder="发送消息" />
	    	</p>
	   	</div>
	   	
	    <div id="console-container">
	        <div id="console" ></div>
	    </div>
	    
	    <script type="text/javascript">
		    var webSocket = new WebSocket('ws://localhost:8080/ws/websocket/chat2');
		    webSocket.onerror = function(event) {
		      onError(event)
		    };
		    
		    function sendMessage() {
	            var message = document.getElementById('chat').value;
	            if (message != '') {
	            	webSocket.send(message);
	                document.getElementById('chat').value = '';
	            }
	        };
		    
		    webSocket.onopen = function(event) {
		    	onOpen(event);

		        document.getElementById('chat').onkeydown = function(event) {
	                if (event.keyCode == 13) {
	                	sendMessage();
	                }
	            };
		    };
		 
		    webSocket.onmessage = function(event) {
		      onMessage(event)
		    };
		 
		    function onMessage(event) {
		      document.getElementById('console').innerHTML += '<br />' + event.data;
		    }
		 
		    function onOpen(event) {
		      document.getElementById('console').innerHTML = 'Connection established';
		    }
		 
		    function onError(event) {
		      alert(event.data);
		    }
		 
		    function start() {
		      webSocket.send('hello');
		      return false;
		    }
	 	 </script>
	    
	</body>
	
</html>
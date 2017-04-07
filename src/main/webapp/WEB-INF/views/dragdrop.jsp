<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	<head>
		<title>DragAndDrop</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<meta name="description" content="overview &amp; stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<style type="text/css">
	       #console-container {
	           width: 100%;
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
	       
	       h1 {
	       	text-align:left;
	       }
    	</style>
    
	</head>
	
	<body>
	
		<div class="noscript">
			<h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets rely on Javascript being enabled. Please enable Javascript and reload this page!</h2>
		</div>
		
		<div>
			<h1>请拖入一张图片 drag and drop an image</h1>	
	   	</div>
	   	
		<div id="console-container">
	        <div id="console" ></div>
	    </div>

	    <script type="text/javascript">
		    function createWs() {
		    	//ws:// echo.ws.org/echo
				var url = 'ws://' + window.location.host + '/ws/websocket/dragdrop';
	            if (window.location.protocol != 'http:') {
	            	url = 'wss://' + window.location.host + '/ws/websocket/dragdrop';
	            }
	            
	            //url = "ws://echo.websocket.org/echo";
	            
	            var ws = new WebSocket(url);
	            
	            //alert(url +" "+ ws);
	            
	            ws.onopen = function(e) {
	            	log("open");
	            };
	            
	            ws.onmessage = function(e) {	// e = message event 事件
	            	var blob = e.data;			// 获取事件中传递的数据
	            	//alert("事件类型： " + e.type +"--- 数据类型： "+typeof(blob));		// 获取数据的类型
	            	
	            	if(typeof blob == 'string') {
		            	log("字符串类型的消息String， 消息内容: "+blob);
	            	} else if(blob instanceof Object) {
		            	log("对象类型的消息，消息大小 : "+blob.size+ "bytes");
		            	if(window.webkitURL) {
		            		URL = webkitURL;
		            	}
		            	
		            	var uri = URL.createObjectURL(blob);
		            	var img = document.createElement("img");
		            	img.src = uri;
		            	document.body.appendChild(img);
	            	}
	            };

	            ws.onerror = function(e) {
	            	log("error, cased by : "+e.reason);
	            };
	            
	            ws.onclose = function(e) {
	            	log("close, case by : "+ e.reason);
	            };
	            
	            function log(message) {
		            var console = document.getElementById('console');
		            var p = document.createElement('p');
		            p.style.wordWrap = 'break-word';
		            p.innerHTML = message;
		            console.appendChild(p);
		            while (console.childNodes.length > 9) {
		                console.removeChild(console.firstChild);
		            }
		            console.scrollTop = console.scrollHeight;
		        }
	            
	            document.ondrop = function(e) {
	            	document.body.style.backgroundColor = "#fff";
	            	try {
		            	e.preventDefault();
		            	
		            	//alert(e.dataTransfer.files[0]);
		            	//获取文件列表
						var fileList = e.dataTransfer.files;
					
						//检测是否是拖拽文件到页面的操作
						if (fileList.length == 0) {
							log("对不起，您没有拖入任何有效文件！");
							return;
						};
					
						//检测文件是不是图片
						
						log("文件类型："+fileList[0].type+"; 文件大小："+fileList[0].size+"bytes");
						
						if (fileList[0].type.indexOf('image') === -1) {
							log("对不起，您拖入的不是图片文件！");
							return;
						}
						
						if(fileList[0].size > 8192) {
							log("对不起，您拖入的文件不得大于8KB");
							return;
						}

	            		handleFileDrop(fileList[0]);
	            	} catch(err) {
	            		log(err);
	            	}
	            };
	            
	            document.ondragover = function(e) {
	            	e.preventDefault();
	            	document.body.style.backgroundColor = "#6fff41";
	            };
	            
	            document.ondragleave = function(e) {
	            	document.body.style.backgroundColor = "#fff";
	            };
	            
	            function handleFileDrop(file) {
	            	var reader = new FileReader();
	            	reader.readAsArrayBuffer(file);
	            	
	            	//log("文件获取完毕：");
	            	reader.onload = function() {
	            		log("拖入文件的名称 :" + file.name);
	            		ws.send(reader.result);
	            		//alert(ws.readyState);
	            		//alert(reader.result);
	            	};
	            	
	            	reader.onerror = function() {
	            		log("File could not be read! Code " + reader.error.code);
	            	};
	            }
		    }
		    
		    createWs();
		    
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
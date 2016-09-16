<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.*"%>
<%@ page import="com.amazonaws.auth.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.model.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.util.TableUtils"%>
<%@ page import="com.aws.controller.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<%! // Share the client objects across threads to
    // avoid creating new clients for each web request
    private AWSCredentialsProvider credentialsProvider = new ClasspathPropertiesFileCredentialsProvider();
    private AmazonDynamoDBClient client = new AmazonDynamoDBClient(credentialsProvider);
    String tableName = "device";
    		
    DeviceStatus instance = new DeviceStatus(client, tableName);
 %>

<%
	TableUtils.waitUntilActive(client, tableName);
    /*
     * AWS Elastic Beanstalk checks your application's health by periodically
     * sending an HTTP HEAD request to a resource in your application. By
     * default, this is the root or default resource in your application,
     * but can be configured for each environment.
     *
     * Here, we report success as long as the app server is up, but skip
     * generating the whole page since this is a HEAD request only. You
     * can employ more sophisticated health checks in your application.
     */
    if (request.getMethod().equals("HEAD")) return;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>HomeSecurity</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="resources/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/style/style.css">
<script src="resources/jslib/jquery.min.js"></script>
<script src="resources/jslib/bootstrap.min.js"></script>
<script src="resources/js/index.js"></script>
</head>
<body>

	<div class="container">
		<div class="row" style="text-align: center; padding-top: 15%;">
			<div class="col-md-6 col-md-offset-3">
				<img class="logo" src="resources/images/logo/homesecurity.png">
			</div>
			<div class="row"
				style="text-align: center; padding-left: 10%; padding-right: 10%;">
				<div class="col-md-6 col-md-offset-3">
					<div id="form-olvidado">
						<form accept-charset="UTF-8" role="form" id="login-form"
							method="post">
							<fieldset>
								<h4 style="text-align: left;">
									<strong>Sign in</strong>
								</h4>
								<div class="form-group input-group">
									<span class="input-group-addon"> <i
										class="glyphicon glyphicon-user"> </i>
									</span> <input class="form-control" placeholder="User Name" id="email"
										name="email" required autofocus style="height: 40px;">
								</div>
								<div class="form-group input-group">
									<span class="input-group-addon"> <i
										class="glyphicon glyphicon-lock"> </i>
									</span> <input class="form-control" placeholder="Password"
										id="password" name="password" type="password" value=""
										required style="height: 40px;">
								</div>
								<div id="invalid" style="display: none; text-align: left;"></div>
								<div class="form-group">
									<form action="">
										<input type="hidden" name="writeToDB" value="set">
										<input id="login" type="submit" class="btn btn-warning btn-block" 
										style="height: 40px" value="Login" onclick="window.href.location = 'dashBoard.jsp'">
									</form>
									
									<p style="display: none;" class="help-block">
										<a class="pull-right text-muted" href="#" id="olvidado">Forgot
											your password?</a>
									</p>
								</div>
							</fieldset>
						</form>
					</div>
					<div style="display: none;" id="form-olvidado">
						<h4 class="">Forgot your password?</h4>
						<form accept-charset="UTF-8" role="form" id="login-recordar"
							method="post">
							<fieldset>
								<span class="help-block"> User name you use to log in to
									your account <br> Admin will send you an email with
									instructions to choose a new password.
								</span>
								<div class="form-group input-group">

									<span class="input-group-addon"> <i
										class="glyphicon glyphicon-user"> </i>
									</span> <input class="form-control" placeholder="User Name"
										name="email" type="email" required style="height: 40px;">
								</div>
								<button type="submit" class="btn btn-primary btn-block"
									id="btn-olvidado" style="height: 40px;">
									<strong>Continue</strong>
								</button>
								<p class="help-block">
									<a class="text-muted" style="text-align: left;" href="#"
										id="acceso">Sign-in</a>
								</p>
							</fieldset>
						</form>
					</div>


					<div class="resultsDiv">
					
						<% 
    	//insert all students in database
    	if(request.getParameter("writeToDB") != null)
    	{
    		System.out.println("inside results");
    		if(request.getParameter("writeToDB").equals("set"))
    		{
    			System.out.println("Inserting all students in database");
    			List<Map<String, AttributeValue>> item2;
    			item2 = instance.getByAttribute(client, tableName, "common", "all");
    			instance.insertAllStudents(client,tableName);		
    			%>
				<h3>Device table inserted</h3>	
		  <%
    		}
    		
    	}
    	
    	%>
			 </div>		
</body>
</html>

<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.*"%>
<%@ page import="com.amazonaws.auth.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.model.*"%>
<%@ page import="com.amazonaws.services.dynamodbv2.util.TableUtils"%>
<%@ page import="com.aws.controller.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="resources/css/bootstrap.min.css">
<link rel="stylesheet"
	href="resources/fonts/font-awesome-4.6.3/css/font-awesome.min.css">
<link rel="stylesheet" href="resources/style/main.css">

<!-- jQuery library -->
<script src="resources/jslib/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="resources/js/dashboard.js"></script>
<script src="resources/js/navbar.js"></script>
<script src="resources/jslib/bootstrap.min.js"></script>
<link href='https://fonts.googleapis.com/css?family=Oxygen'
	rel='stylesheet' type='text/css'>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard</title>
</head>
<body>

	<%-- <% 
    	//Handle printing of entire database
    	if(request.getParameter("query_all") != null)
    	{
    		if(request.getParameter("query_all").equals("set"))
    		{
    			System.out.println("Printing database");
    			List<Map<String, AttributeValue>> item2;
    			item2 = instance.getByAttribute(client, tableName, "common", "all");
    					
    			if(item2.size() <= 0)
    			{%>
    				<h3>Found 0 Students</h3>	
    		  <%}
    			else if(item2.size() > 0)
    			{%>
    				<h3>Found <%=item2.size() %> Student(s)</h3>
    				<ul>
    				<%
    				for(int i = 0; i < item2.size(); i++)
    				{%>
    					<li><%=item2.get(i).get("username").getS() %>: <%=item2.
    					get(i).get("firstname").getS() %> <%=item2.
    					get(i).get("lastname").getS() %> </li>
    			  <%}%>
    				</ul>
    				<br>
    		<%}
    		}
    		
    	}
    	
    	%> --%>

	<div class="container">
		<div class="row" style="height: 70px;">
			<div class="col-md-12">
				<navbar></navbar>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="row">
					<div class="col-md-6">
						<div class="row">
							<div class="col-md-12">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<h3>MODE</h3>
									</div>
									<div class="panel-body">
										<div class="input-group">
											<div class="radioBtn btn-group">
												<a class="btn btn-primary  active" data-toggle="happy"
													data-title="Y"><h3>HOME</h3></a> <a
													class="btn btn-primary  notActive" data-toggle="happy"
													data-title="N"><h3>AWAY</h3></a>
											</div>
											<input type="hidden" name="happy" class="happy">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="panel panel-primary"
										style="max-height: 400px;">
										<div class="panel-heading">
											<h3>History</h3>
										</div>
										<ul class="list-group" style="overflow-y: scroll;">
											<a href="#" class="list-group-item">Cras justo odio </a>
											<a href="#" class="list-group-item active">Dapibus ac
												facilisis in</a>
											<a href="#" class="list-group-item">Morbi leo risus</a>
											<a href="#" class="list-group-item">Porta ac consectetur
												ac</a>
											<a href="#" class="list-group-item">Vestibulum at eros</a>
										</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="row">
							<div class="col-md-12">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<h3>CAMERA 1</h3>
									</div>
									<div class="panel-body">

										<video width="400" controls> 
											<source src="mov_bbb.mp4" type="video/mp4">
											<source src="mov_bbb.ogg" type="video/ogg"> Your browser does not support
												HTML5 video. 
										</video>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="panel panel-primary">
									<div class="panel-heading">
										<h3>THERMOSTAT</h3>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col-md-4">
												<h5>Thermostat</h5>
											</div>
											<div class="col-md-4">
												<h6> Set: 25C</h6>
											</div>
											<div class="col-md-4">
												<h6> Current: 22C</h6>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard</title>
</head>
<body>

	<div>
	alert("new page");

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
	</div>
</body>
</html>
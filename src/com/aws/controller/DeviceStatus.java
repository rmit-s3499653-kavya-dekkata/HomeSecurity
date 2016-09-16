package com.aws.controller;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ComparisonOperator;
import com.amazonaws.services.dynamodbv2.model.Condition;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.DescribeTableResult;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutItemResult;
import com.amazonaws.services.dynamodbv2.model.ResourceNotFoundException;
import com.amazonaws.services.dynamodbv2.model.ScalarAttributeType;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.dynamodbv2.model.TableStatus;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class DeviceStatus {
	public static final AWSCredentialsProvider CREDENTIALS_PROVIDER = new ClasspathPropertiesFileCredentialsProvider();
	public static final Region REGION = Region.getRegion(Regions.US_WEST_2);
	public static String TABLE_NAME;
	public static AmazonDynamoDBClient DB_CLIENT;

	public DeviceStatus(AmazonDynamoDBClient client, String tableName)
	{
		DB_CLIENT = client;
		TABLE_NAME = tableName;
		//Set the region of the client 
		client.setRegion(REGION);

		//Check is table exists if it does not, create it
		if(!doesTableExist(client, tableName))
		{
			client.createTable(new CreateTableRequest().withTableName(tableName)
					//Define tables key schema (Primary key)
					.withKeySchema(new KeySchemaElement("deviceId", KeyType.HASH))
					.withAttributeDefinitions(new AttributeDefinition("deviceId", ScalarAttributeType.S))
					.withProvisionedThroughput(new ProvisionedThroughput(50l, 50l)));
			System.out.println("Created Table: " + client.describeTable(tableName));
		}
	}

	private boolean doesTableExist(AmazonDynamoDBClient dynamo, String tableName) {
		try {
			DescribeTableResult table = dynamo.describeTable(tableName);
			return TableStatus.ACTIVE.toString().equals(table.getTable().getTableStatus());
		} catch (ResourceNotFoundException rnfe) {
			return false;
		}
	}
	
	
	//Function for querying a specific attribute of the database
		//Returns a List of user maps
		//Selected attribute is passed in to query with value
		public List<Map<String, AttributeValue>> getByAttribute(AmazonDynamoDBClient client, String tableName, String attribute,String attributeVal)
		{
			//Setup scan filters
			Condition scanFilterCondition = new Condition().withComparisonOperator(ComparisonOperator.EQ.toString())
		    	.withAttributeValueList(new AttributeValue().withS(attributeVal));
			//Setup map for scan conditions
			Map<String, Condition> conditions = new HashMap<String, Condition>();
			//Apply scan conditions
			conditions.put(attribute, scanFilterCondition);
			//Formulate scan request
			ScanRequest scanRequest = new ScanRequest().withTableName(tableName).withScanFilter(conditions);
			//Scan database for presence of query values
			ScanResult result = client.scan(scanRequest);
			
			System.out.println(result.getCount());
			//Print results to console for diagnostics
			for(int i = 0; i < result.getCount(); i++)
			{
				System.out.println(result.getItems().get(i).get("deviceId").getS());
				
			}
			//Return a list of results
			return result.getItems();
		}
		
		/* This function reads a CSV file from your S3 bucket and insert all 
		 * student data inside that file in dynamodb table
		 * Fix this function so it can insert all data in CSV file to your dynamodb*/
		public void insertAllStudents(AmazonDynamoDBClient client,String tableName)
		{
			String bucketName = "s3499653bucket";
			String key = "devices.csv";
			String line;
			
			AmazonS3 s3Client = new AmazonS3Client(CREDENTIALS_PROVIDER);        
			S3Object object = s3Client.getObject(new GetObjectRequest(bucketName, key));
			try{
				InputStream objectData = object.getObjectContent();
				
				BufferedReader reader = new BufferedReader(new InputStreamReader(objectData));
				while ((line = reader.readLine()) != null) {
					String[] item = line.split(",");
					insertToDB(client,tableName,item[0],item[1],item[2]);
				}
				reader.close();
				objectData.close();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			System.out.println("All devices are insereted in Dynamo from S3 bucket");
			
		}
		
		//Function to insert a student into the database
		//Returns 0 - If student already exists - insertion fails
		//Returns 1 - Insertion was successful
		//Returns 2 - An unknown error occurred, insertion failed
		
		public int insertToDB(AmazonDynamoDBClient client, String tableName, String deviceId, String deviceName, String status)
		{
			//Formulate a get item request to check for existence of the user to be inserted
	        GetItemRequest itemRequest = new GetItemRequest();
	        itemRequest.setTableName(tableName);
	        itemRequest.addKeyEntry("deviceId", new AttributeValue(deviceId));
	        
	        //Store result of request for success/failure
	        GetItemResult itemResult = new GetItemResult();
	        itemResult = client.getItem(itemRequest);
	        
	        //If item is not a duplicate continue
	        if(itemResult.getItem() == null)
	        {
	        	System.out.println("Item not found");
	        	//Create user Map
	        	Map<String, AttributeValue> item = newItem(deviceId, deviceName, status);
	    		
	        	//Formulate request to insert data into database
	            PutItemRequest putItemRequest = new PutItemRequest(tableName, item);
	            PutItemResult putItemResult = new PutItemResult();
				putItemResult = client.putItem(putItemRequest);
	               
	            //Sanity call to .toString() to remove unused
	            putItemResult.toString();
	            
	            //Double check whether item was inserted by second get request
	            itemRequest = new GetItemRequest();
	            itemRequest.setTableName(tableName);
	            itemRequest.addKeyEntry("deviceId", item.get("deviceId"));
	            
	            itemResult = new GetItemResult();
	            itemResult = client.getItem(itemRequest);
	            
	            //If request returns null - insertion successful
	            if(itemResult.getItem() != null)
	            {
	            	System.out.println("Item: " + itemResult.getItem().get("deviceId").getS() + " : " + itemResult.getItem().get("deviceName").getS() + " inserted.");
	            	return 1;
	            }
	            //If request is not null, an unknown error occurred - insertion fails
	            else
	            {
	            	System.out.println("Item not inserted");
	            	return 2;
	            }
	        }
	        //If item is found return 0 to show that user already exists
	        else
	        {
	        	System.out.println("Item:" + itemResult.getItem().get("deviceId").getS() + " already exists.");
	        	return 0;
	        }
		}
		
		
		/*Function for generating a user map for storage in the database
		* Essentially generates what attributes will exist for each entry
		 */
		public static Map<String, AttributeValue> newItem(String deviceId, String deviceName, String status) 
		{
	        Map<String, AttributeValue> item = new HashMap<String, AttributeValue>();
	        item.put("deviceId", new AttributeValue(deviceId));
	        item.put("deviceName", new AttributeValue(deviceName));
	        item.put("status", new AttributeValue(status));  
	        item.put("common", new AttributeValue("all")); 
	        return item;
	    }
}

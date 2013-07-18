package MOST_Graph_DB;

/**
 * @author Milinda Fernando.
 * @Started : 02/07/2013
 *
 */

import java.io.File;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.neo4j.cypher.javacompat.ExecutionEngine;
import org.neo4j.cypher.javacompat.ExecutionResult;
import org.neo4j.graphdb.Direction;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Relationship;
import org.neo4j.graphdb.RelationshipType;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;
import org.neo4j.kernel.EmbeddedGraphDatabase;

public class Database {

	private GraphDatabaseFactory graphDbFactory;
	private EmbeddedGraphDatabase graphDb;
	private String databasePath;
	private File dbFolder;
	private Node startNode;
	private Date date;
	private ExecutionEngine execute_eng;
	private ExecutionResult result;

	public Database(String databasePath) {

		this.databasePath = databasePath;
		dbFolder = new File(databasePath);
		graphDbFactory = new GraphDatabaseFactory();
		date = new Date();
	}

	public void CreateDatabase() {
		if (dbFolder.exists() && dbFolder.list().length != 0) {
			// Database Exits.
			graphDb = (EmbeddedGraphDatabase) graphDbFactory
					.newEmbeddedDatabaseBuilder(this.databasePath)
					.loadPropertiesFromFile(
							this.databasePath + "/neo4j.properties")
					.newGraphDatabase();
		} else {

			graphDb = (EmbeddedGraphDatabase) graphDbFactory
					.newEmbeddedDatabase(databasePath);
			this.createStartNode();
			execute_eng = new ExecutionEngine(this.graphDb);
		}

		registerShutdownHook(graphDb);// To Ensure that the database is shutdown
										// properly when JVM Exits
	}

	public void StopDatabase() {

		try {

			graphDb.shutdown();
		} catch (Exception e) {
			System.out
					.println("Error Occured while Shutting down the database");
		}

	}

	private static void registerShutdownHook(final EmbeddedGraphDatabase graphDb) {
		// Registers a shutdown hook for the Neo4j instance so that it
		// shuts down nicely when the VM exits (even if you "Ctrl-C" the
		// running example before it's completed)
		Runtime.getRuntime().addShutdownHook(new Thread() {
			@Override
			public void run() {
				graphDb.shutdown();
			}
		});
	}

	/*
	 * Here are the relationship types that MOST graph database should have.
	 */

	private static enum RelTypes implements RelationshipType {
		HasZone, HasSubZone, HasData, HasWarning, HasDatapoint, HasConnection

	}

	// Start NODE is created when we create the database.All the Zones will be
	// attached to the Start Node.

	public Node getStartNode() {

		return this.startNode;
	}

	private void createStartNode() {

		Transaction tx = this.graphDb.beginTx();
		try {
			this.startNode = graphDb.createNode();
			startNode.setProperty("message",
					"This is the start node of the database");
			startNode.setProperty("timeStamp", this.date.getTime());
			tx.success();
		} catch (Exception e) {
			System.out.println("Error Occured while creating the node.");
			tx.failure();
		} finally {

			tx.finish();
		}

	}

	public boolean addZone(String p_name, String p_description,
			String p_country, String p_state, String p_county, String p_city,
			String p_building, String p_floor, String p_room, Double p_area,
			Double p_volume) {
		boolean state = false;
		Node tempZone;
		Transaction tx = this.graphDb.beginTx();
		int zoneID = this.getZoneCount();
		try {

			tempZone = this.graphDb.createNode();

			tempZone.setProperty("idzone", zoneID); // Primary key of the Node
			tempZone.setProperty("name", p_name);
			tempZone.setProperty("description", p_description);
			tempZone.setProperty("country", p_country);
			tempZone.setProperty("state", p_state);
			tempZone.setProperty("county", p_county);
			tempZone.setProperty("city", p_city);
			tempZone.setProperty("building", p_building);
			tempZone.setProperty("floor", p_floor);
			tempZone.setProperty("room", p_room);
			tempZone.setProperty("area", p_area);
			tempZone.setProperty("volume", p_volume);

			Relationship rel = this.startNode.createRelationshipTo(tempZone,
					RelTypes.HasZone);
			rel.setProperty("timeStamp",
					new Timestamp(this.date.getTime()).toString());
			tx.success();
			// System.out.println("Zone added was successfull");
			state = true;
		} catch (Exception e) {

			System.out
					.println("Error Occured When adding a Zone to the databse");
			e.printStackTrace();
			tx.failure();
			state = false;
		} finally {

			tx.finish();

		}

		return state;

	}

	public int getZoneCount() {

		int numberOfZones = 0;
		String cypher = "START n=NODE(1) MATCH n-[:HasZone]->zone RETURN COUNT(DISTINCT zone) AS Number_Of_Zones;";
		try {

			result = execute_eng.execute(cypher);
			Iterator<Long> n_column = result.columnAs("Number_Of_Zones");
			while (n_column.hasNext()) {
				numberOfZones = Integer.parseInt(n_column.next().toString());
			}
		} catch (Exception e) {
			System.out.println("Error Occured while executing the querry");
			numberOfZones = -1;
		}

		return numberOfZones;

	}

	public boolean addDatapoint(String p_datapoint_name, String p_type,
			String p_unit, Double p_accuracy, Double p_min, Double p_max,
			Double p_deadband, Double p_sample_interval,
			Double p_sample_interval_min, Double p_watchdog,
			String p_math_operations, String p_virtual, String p_custom_attr,
			String p_description) {
		boolean state = false;
		if (p_datapoint_name == null) {

			return state;

		} else {
			Node temp_datapoint;
			temp_datapoint = this.getDatapointByName(p_datapoint_name);
			if (temp_datapoint != null) {
				state = false; // This is for check duplicate datapoints;
				return state;
			}
			Transaction tx = graphDb.beginTx();
			try {

				temp_datapoint = graphDb.createNode();
				temp_datapoint.setProperty("datapoint_name", p_datapoint_name);
				temp_datapoint.setProperty("type", p_type);
				temp_datapoint.setProperty("unit", p_unit);
				temp_datapoint.setProperty("accuracy", p_accuracy);
				temp_datapoint.setProperty("min", p_min);
				temp_datapoint.setProperty("max", p_max);
				temp_datapoint.setProperty("deadband", p_deadband);
				temp_datapoint
						.setProperty("sample_interval", p_sample_interval);
				temp_datapoint.setProperty("sample_interval_min",
						p_sample_interval_min);
				temp_datapoint.setProperty("watchdog", p_watchdog);
				temp_datapoint
						.setProperty("math_operations", p_math_operations);
				temp_datapoint.setProperty("virtual", p_virtual);
				temp_datapoint.setProperty("custom_attr", p_custom_attr);
				temp_datapoint.setProperty("description", p_description);
				temp_datapoint.setProperty("idzone", -1); // Here -1 denotes
															// that the this
															// datapoint doesn't
															// belongs to any
															// zones.
				Relationship rel = this.startNode.createRelationshipTo(
						temp_datapoint, RelTypes.HasDatapoint);
				rel.setProperty("timestamp",
						new Timestamp(this.date.getTime()).toString());

				tx.success();
				this.addDataForced(p_datapoint_name,
						new Timestamp(this.date.getTime()).toString(), 0.0);
				state = true;

			} catch (Exception e) {
				System.out
						.println("Error Occured while entering the datapoint");
				e.printStackTrace();
				tx.failure();
			} finally {

				tx.finish();
			}

			return state;

		}

	}

	public Node getZoneByID(int p_idzone) {

		Node temp = null;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idzone", p_idzone);
		String cypher = "START n=NODE(1) MATCH n-[:HasZone]->zone WHERE zone.idzone={idzone} RETURN zone;";
		try {
			result = execute_eng.execute(cypher, params);
			Iterator<Node> iterator = result.columnAs("zone");
			while (iterator.hasNext()) {
				temp = iterator.next();
			}

		} catch (Exception e) {
			System.out.println("Error Occured while executing querry");
			temp = null;
		}

		return temp;
	}

	public boolean addDatapointToZone(String p_datapoint_name, Integer p_idzone) {

		boolean state = false;

		Node temp = this.getDatapointByName(p_datapoint_name);
		Node zone = this.getZoneByID(p_idzone);

		if (temp != null & zone != null) {

			Transaction tx = this.graphDb.beginTx();
			try {
				temp.setProperty("idzone", p_idzone);
				temp.getSingleRelationship(RelTypes.HasDatapoint,
						Direction.INCOMING).delete();
				Relationship rel = zone.createRelationshipTo(temp,
						RelTypes.HasDatapoint);
				rel.setProperty("timestamp",
						new Timestamp(this.date.getTime()).toString());
				tx.success();
				state = true;

			} catch (Exception e) {

				System.out.println("Error occured while adding the datapoint");
				e.printStackTrace();
				tx.failure();

			} finally {
				tx.finish();
			}

		} else {
			state = false;

		}

		return state;

	}

	public Node getDatapointByName(String p_datapoint_name) {

		Node temp = null;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("datapoint_name", p_datapoint_name);
		String cypher = "START n=NODE(1) MATCH n-[:HasZone]->()-[:HasDatapoint]->datapoint WHERE datapoint.datapoint_name={datapoint_name} RETURN datapoint;";
		try {
			result = execute_eng.execute(cypher, params);
			Iterator<Node> iterator = result.columnAs("datapoint");
			if (iterator.hasNext()) {
				temp = iterator.next();

			} else {
				cypher = "START n=NODE(1) MATCH n-[:HasDatapoint]->datapoint WHERE datapoint.datapoint_name={datapoint_name} RETURN datapoint;";
				result = execute_eng.execute(cypher, params);
				iterator = result.columnAs("datapoint");
				if (iterator.hasNext()) {
					temp = iterator.next();
				} else {
					temp = null;
				}
			}

		} catch (Exception e) {
			System.out.println("Error occured while executing querry");
			temp = null;
		}

		return temp;

	}

	public boolean addDataForced(String p_datapoint_name, String p_datetime,
			Double p_value) {

		boolean state = false;
		Node datapoint = this.getDatapointByName(p_datapoint_name);
		Node data;
		if (datapoint != null) {

			Transaction tx = graphDb.beginTx();
			try {
				data = this.graphDb.createNode();
				data.setProperty("datapoint_name", p_datapoint_name);
				data.setProperty("datetime", p_datetime);
				data.setProperty("value", p_value);

				Relationship rel = datapoint.createRelationshipTo(data,
						RelTypes.HasData);
				rel.setProperty("timestamp",
						new Timestamp(this.date.getTime()).toString());

				tx.success();
				state = true;

			} catch (Exception e) {
				System.out.println("Error Occured While Entering the data");
				e.printStackTrace();
				tx.failure();
				state = false;
			} finally {
				tx.finish();
			}

		} else {
			state = false;
		}

		return state;
	}

	public boolean addWarning(int p_error_code, String p_datapoint_name,
			String p_timestamp, String p_description, String p_toDo,
			int p_priority, String p_source) {

		boolean state = false;
		Node warning;

		String lv_timestampLastData = "";
		String lv_timestampLastWarning = "";

		if (this.getDatapointByName(p_datapoint_name) == null) {

			// RaiseError indicating no datapoint was found;
		} else {

			// Here have to set two timestamps using cypher querry language

			Timestamp ts_lv_timestampLastData = Timestamp
					.valueOf(lv_timestampLastData);
			Timestamp ts_lv_timestampLastWarning = Timestamp
					.valueOf(lv_timestampLastWarning);
			// Needs to come consider if this is the first warning
			if (ts_lv_timestampLastData.compareTo(ts_lv_timestampLastWarning) >= 0
					|| (p_error_code != 10 && p_error_code != 11)) {

				// Insert Warning
			} else {

				// Update warning.

			}

		}

		return state;
	}

	public boolean addConnection(String p_datapoint_name, String p_device_name,
			String p_connection_type, String p_connection_variables,
			Boolean p_writable, String p_vendor, String p_model,
			String p_connector_id) {

		boolean state = false;
		int number = this.getConnectionCount();
		Node connection;
		Node datapoint = this.getDatapointByName(p_datapoint_name);
		;
		Transaction tx = this.graphDb.beginTx();
		try {

			if (datapoint != null) {

				connection = this.graphDb.createNode();
				connection.setProperty("number", number);
				connection.setProperty("datapoint_name", p_datapoint_name);
				connection.setProperty("device_name", p_device_name);
				connection.setProperty("connection_type", p_connection_type);
				connection.setProperty("datapoint_name", p_datapoint_name);
				connection.setProperty("connection_variables",
						p_connection_variables);
				connection.setProperty("writeable", p_writable);
				connection.setProperty("datapoint_name", p_datapoint_name);
				connection.setProperty("vendor", p_vendor);
				connection.setProperty("datapoint_name", p_datapoint_name);
				connection.setProperty("model", p_model);
				connection.setProperty("datapoint_name", p_datapoint_name);
				connection.setProperty("connector_id", p_connector_id);

				Relationship rel = datapoint.createRelationshipTo(connection,
						RelTypes.HasConnection);
				rel.setProperty("timestamp",
						new Time(date.getTime()).toString());
				tx.success();
				state = true;
			} else {
				System.out.println("Error: datapoint not found");
				state = false;
			}
		} catch (Exception e) {
			System.out.println("Error Occured while entering the connection");
			e.printStackTrace();
			tx.failure();
			state = false;
		} finally {

			tx.finish();
		}

		return state;
	}

	public int getConnectionCount() {

		int numberOfConnections = 0;
		String cypher = "START n=NODE(1) MATCH n-[:HasDatapoint]->()-[:HasConnection]->connection  RETURN COUNT(DISTINCT connection) AS Number_Of_Connections;";
		try {
			result = execute_eng.execute(cypher);
			Iterator<Long> iterator = result.columnAs("Number_Of_Connections");
			if (iterator.hasNext()) {
				numberOfConnections += Integer.parseInt(iterator.next()
						.toString());
			}
			cypher = "START n=NODE(1) MATCH n-[:HasZone]->()-[:HasDatapoint]->()-[:HasConnection]->connection  RETURN COUNT(DISTINCT connection) AS Number_Of_Connections;";
			result = execute_eng.execute(cypher);
			iterator = result.columnAs("Number_Of_Connections");
			if (iterator.hasNext()) {
				numberOfConnections += Integer.parseInt(iterator.next()
						.toString());
			}

		} catch (Exception e) {
			System.out.println("Error Occured while executing querry");

		}
		return numberOfConnections;

	}

}

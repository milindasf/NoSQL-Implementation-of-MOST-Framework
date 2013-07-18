package MOST_Graph_DB;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.util.Date;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.neo4j.graphdb.Node;

public class Database_test {

	private Database db;

	@Before
	public void setup() {
		db = new Database("/home/milinda/Desktop/MOSTDB");
		db.CreateDatabase();
	}

	// @Test
	// public void TestGeneral() {
	//
	// assertEquals(0, db.getZoneCount());
	// boolean state;
	// state = db.addZone("Zone_1", "This is a test Zone", "Sri lanka",
	// "Colombo", "Sri lanka", "dematagoda", "Bank of Ceylon",
	// "1st floor", "234", 234.2, 800.32);
	// assertEquals(true, state);
	// assertEquals(1, db.getZoneCount());
	// Node temp = db.getZoneByID(0);
	// assertEquals(temp.getProperty("idzone"), 0);
	//
	// state = db.addZone("Zone_2", "This is a test Zone", "Sri lanka",
	// "Colombo", "Sri lanka", "dematagoda", "Bank of Ceylon",
	// "1st floor", "234", 234.2, 800.32);
	// assertEquals(true, state);
	// assertEquals(2, db.getZoneCount());
	// state = db.addDatapoint("datapoint_1", "this is a test datapoint", "",
	// 0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212, "+ -",
	// "virtual", "hello", "This is a test");
	// assertEquals(true, state);
	// state = db.addDatapoint("datapoint_2", "this is a test datapoint", "",
	// 0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212, "+ -",
	// "virtual", "hello", "This is a test");
	// assertEquals(true, state);
	// assertEquals("datapoint_1", db.getDatapointByName("datapoint_1")
	// .getProperty("datapoint_name"));
	// state = db.addDatapointToZone("datapoint_1", 0);
	// assertEquals(true, state);
	// assertEquals("datapoint_1", db.getDatapointByName("datapoint_1")
	// .getProperty("datapoint_name"));
	// assertEquals("datapoint_2", db.getDatapointByName("datapoint_2")
	// .getProperty("datapoint_name"));
	// state = db.addConnection("datapoint_1", "Test device", "wireless",
	// "7273987293", false, "wireshark", "Samsung", "832HJ");
	// assertEquals(true, state);
	// assertEquals(1, db.getConnectionCount());
	//
	// }
	//

	@Test
	public void TestZoneCount() {
		assertEquals(0, db.getZoneCount());
	}

	@Test
	public void TestAddZone() {
		boolean state;
		state = db.addZone("Zone_1", "This is a test Zone", "Sri lanka",
				"Colombo", "Sri lanka", "dematagoda", "Bank of Ceylon",
				"1st floor", "234", 234.2, 800.32);
		assertEquals(true, state);
		assertEquals(1, db.getZoneCount());
		state = db.addZone("Zone_2", "This is a test Zone", "Sri lanka",
				"Colombo", "Sri lanka", "dematagoda", "Bank of Ceylon",
				"1st floor", "234", 234.2, 800.32);
		assertEquals(true, state);
		assertEquals(2, db.getZoneCount());

	}

	@Test
	public void TestAddDatapoint() {
		boolean state;
		state = db.addDatapoint("datapoint_1", "this is a test datapoint", "",
				0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212, "+ -",
				"virtual", "hello", "This is a test");
		assertEquals(true, state);

		state = db.addDatapoint("datapoint_2", "this is a test datapoint", "",
				0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212, "+ -",
				"virtual", "hello", "This is a test");
		assertEquals(true, state);

		state = db.addDatapoint("datapoint_1", "this is a test datapoint", "",
				0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212, "+ -",
				"virtual", "hello", "This is a test");
		assertEquals(false, state);

	}

	@Test
	public void TestAddDatapointToZone() {
		boolean state;
		this.TestAddZone();
		this.TestAddDatapoint();
		state = db.addDatapointToZone("datapoint_1", 0);
		assertEquals(true, state);

	}

	@Test
	public void TestGetZonebyID() {

		this.TestAddZone();
		Node temp = db.getZoneByID(0);
		assertEquals(temp.getProperty("idzone"), 0);

	}

	@Test
	public void TestGetDatapointByName() {
		this.TestAddDatapointToZone();
		assertEquals("datapoint_1", db.getDatapointByName("datapoint_1")
				.getProperty("datapoint_name"));

	}

	@Test
	public void TestAddDataForced() {
		this.TestAddDatapoint();
		boolean state = db.addDataForced("datapoint_1",
				Long.toString(new Date().getTime()), 0.0);
		assertEquals(true, state);

	}

	@Test
	public void TestAddConnection() {

		this.TestAddDatapoint();
		boolean state = db.addConnection("datapoint_1", "Test device",
				"wireless", "7273987293", false, "wireshark", "Samsung",
				"832HJ");
		assertEquals(true, state);
		assertEquals(1, db.getConnectionCount());
	}

	@After
	public void tearDown() {

		db.StopDatabase();

		File file = new File("/home/milinda/Desktop/MOSTDB/index");
		String[] myFiles;
		if (file.isDirectory()) {
			myFiles = file.list();
			for (int i = 0; i < myFiles.length; i++) {
				File myFile = new File(file, myFiles[i]);
				myFile.delete();
			}
		}
		file.delete();

		file = new File("/home/milinda/Desktop/MOSTDB");

		if (file.isDirectory()) {
			myFiles = file.list();
			for (int i = 0; i < myFiles.length; i++) {
				File myFile = new File(file, myFiles[i]);
				myFile.delete();
			}
		}

	}

	// public static void main(String[] args) {
	//
	// Database_test test = new Database_test();
	// test.TestZoneCount();
	// test.TestAddZone();
	// test.TestAddDatapoint();
	// test.TestAddDatapointToZone();
	//
	// }

}

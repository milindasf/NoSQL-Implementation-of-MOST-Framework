package MOST_Graph_DB;

import java.io.File;
import java.sql.Timestamp;
import java.util.Date;

public class Main {

	public static void main(String[] args) {
		Database db = new Database("/home/milinda/Desktop/MOSTDB");

		try {

			db.CreateDatabase();
			// db.UpdateDatabase();
			// db.StopDatabase();
			System.out.println(db.getZoneCount());
			db.addZone("Zone_1", "This is a test Zone", "Sri lanka", "Colombo",
					"Sri lanka", "dematagoda", "Bank of Ceylon", "1st floor",
					"234", 234.2, 800.32);
			System.out.println(db.getZoneCount());
			db.addZone("Zone_2", "This is a test Zone", "Sri lanka", "Colombo",
					"Sri lanka", "dematagoda", "Bank of Ceylon", "1st floor",
					"234", 234.2, 800.32);
			System.out.println(db.getZoneCount());
			boolean state;
			state = db.addDatapoint("datapoint_1", "this is a test datapoint",
					"", 0.323, 0.00, 12.230, 323.32, 23.32, 3232.232, 12.212,
					"+ -", "virtual", "hello", "This is a test");
			System.out.println(state);
			state = db.addDatapointToZone("datapoint_1", 0);
			System.out.println(state);
			// Node datapoint = db.getDatapointByName("datapoint_1");
			// System.out.println(datapoint.getProperty("datapoint_name")
			// .toString());
			// state = db.addConnection("datapoint_1", "Test device",
			// "wireless",
			// "7273987293", false, "wireshark", "Samsung", "832HJ");
			// System.out.println(state);
			// System.out.println("Number of Connections:"
			// + db.getConnectionCount());
			System.out.println(new Timestamp(new Date().getTime()).toString());
		} catch (Exception e) {
			e.printStackTrace();

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

	}
}

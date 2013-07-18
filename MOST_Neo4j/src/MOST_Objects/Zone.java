package MOST_Objects;

/**
 * @author milinda
 *
 */
public class Zone {

	private int zoneID;
	private String name;
	private String description;
	private String country;
	private String state;
	private String city;
	private String building;
	private String floor;
	private String room;
	private double area;
	
	public Zone(String [] parameters){
		
		try{
		
		zoneID=Integer.parseInt(parameters[0]);
		name=parameters[1];
		description=parameters[2];
		country=parameters[3];
		state=parameters[4];
		city=parameters[5];
		building=parameters[6];
		floor=parameters[7];
		room=parameters[8];
		area=Double.parseDouble(parameters[9]);
		}catch(Exception e){
	   
			System.out.println("Error Occured While Creating a instance of Zone");
			e.printStackTrace();
		}
	
	}

	
	public int getZoneID() {
		return zoneID;
	}

	public void setZoneID(int zoneID) {
		this.zoneID = zoneID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getBuilding() {
		return building;
	}

	public void setBuilding(String building) {
		this.building = building;
	}

	public String getFloor() {
		return floor;
	}

	public void setFloor(String floor) {
		this.floor = floor;
	}

	public String getRoom() {
		return room;
	}

	public void setRoom(String room) {
		this.room = room;
	}

	public double getArea() {
		return area;
	}

	public void setArea(double area) {
		this.area = area;
	}
	
	
	
}

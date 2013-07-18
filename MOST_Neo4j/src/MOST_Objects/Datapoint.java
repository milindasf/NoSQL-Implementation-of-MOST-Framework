package MOST_Objects;
/**
 * 
 */

/**
 * @author milinda
 *
 */
public class Datapoint {

	private String datapointName;
	private String unit;
	private String type;
	private double min;
	private double max;
	private double accuracy;
	private String mathOperations;
	private double deadBand;
	private double sampleInterval;
	private double sampleIntervalMin;
	private double watchDog;
	private String virtual;
	private String customAttributes;
	private String Description;
	private int zoneID;
	
	public Datapoint(String [] parameter){
		
		
		datapointName=parameter[0];
		unit=parameter[1];
		type=parameter[2];
		min=Double.parseDouble(parameter[3]);
		max=Double.parseDouble(parameter[4]);
		
	}
	
	
}

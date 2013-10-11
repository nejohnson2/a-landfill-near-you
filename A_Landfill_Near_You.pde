/*
  A Landfill Near You 
  by Nicholas Johnson
  
  This sketch is designed to upload a csv containing latitude and longitude
  of landfills on the EPA Watchlist. Following the upload, using google 
  maps, will take an image of the area and output to a specified folder.
  
  This code was derived from Josh Begley's Prison Map project. 
 
*/

String[] landfills;
String outputPath;
Boolean initiate = false;
String inputFile;

void setup() {
  selectInput("Select a file to process:", "fileSelected");
}

void draw() {
  if(initiate == true){
    landfills = loadStrings(inputFile);
    //landfills = loadStrings("EPA_Watchlist_geoencoded.csv");
  
    for(int i = 0; i < landfills.length; i++) {  
      String[] values = split(landfills[i], ", ");
      String lat = values[1];
      String lon = values[0];
      println("lat: " + lat);
      println("lon: " + lon);
     
      if(lat == "NA" || lon == "NA"){
        print("no lat lon");
      } else {
        PImage test = getSatImage(lat,lon);
        test.save(outputPath + "/landfill-" + i + ".jpg");
      }
      delay(1000); 
    }
  }
}

PImage getSatImage(String lat, String lon) {
    int zoom = 15;
    String url = "http://maps.googleapis.com/maps/api/staticmap?center=" + lat + "," + lon + "&zoom=" + zoom + "&scale=1&size=640x640&maptype=satellite&sensor=false&junk=.jpg";
    return(loadImage(url));
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    outputPath = selection.getAbsolutePath();
    initiate = true;
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    inputFile = selection.getAbsolutePath();
  }
  selectFolder("Select a folder to save images:", "folderSelected");
}

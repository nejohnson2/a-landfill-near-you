/*
  A Landfill Near You 
  by Nicholas Johnson
  
  This sketch is designed to upload a csv containing latitude and longitude
  of landfills on the EPA Watchlist. Following the upload, using google 
  maps, will take an image of the area and output to a specified folder.
  
  A section of code will also place the latitude and longitude onto the image.
  Though the csv contains over nine thousand rows, my hope is to crowdsource
  the resulting images to determine what is interesting, are there actually
  landfills at these location and other general information that could be gathered
  in the future.  This will most likely be done through Crowdcrafting.
  
  This code was derived from Josh Begley's Prison Map project. 
 
*/

String[] landfills;
String outputPath;
String outputPathAbsolute = "/Users/luce/ITP/Processing/A_Landfill_Near_You/imagery";
Boolean initiate = false;
String inputFile;
PGraphics pg;
int zoom = 15;

void setup() {
  size(640,640);
  //selectInput("Select a file to process:", "fileSelected");
  initiate = true;
  textFont(createFont("Georgia", 24));
  pg = createGraphics(640,640);
}

void draw() {
  if(initiate == true){

     //landfills = loadStrings(inputFile);
    //landfills = loadStrings("EPA_Watchlist_geoencoded.csv");
    landfills = loadStrings("EPA-ECHO-FULL_MEDIA-LATLON_ONLY_R.csv");
    
    for(int i = 0; i < landfills.length; i++) {  
      String[] values = split(landfills[i], ",");
      
      String lat = values[0];
      String lon = values[1];
      String na = "NA";
      
      if(lat.equals(na) == true){
        println("no lat lon");
      } else {
        PImage test = getSatImage(lat,lon);
        pg.beginDraw();
        pg.background(test);
        pg.fill(0, 140);
        pg.rect(0, 595, 200, 150);
        pg.fill(255,255,255);
        pg.textSize(18);
        pg.text("Lat : " + lat, 5, 615);
        pg.text("Lon : " + lon, 5, 635);
        pg.endDraw();
        image(pg,0,0);
        pg.save(outputPathAbsolute + "/landfill-" + i + "-zoom-" + zoom + ".jpg");
      }
      delay(1000); 
    }
  }
}

PImage getSatImage(String lat, String lon) {
    String url = "http://maps.googleapis.com/maps/api/staticmap?center=" + lat + "," + lon + "&zoom=" + zoom + "&scale=1&size=640x640&maptype=satellite&sensor=false&junk=.jpg";
    println(url);
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

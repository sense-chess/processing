/*
 *  This sketch sends test data to the sense-chess test database.
 *  sense-chess is a project by Marcus Schoch and Jan Schneider.
 */

import processing.serial.*;
import java.util.*;
import java.text.*;
import de.bezier.data.sql.*;


PrintWriter output;
DateFormat fnameFormat= new SimpleDateFormat("yyMMdd_HHmm");
DateFormat  timeFormat = new SimpleDateFormat("hh:mm:ss");
String fileName;

Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed
PFont font;


MySQL dbconnection;

void setup() {
  size(600,100);  

// List all the available serial ports
printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); //change the 0 to a 1 or 2 etc. to match your port
  myPort.clear();
  myPort.bufferUntil(lf);
}

void draw() {
  background(0);
  text("received: " + inString, 10,50);
  serialEvent(myPort);
}

void serialEvent(Serial p) {
  delay(1000);
  inString = p.readString();
 //  println(inString);
  String readings = (inString);
  String[] list = split(readings, ',');
      println("source = "+list[0]+" ");
      println("target = "+list[1]+" ");
      println();
 //  delay(1000);  
        String user     = "php";
        String pass     = "php2000";
        String database = "chess";
        // connect to database of server "localhost"
        dbconnection = new MySQL( this, "localhost", database, user, pass );

        if ( dbconnection.connect() ) {
  dbconnection.execute( "INSERT INTO test (source, target) VALUES ('"+list[0]+"','"+list[1]+"');" );  
  dbconnection.close();

        }
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

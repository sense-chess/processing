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
boolean firstContact = false;

String lastsource = "m9";
String lasttarget = "j9";

String user     = "php";
String pass     = "php2000";
String database = "chess";
MySQL dbconnection;

Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed
PFont font;

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
  serialEvent(myPort);
  text("received: " + inString, 10,50);
}

void serialEvent(Serial p) {
  inString = p.readString();        
if (inString != null) {
  //trim whitespace and formatting characters (like carriage return)
  inString = trim(inString);
  println(inString);

  //look for our 'A' string to start the handshake
  //if it's there, clear the buffer, and send a request for data
  if (firstContact == false) {
    if (inString.equals("connecting")) {
      myPort.clear();
      firstContact = true;
      myPort.write("connected");
      println("connected to Arduino");
    }
  }
  else { //if we've already established contact, keep getting and parsing data
    String readings = (inString);
    String[] list = split(readings, ',');
    println("source = "+list[0]+" ");
    println("target = "+list[1]+" ");
    println(); 
    
    if(lastsource != list[0] && lasttarget != list[1]){
      lastsource = list[0];
      lasttarget = list[1];
    
      // connect to database of server "localhost"  
      dbconnection = new MySQL( this, "localhost", database, user, pass );

      if ( dbconnection.connect() ) {
        dbconnection.execute( "INSERT INTO test (source, target) VALUES ('"+list[0]+"','"+list[1]+"');" );  
        dbconnection.close();
      }
    }

    if (mousePressed == true) 
    {                           //if we clicked in the window
      myPort.write("d1");        //send a 1
      println("d1");
    }

    // when you've parsed the data you have, ask for more:
    myPort.write("bullshit");
    }
  }        
}

//void keyPressed() {
//  exit(); // Stops the program
//}

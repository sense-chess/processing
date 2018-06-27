/*
 *  This sketch receives data from the sense-chess test database.
 *  sense-chess is a project by Marcus Schoch and Jan Schneider.
 *  
 *  https://sense-chess.de
 */

import processing.serial.*;
import java.util.*;
import java.text.*;
import de.bezier.data.sql.*;

String fileName;
boolean firstContact = false;

java.sql.Timestamp last_ts;

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
  myPort = new Serial(this, Serial.list()[1], 9600); //change the 0 to a 1 or 2 etc. to match your port
  myPort.clear();
  myPort.bufferUntil(lf);
}

void draw() {
  background(0);
  //serialEvent(myPort);
  text("received: " + inString, 10,50);
}

void serialEvent(Serial p) {
  inString = p.readString();        
  if (inString != null) {
    //trim whitespace and formatting characters (like carriage return)
    inString = trim(inString);
    println(inString);
  
    //look for our "connecting" string to start the handshake
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
      
      // connect to database of server "localhost"  
      dbconnection = new MySQL( this, "localhost", database, user, pass );
  
      if ( dbconnection.connect() ) {
        dbconnection.query( "SELECT * FROM leds WHERE curtime > '"+last_ts+"' ORDER BY curtime ASC" );
        while( dbconnection.next() )
        {
          myPort.write(dbconnection.getString( "fields" ));
          println("leds =  "+dbconnection.getString( "fields" )+" ");
          
          last_ts = dbconnection.getTimestamp( "curtime" );
        }
        dbconnection.close();
      }
    }
  }        
}

//void keyPressed() {
//  exit(); // Stops the program
//}

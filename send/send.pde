/*
 *  This sketch sends data to the sense-chess test database.
 *  sense-chess is a project by Marcus Schoch and Jan Schneider.
 *  
 *  https://sense-chess.de
 */

import processing.serial.*;
import java.util.*;
import java.text.*;
import java.util.Map.Entry;
import de.bezier.data.sql.*;
import java.util.Map;

HashMap<Integer,String> lastInput = new HashMap<Integer,String>(200);
HashMap<String,Integer> fieldFromArduino = new HashMap<String,Integer>(64);
String fileName;
boolean firstContact = false;
String correctfields[] = { "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8",
                           "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8",
                           "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8",
                           "d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8",
                           "e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8",
                           "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8",
                           "g1", "g2", "g3", "g4", "g5", "g6", "g7", "g8",
                           "h1", "h2", "h3", "h4", "h5", "h6", "h7", "h8" }; 
int lastField = 0;
int actualdate = 0;
int lastTimeSentDate = 0;
int dateminustolerance = 0;
String sendThisField = "";
final int FIELDSMININLASTINPUT = 50;
final int FIELDMINFOUND = 10;
final int DEBOUNCER = 100;

final String USER     = "php";
final String PASS     = "php2000";
final String DATABASE = "chess";
MySQL dbconnection;

Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed
PFont font;

void setup()
{
  size(600,100);
  // List all the available serial ports
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); //change the 0 to a 1 or 2 etc. to match your port
  myPort.clear();
  myPort.bufferUntil(lf);
}

void draw()
{
  background(0);
  text("received: " + inString, 10,20);
  text("input: " + lastInput, 10,40);
  text("at: " + actualdate, 10, 60);
  text("lt: " + dateminustolerance, 10, 80);
}

void serialEvent(Serial p)
{
  inString = p.readString();        
  if (inString != null)
  {
    //trim whitespace and formatting characters (like carriage return)
    inString = trim(inString);
    println(inString);
  
    //look for our "connecting" string to start the handshake
    //if it's there, clear the buffer, and send a request for data
    if (firstContact == false)
    {
      if (inString.equals("connecting"))
      {
        myPort.clear();
        firstContact = true;
        myPort.write("connected");
        println("connected to Arduino");
      }
    }
    else 
    { //if we've already established contact, keep getting and parsing data    
      Date dada = new Date();
      actualdate = (int)dada.getTime();
      dateminustolerance = actualdate - DEBOUNCER;
      String readings = (inString);
      String[] list = split(readings, ',');
      println("field = "+list[0]+" ");
      println();
      Iterator<Entry<Integer,String>> iter = lastInput.entrySet().iterator();
      while (iter.hasNext()) {
        Entry<Integer,String> entry = iter.next();
        int k = entry.getKey();    
        iter.remove();
      }
      
      
      
      for (Map.Entry me : lastInput.entrySet())
      {
        int zulu = (int)dateminustolerance-(int)me.getKey();
        println("got " + me.getValue() + " at " + me.getKey() + " with tolerance " + zulu);
        if(zulu >= DEBOUNCER)
        {
          lastInput.remove(me.getKey());
          println("r");
        }
      }
      lastInput.put(actualdate, list[0]);
      
      if(lastInput.size()>=FIELDSMININLASTINPUT)
      {
        fieldFromArduino.clear();
        for (int i = 0; i < correctfields.length; i++)
        {
          fieldFromArduino.put(correctfields[i],0);
        }
        for (Map.Entry meo : lastInput.entrySet())
        {
          for (Map.Entry meoo : fieldFromArduino.entrySet())
          {
            if((int)meoo.getKey()==(int)meo.getKey())
            {
              int nop = (int)meoo.getValue()+1;
              fieldFromArduino.put((String)meoo.getKey(), nop);
            }
          }
        }
        int lolli = 0;
        for (Map.Entry meow : fieldFromArduino.entrySet())
        {
          if((int)meow.getValue()>lolli)
          {
            sendThisField = (String)meow.getKey();
          }
        }
        if(lolli >= FIELDMINFOUND && actualdate-lastTimeSentDate>DEBOUNCER)
        {
          // connect to database of local server  
          dbconnection = new MySQL( this, "localhost", DATABASE, USER, PASS );
          if ( dbconnection.connect() )
          {
            dbconnection.execute( "INSERT INTO boardinput (field) VALUES ('"+sendThisField+"');" ); 
            dbconnection.close();
            lastTimeSentDate = actualdate;
          }
        }
      }
    }
  }        
}

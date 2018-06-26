/*
 *  This sketch tests the timestamp or Date().
 *  sense-chess is a project by Marcus Schoch and Jan Schneider.
 *  
 *  https://sense-chess.de
 */

import java.util.*;

void setup() {
  size(600,100);  
}

void draw() {
  while(1==1){
    Date d = new Date();
    println(d.getTime()); 
    delay(1500);
  }
}

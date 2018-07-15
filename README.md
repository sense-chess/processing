<p align="center">
  <img src="https://raw.githubusercontent.com/sense-chess/artwork/master/sense-chess.png" width=80><br>
</p>
<h1 align="center">processing files of sense-chess</h1>
<br>
<br>
<p align="center">
  These are the files for Processing of sense-chess running our prototype.
  <br>
  It is under permanent construction.
  <br>
<br>
</p>
<h4 align="center">Usage</h4>
<p  align="center">1. Set up an local server (visit <a href="https://github.com/sense-chess/server">sense-chess server</a>).</p>  
<p  align="center">2. Install <a href="https://processing.org/download/">Processing</a>.</p>
<p  align="center">3. Install the MySQL library in Processing in the library menu (<a href="https://github.com/fjenett/sql-library-processing">BezierSQLib</a>).</p>  
<p  align="center">4. Upload the <a href="https://github.com/sense-chess/arduino">Arduino Sketches</a> on your Arduinos.</p>
<p  align="center">5. Connect the "send"-Arduino and run the "send"-Processing sketch and check for the correct port:<br>
<code  align="center">myPort = new Serial(this, Serial.list()[0], 9600);<br></code><br>
if Processing prints out another port you have to use this one (instead of 0).</p>  
<p  align="center">6. Connect the "receive"-Arduino and run the "receive"-Processing sketch and check for the correct port.<br>
The "receive"-Processing code uses the second possible port, thats why it only works when the other Arduino is connected too - or when you change the port. You can use the list of all available ports Processing prints at launch for that.</p> 
  <br>
<br><br>
<h4 align="center">Attribution Requirements</h4>
<p align="center">As an open source project, attribution is critical from a legal, practical and motivational perspective. Please give us credits! Common places for attribution are for example: to mention us in your project README, the 'About' section or the footer on a website/in mobile apps. </p>
<br><br>
<h4 align="center">License</h4>
<p align="center">This work is licensed under the GNU General Public License v3.0 license. View LICENSE.txt for details.</p>

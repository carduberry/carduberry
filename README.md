# Welcome to CArduBerry

### What is CArduBerry?
<img src="https://carduberry.github.io/carduberry/img/logo.png" width="300px"/>
Simply head to <a href="http://carduberry.github.io/carduberry">carduberry.github.io/carduberry</a> for further information

### You are interested and you want to know how we built it?
#### First of all, we used:
* An Arduino Uno with:
  * 4 IR sensor
  * 2 DC motor
  * A motor driver
* Raspberry pi 3 with:
  * Raspberry pi camera module v2
* Batteries (4 AA and a power bank)
* Dupont cables
* Insulating tape
* USB Type-A to Type-B cable
* USB Type-A to Micro-USB cable

You will also need a Google Cloud Platform account (you can use their free trial but you must have a credit card)


#### Code
##### Raspberry
At first we installed every library we needed (like Google Cloud Platform, picamera ...) then set the raspberry pi hostname to cardubbery so we could access SSH by typing carduberry.local (avahi daemon on the pi and Apple's Bounjour on Windows devices).

For the Raspberry we decided to use Python as our main language.

We used Flask as a web server and made a "video streaming" page thanks to this tutorial: link
After that, using Google Cloud Platform's Python libraries we made the code in charge of sending requests to Google Cloud Vision API every second. 

When we get a response from Google, the code decides if the car should stop at the signage or not sending a value to Arduino via serial communication

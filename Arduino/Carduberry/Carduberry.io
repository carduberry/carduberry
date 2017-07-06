#include <NewPing.h>
#define LS 3      // left sensor
#define RS 2      //right sensor
#define LM1 6       // left motor
#define LM2 5       // left motor
#define RM1 10       // right motor
#define RM2 11       // right motor
#define TRIGGER_PIN  13  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     12  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define LSE 7      // left sensor external
#define RSE 4      // right sensor external

NewPing sonar(TRIGGER_PIN, ECHO_PIN, 350);
boolean stopped = false;
boolean stoppedAtSignal = false;
void setup() {
  // put your setup code here, to run once:
  pinMode(LS, INPUT);
  pinMode(RS, INPUT);
  pinMode(LM1, OUTPUT);
  pinMode(LM2, OUTPUT);
  pinMode(RM1, OUTPUT);
  pinMode(RM2, OUTPUT);

  pinMode(LSE, INPUT);
  pinMode(RSE, INPUT);

  //pinMode(8, OUTPUT); //right
  //pinMode(9, OUTPUT); //left
  Serial.begin(9600);
}

void stop() {
  digitalWrite(8, LOW);
  digitalWrite(9, LOW);
  digitalWrite(LM2, LOW);
  digitalWrite(LM1, LOW);
  digitalWrite(RM2, LOW);
  digitalWrite(RM1, LOW);
}

void forward() {
  //digitalWrite(8, HIGH);
  //digitalWrite(9, HIGH);
  digitalWrite(LM2, HIGH);
  analogWrite(LM1, 65);
  //analogWrite(LM1, 100);
  digitalWrite(RM2, HIGH);
  analogWrite(RM1, 65);
  //analogWrite(RM1, 100);
}

void right() {
  //digitalWrite(8, LOW);
  //digitalWrite(9, HIGH);
  digitalWrite(LM2, LOW);
  digitalWrite(LM1, LOW);
  digitalWrite(RM2, HIGH);
  //analogWrite(RM1, 90);
  analogWrite(RM1, 38);
}

void left() {
  //digitalWrite(8, HIGH);
  //digitalWrite(9, LOW);
  digitalWrite(LM2, HIGH);
  analogWrite(LM1, 38);
  //analogWrite(LM1, 90);
  digitalWrite(RM2, LOW);
  digitalWrite(RM1, LOW);
}

boolean stop2(int a) {
  if (a == 0 && !stoppedAtSignal)
  //stop();
  stopped = false;
}

void loop() {
  delay(9);
  stop2(Serial.read() - '0');
  if (!digitalRead(LS) && !digitalRead(RS) && !digitalRead(LSE) && !digitalRead(RSE))    // Move Forward ! = BIANCO
  {
    forward();
  }

  if ((!(digitalRead(LS)) && !(digitalRead(LSE))) && (digitalRead(RS) || (digitalRead(RSE))))     // Turn right MODIFICA
  {
    right();
  }

  if ( (digitalRead(LS) || (digitalRead(LSE))) && (!(digitalRead(RS)) && !(digitalRead(RSE))) )    // turn left MODIFICA
  {
    left();
  }

  if (stopped || (sonar.ping_cm() < 20) || ((digitalRead(LS)) && (digitalRead(RS))) ||  ((digitalRead(LSE)) && (digitalRead(RSE))) )    // stop
  {
    stop();
  }
}

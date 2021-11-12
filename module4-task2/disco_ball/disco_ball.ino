#include <ESP32Servo.h>

// Define input pin numbers
int PIEZO = 34;
int SWITCH = 9;

// Define output pin numbers
int STEP_A = 33;
int STEP_B = 25;
int STEP_C = 26;
int STEP_D = 27;
int SERVO = 12;
int LIGHT = 32;

// Variables
Servo servo;
int servoPos = 0;
boolean countUp = true;
int lightVal = 0;
int oldPiezo = 4095;

void setup() {
  // Stepper setup
  pinMode(STEP_A,OUTPUT);
  pinMode(STEP_B,OUTPUT);
  pinMode(STEP_C,OUTPUT);
  pinMode(STEP_D,OUTPUT);
  pinMode(LIGHT, OUTPUT);

  // Servo setup
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  servo.setPeriodHertz(50);
  servo.attach(SERVO, 500, 2400);

  // Inputs setup
  pinMode(SWITCH, INPUT_PULLUP);
  pinMode(PIEZO, INPUT_PULLUP);
  Serial.begin(9600);

}


// Write to stepper output wires
void write(int a,int b,int c,int d){
  digitalWrite(STEP_A,a);
  digitalWrite(STEP_B,b);
  digitalWrite(STEP_C,c);
  digitalWrite(STEP_D,d);
}

// Function to move stepper one "step" forward
void stepStepper(){
  write(1,0,0,0);
  delay(5);
  write(1,1,0,0);
  delay(5);
  write(0,1,0,0);
  delay(5);
  write(0,1,1,0);
  delay(5);
  write(0,0,1,0);
  delay(5);
  write(0,0,1,1);
  delay(5);
  write(0,0,0,1);
  delay(5);
  write(1,0,0,1);
  delay(5);
}

// Move servo 2 degrees
void stepServo() {
  // Switch directions when it reaches 40 degrees
  if (countUp) {
    servoPos += 2;
    if (servoPos >= 40) {
      countUp = false;
    }
  }
  else {
    servoPos -= 2;
    if (servoPos <= 0) {
      countUp = true;
    }
  }
  servo.write(servoPos);
}

void loop() {
  // Collect and store values for each input
  int piezoValue = analogRead(PIEZO);
  int switchValue = digitalRead(SWITCH);

  // If switch is off, don't do anything
  if (switchValue == 0) {
    analogWrite(LIGHT, 0);
    return;
  }

  // Set light value based on piezo sensor
  if (piezoValue - oldPiezo > 50) {
     analogWrite(LIGHT, 800);
  }
  else {
    analogWrite(LIGHT, 0);
  }
  
  // Print all inputs in a single, comma-separated line
  Serial.print(max(0, piezoValue - oldPiezo));
  Serial.print(",");
  Serial.print(piezoValue);
  Serial.print(",");
  Serial.println(switchValue);
  delay(50);       

  // Rotate stepper and servo motors
  for (int i = 0; i < 1; i++) {
    stepStepper();
  }
  stepServo();

  // Store piezo value
  oldPiezo = piezoValue;

}

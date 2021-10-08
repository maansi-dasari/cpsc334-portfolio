#include <ESP32Servo.h>

// Define stepper pins
#define A 33
#define B 25
#define C 26
#define D 27
// Define "steps" for 360 degrees 
#define NUMBER_OF_STEPS_PER_REV 512

Servo myservo; // Create servo object
int servoPin = 12; // Output pin for servo
int pos = 0; // Track current rotation degrees

void setup(){
  // Stepper setup
  pinMode(A,OUTPUT);
  pinMode(B,OUTPUT);
  pinMode(C,OUTPUT);
  pinMode(D,OUTPUT);

  // Servo setup
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  myservo.setPeriodHertz(50);
  myservo.attach(servoPin, 500, 2400);
}

// Write to stepper output wires
void write(int a,int b,int c,int d){
  digitalWrite(A,a);
  digitalWrite(B,b);
  digitalWrite(C,c);
  digitalWrite(D,d);
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

// Move servo 10 degrees, or back to start
void stepServo() {
  if (pos < 180) {
    pos += 10;
  }
  else {
    pos = 0;
  }
  myservo.write(pos);
}

void loop(){
  // Rotate stepper 360 degrees
  for (int i = 0; i < STEPS_PER_REV; i++) {
    stepStepper();
  }
  // Rotate servo 10 degrees
  stepServo();
}

#include <ESP32Servo.h>

// Servo
Servo myservo; // Create servo object
int servoPin = 12; // Output pin for servo

// Lights
int red_light_pin= 25;
int green_light_pin = 26;
int blue_light_pin = 27;

// Buttons
int button_like = 10;
int button_love = 11;
int button_dislike = 9;

// Flower scale 0-10 (10 = bloomed)
int flower = 0;

// Cycles since last interaction
int ignored = 0;

void setup(){
  // Servo setup
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);
  myservo.setPeriodHertz(50);
  myservo.attach(servoPin, 500, 2400);

  // Lights setup
  ledcAttachPin(red_light_pin, 4);
  ledcAttachPin(green_light_pin, 5);
  ledcAttachPin(blue_light_pin, 6);
  ledcSetup(4, 2000, 8);
  ledcSetup(5, 2000, 8);
  ledcSetup(6, 2000, 8);

  // Buttons
  pinMode(button_like, INPUT_PULLUP);
  pinMode(button_love, INPUT_PULLUP);
  pinMode(button_dislike, INPUT_PULLUP);

  Serial.begin(9600);

  set_flower(0);
}

void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
 {
  // Scale red and green values to counteract the green lights being stronger
  ledcWrite(4, min(10 * red_light_value, 255));
  ledcWrite(5, int(pow(((double)green_light_value / 255.0), 2) * 255));
  ledcWrite(6, blue_light_value);
}

void set_flower(int scale) {
  flower = scale;
  
  // Calculate servo and LED values
  int servo_pos = scale * 15;
  int rgb_red = (10 - scale) * 25;
  int rgb_green = scale * 25;

  // Set servo position
  Serial.println(servo_pos);
  myservo.write(servo_pos);

  // Set LED colors
  RGB_color(rgb_red, rgb_green, 0);

  delay(200);

}

void loop(){
  // Read button inputs
  int like = digitalRead(button_like);
  int love = digitalRead(button_love);
  int dislike = digitalRead(button_dislike);

  // Print out button values
  Serial.print(like);
  Serial.print(",");
  Serial.print(love);
  Serial.print(",");
  Serial.println(dislike);

  if (love == 0) { // Love button pressed --> +5
    if (flower < 5) {
      set_flower(flower + 5);
    }
    else {
      set_flower(10);
    }
    ignored = 0;
  }
  else if (dislike == 0) { // Dislike button pressed --> -1
    if (flower > 0) {
      set_flower(flower - 1);
    }
    ignored = 0;
  }
  else if (like == 0) { // Like button pressed --> +1
    if (flower < 10) {
      set_flower(flower + 1);
    }
    ignored = 0;
  }
  else { // No button pressed --> Slowly lower
    // No buttons pressed
    ignored += 1;
    if (ignored > 100 && flower > 0) {
      set_flower(flower - 1);
      ignored = 0;
    }
  }
  delay(20);
}

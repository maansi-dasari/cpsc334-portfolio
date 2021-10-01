int JOYSTICK_X = 34;
int JOYSTICK_Y = 35;
int JOYSTICK_BTN = 32; 
int BUTTON = 9;
int SWITCH = 10;

void setup() {
  pinMode(JOYSTICK_X, INPUT);
  pinMode(JOYSTICK_Y, INPUT);
  pinMode(JOYSTICK_BTN, INPUT_PULLUP);
  pinMode(BUTTON, INPUT_PULLUP);
  pinMode(SWITCH, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  int joystickBtnValue = digitalRead(JOYSTICK_BTN);
  int xAxisValue = analogRead(JOYSTICK_X);
  int yAxisValue = analogRead(JOYSTICK_Y);
  int buttonValue = digitalRead(BUTTON);
  int switchValue = digitalRead(SWITCH);

  Serial.print(joystickBtnValue);
  Serial.print(",");
  Serial.print(xAxisValue);
  Serial.print(",");
  Serial.print(yAxisValue);
  Serial.print(",");
  Serial.print(buttonValue);
  Serial.print(",");
  Serial.println(switchValue);
  delay(100);        
}

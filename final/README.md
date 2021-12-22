This repo contains the Arduino code for my final project, "Cyber Flower"

The code inside `flower/flower.ino` contains the code to run on the ESP32, which records button inputs from 3 different buttons (like/love/dislike) and responds by sending commands to the servo motor to open/close the flower using a linear actuator and push rod system.

The circuit contains the following component, with input and output pin numbers specified in `flower/flower.ino`
- 3 push buttons
- 3 RGB LED lights
- 1 servo motor
- 3D printed linear actuator (https://www.thingiverse.com/thing:3170748)


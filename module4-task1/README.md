## How to run this code
To run this code on an ESP32, download and open `rotate_motors.ino` in the Arduino IDE and send it to the board. Make sure you have the ESP32Servo library installed. The code should start by rotating the stepper motor 360 degrees, and then rotating the servo by 10 degrees. This will keep happening until the servo reached 180 degrees, at which point it will return back to 0 degrees and then continue the cycle.
For the code to work, you should wire you circuit to match the diagram below.

## Circuit Diagram
![module4_circuit_image](https://user-images.githubusercontent.com/16601007/139970256-77c7af2d-192d-4960-9d80-93984676477d.png)

# Module 2 Task 2: Interactive System

## Circuit Configuration
The circuit uses 3 inputs which are plugged into the ESP32: a joystick, switch, and push button. They are wired as follows:
- Joystick: X-axis into pin 34, Y-axis into pin 35, Button into pin 32
- Push button connected to pin 9
- Switch connected to pin 10

The ESP32 is connected to the Raspberry Pi through USB, which is how it gets its power and passes its data.

## Serial Communication
The input pin values defined above are written into the `serial_write.ino` Arduino program, which polls each input pin every 100ms and reads its analog/digital value. The ESP32 then writes all of these integer values in a single, comma-separated line with a specified order of the values. It uses `Serial.println` to write pass these values over USB.
On the Raspberry Pi side, `serial_read.py` reads every line that is written (using the `serial` python library) and parses it into the individual values for each input. I created a custom class `Value` which stores the current value for any given input and calls a callback function when the value changes (ex: when the button is pressed and changes from 0 to 1).

## Storing States and Playing Music
The main function of the device is to be able to play and switch between different sounds tracks which contain common classroom noises. The music control happens on the Raspberry Pi, and is contained within `serial_read.py`. I used the `pygame` python library to play sounds. There are four main states that are manipulated throughout the execution of the sound machine:
1. Play/Stop - manipulated by the switch
2. Mute/Unmute - manipulated by the joystick button
3. Volume - controlled continuously by the joystick x axis
4. Sound - index into an array of different sound files, specifying the current sound being played

The value for each input to the circuit is stored in a `Value` object so that whenever it's value changes, the relevant callback function is called and the corresponding state is changed.

## Video Demo
Check out a ~30 second video of the interactive music system here: https://youtu.be/DThnvGjEGiE

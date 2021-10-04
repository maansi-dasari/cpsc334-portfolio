import serial
import pygame

JOY_X = 1
JOY_Y = 2
JOY_BTN = 0
BUTTON = 3
SWITCH = 4


class Value:
    def __init__(self, name, callback=None):
        self._name = name
        self._value = 0
        self._callback = callback
    
    def set_value(self, new_value):
        if self._callback and new_value != self._value:
            print(self._name, "changed value to", new_value)
            pygame.mixer.music.play()
        self._value = new_value

    def get_value(self):
        return self._value

    value = property(get_value, set_value)

pygame.mixer.init()
pygame.mixer.music.load("sound.wav")

ser = serial.Serial()
ser.port = '/dev/ttyUSB0'
ser.open()

joystick_x = Value("Joystick X", False)
joystick_y = Value("Joystick Y", False)
joystick_btn = Value("Joystick Button", True)
button = Value("Push Button", True)
switch = Value("Switch", True)

while True:
    line = ser.readline()
    decoded_line = line[0:len(line)-2].decode("utf-8")
    split_line = decoded_line.split(',')
    
    joystick_x.value = int(split_line[JOY_X])
    joystick_y.value = int(split_line[JOY_Y])
    joystick_btn.value = 1 - int(split_line[JOY_BTN])
    button.value = 1 - int(split_line[BUTTON])
    switch.value = 1 - int(split_line[SWITCH])


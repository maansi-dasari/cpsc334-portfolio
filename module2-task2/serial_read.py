import serial
import pygame

# Define array indices for serial input
JOY_X = 1
JOY_Y = 2
JOY_BTN = 0
BUTTON = 3
SWITCH = 4

# List of sound files to cycle through
SOUNDS = ["tear.wav", "velcro.wav", "crumble.wav"]

# Global state variables
sound_index = 0
volume = 0.1
muted = False

# Callback functions
def pause_play(value):
    if value == 0:
        pygame.mixer.music.stop()
    else:
        pygame.mixer.music.play(-1)

def switch_music(value):
    global sound_index
    global SOUNDS
    if value == 1:
        # Move to next sound
        sound_index = (sound_index + 1) % len(SOUNDS)
        pygame.mixer.music.load(SOUNDS[sound_index])
        global switch
        # Start playing next sound if in "play" state
        if (switch.value == 1):
            pygame.mixer.music.play(-1)

def toggle_mute(value):
    global muted
    if value == 1:
        if muted:
            muted = False
            pygame.mixer.music.set_volume(volume)
        else:
            muted = True
            pygame.mixer.music.set_volume(0.0)

def change_volume(value):
    global volume
    # Scale volume to [0,0.25] so it's not too loud
    volume = value / 4096 * 0.25
    if not muted:
        pygame.mixer.music.set_volume(volume)

# Class that allows callback functions on value change
class Value:
    def __init__(self, name, callback=None):
        self._name = name
        self._value = 0
        self._callback = callback
    
    def set_value(self, new_value):
        if self._callback and new_value != self._value:
            print(self._name, "changed value to", new_value)
            self._callback(new_value)
        self._value = new_value

    def get_value(self):
        return self._value

    value = property(get_value, set_value)

# Set up audio
pygame.mixer.init()
pygame.mixer.music.load(SOUNDS[sound_index])

# Set up serial reading
ser = serial.Serial()
ser.port = '/dev/ttyUSB0'
ser.open()

# Initialize input tracking variables with callbacks
joystick_x = Value("Joystick X", change_volume)
joystick_y = Value("Joystick Y")
joystick_btn = Value("Joystick Button", toggle_mute)
button = Value("Push Button", switch_music)
switch = Value("Switch", pause_play)

while True:
    # Parse each input string into array of individual values
    line = ser.readline()
    decoded_line = line[0:len(line)-2].decode("utf-8")
    split_line = decoded_line.split(',')
    
    # Set each input value
    joystick_x.value = int(split_line[JOY_X])
    joystick_y.value = int(split_line[JOY_Y])
    joystick_btn.value = 1 - int(split_line[JOY_BTN])
    button.value = 1 - int(split_line[BUTTON])
    switch.value = 1 - int(split_line[SWITCH])


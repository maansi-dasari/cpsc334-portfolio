import RPi.GPIO as GPIO
import time

# Define GPIO input pin numbers
BUTTON_PIN = 24
SWITCH_PIN = 23
JOYSTICK_X = 22
JOYSTICK_Y = 27
JOYSTICK_BUTTON = 17

# Define global button and switch states
switch = False
button_state = 0

# Define callback functions for events
def button_callback(channel):
    global button_state
    button_state+=1
    button_state%=3
    print("STATE CHANGED TO STATE " + str(button_state))

def switch_callback(channel):
    global button_state
    global switch

    # Wait for signal to stabalize
    time.sleep(0.1)

    # Toggle the switch value
    if switch and not GPIO.input(SWITCH_PIN):
        switch = False
        print("Switch turned OFF in state " + str(button_state))
    elif not switch and GPIO.input(SWITCH_PIN):
        switch = True
        print("Switch turned ON in state " + str(button_state))

def joystick_callback(channel):
    global button_state
    if channel == JOYSTICK_X:
        print("joystick x axis trigerred in state " + str(button_state))
    elif channel == JOYSTICK_Y:
        print("joystick y axis triggered in state " + str(button_state))
    elif channel == JOYSTICK_BUTTON:
        print("joystick button pressed in state " + str(button_state))

# GPIO setup
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

# Register input pins
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(SWITCH_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(JOYSTICK_X, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(JOYSTICK_Y, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(JOYSTICK_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Add callbacks for input events with debouncing
GPIO.add_event_detect(BUTTON_PIN, GPIO.RISING, callback=button_callback, bouncetime=100)
GPIO.add_event_detect(SWITCH_PIN, GPIO.BOTH, callback=switch_callback, bouncetime=100)
GPIO.add_event_detect(JOYSTICK_X, GPIO.FALLING, callback=joystick_callback, bouncetime=100)
GPIO.add_event_detect(JOYSTICK_Y, GPIO.FALLING, callback=joystick_callback, bouncetime=100)
GPIO.add_event_detect(JOYSTICK_BUTTON, GPIO.BOTH, callback=joystick_callback, bouncetime=100)

# Program instructions and wait for user to quit
print("Press the push button to cycle through states 0-2!")
print("You are currently in STATE 0")
message = input("Press enter to quit\n\n")

# Clean up after user ends program
GPIO.cleanup()

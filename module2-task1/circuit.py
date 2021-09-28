import RPi.GPIO as GPIO

BUTTON_PIN = 24
SWITCH_PIN = 23
JOYSTICK_X = 22
JOYSTICK_Y = 27
JOYSTICK_BUTTON = 17

switch = False
button_clicks = 0

def button_callback(channel):
    global button_clicks
    button_clicks+=1
    print("Button was pushed!")
    print(button_clicks)

def switch_on_callback(channel):
    global switch
    if not switch:
        switch = True
        print("Switch turned on")
    else:
        switch = False
        print("Switch turned off")

def switch_off_callback(channel):
    global switch
    if switch:
        switch = False
        print("Switch turned off")

def joystick_callback(channel):
    print("Joystick triggered")
    if channel == JOYSTICK_X:
        print("x axis")
    elif channel == JOYSTICK_Y:
        print("y axis")
    elif channel == JOYSTICK_BUTTON:
        print("button")


GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(SWITCH_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(JOYSTICK_X, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(JOYSTICK_Y, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(JOYSTICK_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

GPIO.add_event_detect(BUTTON_PIN, GPIO.RISING, callback=button_callback)
GPIO.add_event_detect(SWITCH_PIN, GPIO.BOTH, callback=switch_on_callback, bouncetime=20)
#GPIO.add_event_detect(SWITCH_PIN, GPIO.FALLING, callback=switch_off_callback)
GPIO.add_event_detect(JOYSTICK_X, GPIO.FALLING, callback=joystick_callback)
GPIO.add_event_detect(JOYSTICK_Y, GPIO.FALLING, callback=joystick_callback)
GPIO.add_event_detect(JOYSTICK_BUTTON, GPIO.RISING, callback=joystick_callback)

message = input("Press enter to quit\n\n")

GPIO.cleanup()

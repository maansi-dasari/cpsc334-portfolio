import serial

JOY_X = 1
JOY_Y = 2
JOY_BTN = 0
BUTTON = 3
SWITCH = 4

ser = serial.Serial()
ser.port = '/dev/cu.SLAB_USBtoUART'
ser.open()

class Value:
    def __init__(self, name, callback):
        self._name = name
        self._value = 0
        self._callback = callback
    
    def set_value(self, new_value):
        if self._callback and new_value != self._value:
            print(self._name, "changed value to", new_value)
        self._value = new_value

    def get_value(self):
        return self._value

    value = property(get_value, set_value)

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


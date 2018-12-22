import keyboard
from osc import OscClient
oscclientfocuswindow = OscClient("127.0.0.1",3000,'/focuswindow')
# Toggle Window Focus on Leap Motion
focuswindow = [0,0]
def toggleFocusWindow():
    focuswindow[0] += 1
    focuswindow[0] %= 2
    print("focuswindow: ",focuswindow[0])
    oscclientfocuswindow.sendMsg([focuswindow])
keyboard.add_hotkey('shift + v', lambda: toggleFocusWindow())
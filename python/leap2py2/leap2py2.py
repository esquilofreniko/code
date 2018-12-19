import time
import itertools
import OSC
import Leap
import sys
from Leap import Finger

HAND = 'left'
FINGERS = [Finger.TYPE_THUMB, Finger.TYPE_INDEX, Finger.TYPE_MIDDLE,
           Finger.TYPE_RING, Finger.TYPE_PINKY]

send_address = '127.0.0.1', 6448
c = OSC.OSCClient()
c.connect(send_address)

def is_expected_hand(hand):
    if HAND.lower() == 'left':
        return hand.is_left
    if HAND.lower() == 'right':
        return hand.is_right
    raise ValueError('Unrecognized HAND value: {}'.format(HAND))

def populate_hand_dict_from_fingers(hand_dict, fingers):
    for finger in fingers:
        if is_expected_hand(finger.hand):
            hand_dict[finger.type] = finger.tip_position.to_tuple()

def get_raw_tip_positioning_data(frame):
    hand_dict = {f: (0, 0, 0) for f in FINGERS}
    populate_hand_dict_from_fingers(hand_dict, frame.fingers)
    return itertools.chain.from_iterable(hand_dict[f] for f in FINGERS)

def build_osc_message(positioning_values):
    rNum = OSC.OSCMessage()
    rNum.setAddress("/wek/inputs")
    count = 0;
    for v in positioning_values:
        if count%3 == 0:
            cord = "x "
        elif count%3 == 1:
            cord = "y "
        elif count%3 == 2:
            cord = "z "
        if v == 0:
            break
        else:
            rNum.append(v/500)
            print "Fingertip" , count/3+1, cord
            print(v/500)
            count = count + 1
    return rNum

class SimpleListener(Leap.Listener):
    def on_frame(self, controller):
        frame = controller.frame()
        positioning_values = get_raw_tip_positioning_data(frame)
        msg = build_osc_message(positioning_values)
        c.send(msg)
        time.sleep(0.05)

controller = Leap.Controller()
listener = SimpleListener()
controller.add_listener(listener)

raw_input("Press Enter to quit...")
import time
import itertools
import Leap
import sys
from Leap import Finger

HAND = 'left'
FINGERS = [Finger.TYPE_THUMB, Finger.TYPE_INDEX, Finger.TYPE_MIDDLE,
           Finger.TYPE_RING, Finger.TYPE_PINKY]
           
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

class SimpleListener(Leap.Listener):
    def on_frame(self, controller):
        frame = controller.frame()
        positioning_values = get_raw_tip_positioning_data(frame)
        print(positioning_values)
        time.sleep(0.01)

controller = Leap.Controller()
listener = SimpleListener()
controller.add_listener(listener)

raw_input("Press Enter to quit...")
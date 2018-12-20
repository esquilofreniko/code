import numpy as np
import sounddevice as sd

sd.default.samplerate = 44100

time = 2.0
frequency = 440
samples = np.arange(44100 * time) / 44100.0
wave = 10000 * np.sin(2 * np.pi * frequency * samples)
wav_wave = np.array(wave, dtype=np.int16)

sd.play(wav_wave, blocking=True)

# while True:
#     print("Press q to quit...")
#     time.sleep(0.01)
#     try: 
#         if keyboard.is_pressed('q'): 
#             osc_terminate()
#             break 
#         else:
#             pass
#     except:
#         break 
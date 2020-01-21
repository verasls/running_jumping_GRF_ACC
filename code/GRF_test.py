import numpy as np
from scipy import signal
from statistics import mean
import matplotlib
matplotlib.use('MacOSX')
import matplotlib.pyplot as plt

# Read data
path = "../data/119/2017-12-09_Jumps_5cm_1_m1_119.txt"
data = np.loadtxt(path, delimiter=",")
samp_freq = 1000

# Get variables of interest
body_mass = 74  # subject's mass (kg)
g = 9.81  # gravity acceleration (m/s2)

body_weight = body_mass * g  # body weight (BW; N)

force = data[:, 2]  # ground reaction force (GRF; N)
time = np.array(range(1, len(force) + 1))
time = time / 1000

# Filter GRF data
# Create the lowpass filter
N = 4  # Filter order
cutoff = 20  # cut-off frequency (Hz)
fnyq = samp_freq / 2  # # Nyquist frequency (half of the sampling frequency)
Wn = cutoff / fnyq  # Filter parameter

b, a = signal.butter(N, Wn, btype="low")

# Process GRF signal
force = signal.filtfilt(b, a, force)

# Get GRF in BW
force_BW = force / body_weight  # ground reaction force (multiples of BW)

# Find peaks
height = 3 * mean(force_BW)
distance = 0.4 * samp_freq  # seconds * sampling frequency
peaks, properties = signal.find_peaks(force_BW, height=height,
                                      distance=distance)

# Loading frequency
print("Peaks found:", peaks)
print("Number of peaks", len(peaks))

# Plot
fig = plt.figure(figsize=(15, 7))
ax1 = fig.add_subplot(1, 1, 1)
ax1.plot(time, force_BW)
ax1.plot(peaks / 1000, force_BW[peaks], "x")
# plt.xticks(np.arange(min(time), max(time) + 1, 5))
plt.yticks(np.arange(0, 6, 0.5))
plt.grid()
plt.show()

# Osteogenic index (OI) variables
# Peak-to-peak strain magnitude
# E = force_BW[peaks]
# print("Peak-to-peak strain magnitude:", E)

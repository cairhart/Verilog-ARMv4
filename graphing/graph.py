from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np
import matplotlib


def T_O(n):
    return 4 + 5*n


def T_E(n):
    if n % 5 == 0:
        return int(1 + 14*np.floor(n/5))
    else:
        return int(35 + 14*np.floor(n/5) - 4*(n % 5))


def L(n,l):
    return (2*n + 1) * l


def S(n, l):
    return 100 * (T_O(n) - T_E(n)) / (T_O(n) + L(n, l))


def plot(title, l):
    fig, ax1 = plt.subplots(figsize=(6, 5), dpi=150)
    plt.subplots_adjust(left=0.15, right=0.85, top=0.88, bottom=0.13)
    ax2 = ax1.twinx()
    x = np.arange(2, 200, 1)  # vector length
    y1 = np.vectorize(T_O)(x)
    y2 = np.vectorize(T_E)(x)
    y3 = np.vectorize(S)(x, l)
    x_minor_ticks = np.arange(0, 200, 5)
    ax1.set_xticks(x_minor_ticks, minor=True)
    ax1.grid(which='minor', axis='x', alpha=0.5, linewidth=0.5)
    ax1.set_axisbelow(True)
    ax1.set_xlim(0, 200)
    ax2.set_ylim(-25, 50)
    ax1.set_xlabel('Vector Length')
    ax1.set_ylabel('Number of Cycles for Computation')
    ax2.set_ylabel('Percentage Savings')
    ax2.axhline(y=0, linewidth=0.7, c='black', zorder=0)
    ax1.plot(np.nan, '.', c='#01457e', label='Baseline')
    ax1.plot(np.nan, '.', c='#1f94fc', label='Extension')
    ax1.plot(np.nan, '.', c='#eb6e32', label='% Savings')
    ax1.scatter(x, y1, s=1, c='#01457e')
    ax1.scatter(x, y2, s=1, c='#1f94fc')
    ax2.scatter(x, y3, s=1, c='#eb6e32', zorder=1)
    ax1.set_xlabel('Vector Length')
    ax1.set_title(title)
    ax1.legend(loc='lower right')


def plotSavings(l):
    N = 300
    fig, ax = plt.subplots(figsize=(6, 5), dpi=150)
    plt.subplots_adjust(left=0.15, right=0.85, top=0.88, bottom=0.13)
    x = np.arange(2, N, 1)  # vector length
    y3 = np.vectorize(S)(x, l)
    x_minor_ticks = np.arange(0, N, 5)
    ax.set_xticks(x_minor_ticks, minor=True)
    ax.grid(which='minor', axis='x', alpha=0.5, linewidth=0.5)
    ax.set_axisbelow(True)
    ax.set_xlim(0, N)
    ax.set_ylim(-25, 50)
    ax.set_xlabel('Vector Length')
    ax.set_ylabel('Percentage Savings')
    ax.yaxis.set_label_position("right")
    ax.yaxis.tick_right()
    ax.axhline(y=0, linewidth=0.7, c='black', zorder=0)
    ax.scatter(x, y3, s=1, c='#1f94fc', zorder=1)
    ax.set_xlabel('Vector Length')
    ax.set_title('Percentage Savings (L = {:6.2f})'.format(l))


matplotlib.rcParams.update({'font.size': 12})

plot('No Loads/Stores', 0)
plot('Assuming Load/Store Avg Time is 8 Cycles', 8)
plt.show()

# plotSavings(0)
# plt.savefig('img2/{:02}.png'.format(0))
# plotSavings(1)
# plt.savefig('img2/{:02}.png'.format(1))
# plotSavings(3)
# plt.savefig('img2/{:02}.png'.format(3))
# plotSavings(8)
# plt.savefig('img2/{:02}.png'.format(8))
# plotSavings(20)
# plt.savefig('img2/{:02}.png'.format(20))
# plotSavings(50)
# plt.savefig('img2/{:02}.png'.format(50))

# frameRepeatCount = 20
# resolution = 20.0
# maxL = 50
#
# for i in range(0, frameRepeatCount):
#     print('generating figure {:04} (L = {})'.format(i, 0))
#     plotSavings(0)
#     plt.savefig('img/{:04}.png'.format(i))
#     plt.close()
#
# for i in range(1, int(maxL*resolution)):
#     figNum = i + frameRepeatCount - 1
#     lValue = i/resolution
#     print('generating figure {:04} (L = {})'.format(figNum, lValue))
#     plotSavings(lValue)
#     plt.savefig('img/{:04}.png'.format(figNum))
#     plt.close()
#
# for i in range(0, frameRepeatCount):
#     figNum = int(maxL*resolution) + i + frameRepeatCount - 1
#     print('generating figure {:04} (L = {})'.format(figNum, 100))
#     plotSavings(100)
#     plt.savefig('img/{:04}.png'.format(figNum))
#     plt.close()
#

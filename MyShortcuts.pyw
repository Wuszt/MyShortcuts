import win32api
import win32con
import os
import time
import KeysCodes

def GetButtonState(button):
    return win32api.GetAsyncKeyState(button)

def HandleShortcut(keys, appTuple):
    keysList = keys.split('+')

    for key in keysList:
        if(len(key) == 1):
            key = ord(key)
        else:
            key = getattr(KeysCodes, key)

        if not GetButtonState(key) >> 31:
            appTuple[2] = False
            return False

    if appTuple[1] < 0 and appTuple[2]:
        return False

    appTuple[2] = True

    if(appTuple[0][:2] == 'VK'):
        win32api.keybd_event(getattr(KeysCodes, appTuple[0]), 0,0,0)
        win32api.keybd_event(getattr(KeysCodes, appTuple[0]), 0,win32con.KEYEVENTF_KEYUP,0)
    else:
        os.startfile(appTuple[0])

    time.sleep(appTuple[1] if appTuple[1] >= 0.0 else 0.0)

    return True

config = open("config.cfg", "r")

lines = config.readlines()

config.close();

shortcuts = {}

for i in range(len(lines)):
    lines[i] = lines[i].rstrip()
    if(len(lines[i]) == 0 or lines[i][0] == '#'):
        continue
    
    splitted = lines[i].split()
    rawKeys = splitted[0]
    offset = len(splitted[0]) + 1 + len(splitted[1]) + 1
    delay = float(splitted[1])
    shortcuts[rawKeys] = [lines[i][offset:], delay, False]

while(True):
    shortcutInvoked = False
    for keys, command in shortcuts.items():
        shortcutInvoked |= HandleShortcut(keys, command)

    if(not shortcutInvoked):
        time.sleep(0.1)
        

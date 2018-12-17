import win32api
import win32con
import os
import time

def IsPressed(button):
    return win32api.GetAsyncKeyState(button) >> 31

def HandleShortcut(keys, app):
    keysList = keys.split('+')
    for key in keysList:
        if(len(key) == 1):
            key = ord(key)
        else:
            key = getattr(win32con, key)
            
        if(not IsPressed(key)):
            return False
        
    if(app[:2] == 'VK'):
        win32api.keybd_event(getattr(win32con, app), 0,0,0)
        time.sleep(0.05)
        win32api.keybd_event(getattr(win32con, app), 0,win32con.KEYEVENTF_KEYUP,0)
    else:
        os.startfile(app)
        time.sleep(0.5)
        
    return True

config = open("config.cfg", "r")

lines = config.readlines()

config.close();

shortcuts = {}

for i in range(len(lines)):
    lines[i] = lines[i].rstrip()
    if(len(lines[i]) == 0 or lines[i][0] == '#'):
        continue
    
    rawKeys = lines[i].split()[0]
    offset = len(rawKeys)
    shortcuts[rawKeys] = lines[i][offset+1:]

while(True):
    shortcutInvoked = False
    for keys, command in shortcuts.items():
        shortcutInvoked |= HandleShortcut(keys, command)

    if(not shortcutInvoked):
        time.sleep(0.05)
        

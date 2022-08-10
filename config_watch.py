#!/usr/bin/env python3

import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

WATCH_DIR = '/etc/freeradius/3.0'
TRIGGER_EVENTS = ('modified', 'deleted', 'moved')
IGNORE_EXTS = ('.swp')
IGNORE_SUBDIRS = ('.idea', '.vscode')
TEST_WATCH_DIR = '/home/jimnarey/projects/govwifi/test_dir'
RUN_ON_CHANGE = 'supervisorctl restart freeradius'

def get_ext(path):
    return os.path.splitext(path)[-1]

def is_temp_file(path):
    if get_ext(path) in IGNORE_EXTS:
        return True
    if path[-1] == '~':
        return True
    return False

def is_valid_event(event):
    if event.is_directory:
        return False
    if event.event_type not in TRIGGER_EVENTS:
        return False
    if is_temp_file(event.src_path):
        return False
    for sub_dir in IGNORE_SUBDIRS:
        if sub_dir in event.src_path:
            return False
    return True
    

class ConfigChangeHandler(FileSystemEventHandler):
    
    @staticmethod
    def on_any_event(event):
        if is_valid_event(event):
            print('Filesystem event detected: {}'.format(event))
            print('Restarting server')
        

if __name__ == '__main__':
    handler = ConfigChangeHandler()
    observer = Observer()
    observer.schedule(handler, TEST_WATCH_DIR, recursive=True)
    print('Watching {} for changes'.format(TEST_WATCH_DIR))
    observer.start()
    try:
        while True:
            time.sleep(1)
    except:
        observer.stop()
        print('\nExiting config watch script')
    observer.join()
    

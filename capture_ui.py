import sys
sys.dont_write_bytecode = True

import os
import subprocess
import time
import pyautogui
import pygetwindow
from PIL import ImageGrab

pyautogui.FAILSAFE = False

# Use a local data directory so the app can run inside the sandbox
script_dir = os.path.dirname(os.path.abspath(__file__))
appdata = os.path.join(script_dir, "test_data")
os.makedirs(appdata, exist_ok=True)

# Pre-populate sample data so editor/category screenshots have content
tasks_path = os.path.join(appdata, "tasks.json")
categories_path = os.path.join(appdata, "categories.json")

with open(tasks_path, "w", encoding="utf-8") as f:
    f.write('[{"id":"test-task-1","title":"测试任务","description":"这是一个测试任务","startTime":"","endTime":"","completed":false,"priority":1,"color":"#FF9800","scheduled":false,"category":"test-cat-1","hasReminder":false,"reminderTime":""}]')

with open(categories_path, "w", encoding="utf-8") as f:
    f.write('[{"id":"test-cat-1","name":"测试分类","color":"#4A90D9"}]')

# Run against the freshly built executable with Qt paths set
qt_bin = r"C:\Users\Asanagi\todo__app\Qt\6.8.0\mingw_64\bin"
qt_platforms = r"C:\Users\Asanagi\todo__app\Qt\6.8.0\mingw_64\plugins\platforms"
exe = os.path.abspath("build_mingw2/TodoApp.exe")
env = os.environ.copy()
env["TODO_APP_DATA_DIR"] = appdata
env["QT_QPA_PLATFORM_PLUGIN_PATH"] = qt_platforms
env["PATH"] = qt_bin + os.pathsep + env.get("PATH", "")
proc = subprocess.Popen([exe], cwd="build_mingw2", env=env)

def get_window():
    for _ in range(30):
        wins = [w for w in pygetwindow.getAllWindows() if "Todo Timeline" in w.title]
        if wins:
            return wins[0]
        time.sleep(0.5)
    raise RuntimeError("App window not found")

def shot(name):
    win = get_window()
    win.activate()
    time.sleep(0.4)
    bbox = (win.left, win.top, win.right, win.bottom)
    img = ImageGrab.grab(bbox=bbox)
    path = os.path.abspath(f"screenshot_{name}.png")
    img.save(path)
    print("saved", path)

try:
    win = get_window()
    print("window", win.left, win.top, win.width, win.height)
    time.sleep(1)

    # main
    shot("main")

    # TaskCreator
    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('n')
    pyautogui.keyUp('n')
    pyautogui.keyUp('ctrl')
    time.sleep(0.8)
    shot("taskcreator")

    # create a task for editor test
    win = get_window()
    # title field is centered near top of dialog
    field_x = win.left + int(win.width * 0.5)
    field_y = win.top + int(win.height * 0.22)
    pyautogui.click(field_x, field_y)
    time.sleep(0.3)
    pyautogui.typewrite("""TestTask""", interval=0.01)
    time.sleep(0.3)
    shot("taskcreator_with_text")
    # press Tab to dismiss Windows text suggestions and move focus away from title field
    pyautogui.keyDown('tab')
    pyautogui.keyUp('tab')
    time.sleep(0.3)
    # click the enabled "创建任务" button (bottom-right of dialog)
    win = get_window()
    btn_x = win.left + int(win.width * 0.56)
    btn_y = win.top + int(win.height * 0.82)
    pyautogui.click(btn_x, btn_y)
    time.sleep(1.0)
    shot("main_with_task")

    # open TaskEditor by clicking edit button (right side of first task item)
    win = get_window()
    x = win.left + int(win.width * 0.28)
    y = win.top + int(win.height * 0.24)
    pyautogui.click(x, y)
    time.sleep(0.8)
    shot("taskeditor")

    pyautogui.keyDown('esc')
    pyautogui.keyUp('esc')
    time.sleep(0.5)

    # CategoryDialog via toolbar "分类" button
    win = get_window()
    x = win.left + int(win.width * 0.08)
    y = win.bottom - int(win.height * 0.04)
    pyautogui.click(x, y)
    time.sleep(0.8)
    shot("categorydialog")

    # open edit category dialog (if default categories exist; otherwise no-op)
    win = get_window()
    # edit button is small icon on right of first list row; approximate center of row
    x = win.left + int(win.width * 0.28)
    y = win.top + int(win.height * 0.35)
    pyautogui.click(x, y)
    time.sleep(0.8)
    shot("editcategorydialog")

    pyautogui.keyDown('esc')
    pyautogui.keyUp('esc')
    time.sleep(0.3)
    pyautogui.keyDown('esc')
    pyautogui.keyUp('esc')
    time.sleep(0.3)

    # TaskCreator with schedule and reminder expanded
    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('n')
    pyautogui.keyUp('n')
    pyautogui.keyUp('ctrl')
    time.sleep(0.8)
    # click schedule checkbox (left side of dialog, below "安排时间（可选）")
    win = get_window()
    x = win.left + int(win.width * 0.40)
    y = win.top + int(win.height * 0.51)
    pyautogui.click(x, y)
    time.sleep(0.5)
    # click reminder checkbox (left side of dialog, below "提醒设置（可选）")
    y = win.top + int(win.height * 0.62)
    pyautogui.click(x, y)
    time.sleep(0.5)
    shot("taskcreator_expanded")

finally:
    pyautogui.keyDown('esc')
    pyautogui.keyUp('esc')
    time.sleep(0.3)
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        proc.kill()

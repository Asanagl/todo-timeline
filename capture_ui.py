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

# Pre-populate richer sample data for better screenshots
tasks_path = os.path.join(appdata, "tasks.json")
categories_path = os.path.join(appdata, "categories.json")

with open(categories_path, "w", encoding="utf-8") as f:
    f.write('''[
        {"id":"cat-work","name":"工作","color":"#2563EB"},
        {"id":"cat-study","name":"学习","color":"#10B981"},
        {"id":"cat-life","name":"生活","color":"#F59E0B"}
    ]''')

# Build sample tasks with varied priorities, colors, and scheduled times
import datetime
today = datetime.date.today().isoformat()
with open(tasks_path, "w", encoding="utf-8") as f:
    f.write('''[
        {"id":"task-1","title":"完成项目报告","description":"整理 Q2 季度项目进展并提交给主管","startTime":"''' + today + '''T09:00:00","endTime":"''' + today + '''T10:00:00","completed":false,"priority":2,"color":"#EF4444","scheduled":true,"category":"cat-work","hasReminder":true,"reminderTime":"''' + today + '''T08:45:00"},
        {"id":"task-2","title":"团队站会","description":"每日同步会议","startTime":"''' + today + '''T10:30:00","endTime":"''' + today + '''T11:00:00","completed":false,"priority":1,"color":"#F59E0B","scheduled":true,"category":"cat-work","hasReminder":false,"reminderTime":""},
        {"id":"task-3","title":"复习算法","description":"LeetCode 动态规划专题","startTime":"","endTime":"","completed":false,"priority":0,"color":"#10B981","scheduled":false,"category":"cat-study","hasReminder":false,"reminderTime":""},
        {"id":"task-4","title":"购买日用品","description":"牛奶、面包、水果","startTime":"","endTime":"","completed":true,"priority":0,"color":"#8B5CF6","scheduled":false,"category":"cat-life","hasReminder":false,"reminderTime":""},
        {"id":"task-5","title":"代码审查","description":"审查同事提交的 PR","startTime":"''' + today + '''T14:00:00","endTime":"''' + today + '''T15:00:00","completed":false,"priority":1,"color":"#2563EB","scheduled":true,"category":"cat-work","hasReminder":false,"reminderTime":""}
    ]''')

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
    time.sleep(0.5)
    bbox = (win.left, win.top, win.right, win.bottom)
    img = ImageGrab.grab(bbox=bbox)
    path = os.path.abspath(f"screenshot_{name}.png")
    img.save(path)
    print("saved", path)

def click_dialog(dialog_ratio_x, dialog_ratio_y):
    """Click at a position relative to the dialog center.
    The dialog is centered in the window with width 520px.
    """
    win = get_window()
    # Dialog is centered, width=520, so calculate dialog bounds
    dialog_width = 520
    dialog_left = win.left + (win.width - dialog_width) // 2
    dialog_right = dialog_left + dialog_width
    dialog_center_x = (dialog_left + dialog_right) // 2
    # Dialog vertical center is approximately window center
    dialog_center_y = win.top + int(win.height * 0.5)
    # Calculate click position based on ratios from dialog center
    click_x = dialog_left + int(dialog_width * dialog_ratio_x)
    click_y = dialog_center_y + int(win.height * dialog_ratio_y)
    pyautogui.click(click_x, click_y)
    time.sleep(0.4)

try:
    win = get_window()
    print("window", win.left, win.top, win.width, win.height)
    time.sleep(1.5)

    # 1. main interface
    shot("main")

    # 2. TaskCreator dialog
    pyautogui.hotkey('ctrl', 'n')
    time.sleep(1.0)
    shot("taskcreator")

    # 3. TaskCreator with text input
    click_dialog(0.5, -0.28)
    time.sleep(0.3)
    pyautogui.typewrite("Demo Task", interval=0.02)
    time.sleep(0.3)
    shot("taskcreator_with_text")
    pyautogui.press('tab')
    time.sleep(0.3)

    # 4. Create the task
    click_dialog(0.75, 0.35)
    time.sleep(1.2)
    shot("main_with_task")

    # 5. Open TaskEditor by clicking edit button on first task
    win = get_window()
    # Edit button is on the right side of the first task item
    x = win.left + int(win.width * 0.27)
    y = win.top + int(win.height * 0.22)
    pyautogui.click(x, y)
    time.sleep(1.0)
    shot("taskeditor")

    pyautogui.press('esc')
    time.sleep(0.5)

    # 6. CategoryDialog via toolbar "分类" button
    win = get_window()
    # "分类" button is the second button from left in the footer toolbar
    x = win.left + int(win.width * 0.10)
    y = win.bottom - int(win.height * 0.035)
    pyautogui.click(x, y)
    time.sleep(1.0)
    shot("categorydialog")

    # 7. Edit category dialog
    win = get_window()
    # Click edit button on first category row
    x = win.left + int(win.width * 0.30)
    y = win.top + int(win.height * 0.38)
    pyautogui.click(x, y)
    time.sleep(1.0)
    shot("editcategorydialog")

    pyautogui.press('esc')
    time.sleep(0.3)
    pyautogui.press('esc')
    time.sleep(0.3)

    # 8. TaskCreator with schedule and reminder expanded
    pyautogui.hotkey('ctrl', 'n')
    time.sleep(1.0)
    shot("taskcreator_initial")

    # Click schedule checkbox - it's in the "时间安排" section
    # The checkbox is on the left side of the dialog, in the schedule row
    win = get_window()
    dialog_width = 520
    dialog_left = win.left + (win.width - dialog_width) // 2
    # Schedule checkbox is approximately at 15% of dialog width, around 55% of window height
    schedule_x = dialog_left + int(dialog_width * 0.15)
    schedule_y = win.top + int(win.height * 0.58)
    pyautogui.click(schedule_x, schedule_y)
    time.sleep(0.8)

    # Click reminder checkbox - it's in the "提醒设置" section, below schedule
    reminder_y = win.top + int(win.height * 0.72)
    pyautogui.click(schedule_x, reminder_y)
    time.sleep(0.8)
    shot("taskcreator_expanded")

finally:
    pyautogui.press('esc')
    time.sleep(0.3)
    pyautogui.press('esc')
    time.sleep(0.3)
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        proc.kill()

#!/usr/bin/env python3

import os
import json
from flask import Flask, render_template, request, jsonify
from crontab import CronTab

STORE_PATH = 'store.json'
LIGHTS_PATH = '/home/pi/wake-up-light/lights.py'
DAYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
CRON_COMMENT = 'wakeup-light'

app = Flask(__name__, template_folder='../web/templates', static_url_path="", static_folder="../web/static")

# Display the web page
@app.route('/')
def index():
    with open(STORE_PATH, 'r') as f:
        store = json.load(f)
    return render_template("index.html", store=store, DAYS=DAYS)

# API: Update the timing
@app.route("/api/update", methods=["POST"])
def update():
    print("Updating")

    data = request.get_json()

    # Save to store
    with open(STORE_PATH, "w") as f:
      json.dump(data, fp=f)

    # Create cron jobs
    cron = CronTab(user="root")
    cron.remove_all(comment="wakeup-light")

    for dayName, dayData in data.items():
      print('dayname')
      print(dayName)
      print('dayData')
      print(dayData)
      if dayData['active']:
        hour, minute = dayData['time'].split(":")
        day = DAYS.index(dayName) + 1
        job = cron.new(
          command=f"{ LIGHTS_PATH } sunrise { dayData['duration'] }",
          comment="wakeup-light",
        )
        job.minute.on(minute)
        job.hour.on(hour)
        job.dow.on(day)

    cron.write()

    return jsonify("Updated")

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)

#!/usr/bin/env python3
import subprocess
import re
import math
from datetime import datetime


def get_total_usage(interface="wlan0"):
    try:
        output = subprocess.check_output(["vnstat", "-d", "-i", interface]).decode()
        today = datetime.now().strftime("%Y-%m-%d")
        for line in output.splitlines():
            if line.strip().startswith(today):
                match = re.search(
                    rf"{today}\s+[\d\.]+\s+\w+\s+\|\s+[\d\.]+\s+\w+\s+\|\s+([\d\.]+)\s+(\w+)",
                    line,
                )
                if match:
                    total_val, total_unit = match.groups()
                    rounded_val = round(float(total_val), 1)
                    return f"{rounded_val}{total_unit}"
                    # return f"{total_val}{total_unit}"
        return "No Data"
    except Exception as e:
        return f"vnstat error: {e}"


print(get_total_usage())

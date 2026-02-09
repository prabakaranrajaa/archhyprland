#!/usr/bin/env python3
import subprocess
import re
from datetime import datetime


def get_daily_usage(interface="wlan0"):
    try:
        output = subprocess.check_output(["vnstat", "-d", "-i", interface]).decode()
        today = datetime.now().strftime("%Y-%m-%d")
        for line in output.splitlines():
            if line.strip().startswith(today):
                # Match: date rx_val rx_unit | tx_val tx_unit | total_val total_unit
                match = re.search(
                    rf"{today}\s+([\d\.]+)\s+(\w+)\s+\|\s+([\d\.]+)\s+(\w+)\s+\|\s+([\d\.]+)\s+(\w+)",
                    line,
                )
                if match:
                    rx_val, rx_unit, tx_val, tx_unit, total_val, total_unit = (
                        match.groups()
                    )
                    return f"Net: ↓{rx_val} {rx_unit} ↑{tx_val} {tx_unit} ⧉{total_val} {total_unit}"
        return "No usage data yet"
    except Exception as e:
        return f"vnstat error: {e}"


print(get_daily_usage())

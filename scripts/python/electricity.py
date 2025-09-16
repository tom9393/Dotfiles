import datetime
import requests
import json
import os

# Constants
CACHE_FILE = "/tmp/latest_prices.json"
CACHE_MAX_AGE_HOURS = 12
API_URL = "https://api.porssisahko.net/v1/latest-prices.json"

# ANSI color helpers
def color(text, code): return f"\033[{code}m{text}\033[0m"
def green(text): return color(text, '92')
def yellow(text): return color(text, '93')
def red(text): return color(text, '91')
def cyan(text): return color(text, '96')
def bold(text): return color(text, '1')

# Load or refresh cached data
def load_data():
    need_refresh = True
    if os.path.exists(CACHE_FILE):
        mtime = datetime.datetime.fromtimestamp(os.path.getmtime(CACHE_FILE))
        if datetime.datetime.now() - mtime < datetime.timedelta(hours=CACHE_MAX_AGE_HOURS):
            need_refresh = False

    if need_refresh:
        res = requests.get(API_URL)
        with open(CACHE_FILE, "w") as f:
            f.write(res.text)

    with open(CACHE_FILE, "r") as f:
        return json.load(f)

# Main chart logic
def build_chart(data):
    prices = sorted(data["prices"], key=lambda p: p["startDate"])
    now = datetime.datetime.now(datetime.timezone.utc).astimezone()

    min_price = min(p["price"] for p in prices)
    max_price = max(p["price"] for p in prices)
    range_price = max_price - min_price if max_price != min_price else 1

    max_bar_len = 30

    def price_color(price):
        ratio = (price - min_price) / range_price
        if ratio < 0.33:
            return green("█")
        elif ratio < 0.66:
            return yellow("█")
        else:
            return red("█")

    print(bold("📈 Electricity Prices (Last 48h)\n"))
    print(bold(f"{'Time':<20} {'Price (c/kWh)':>12}  Chart"))
    print("-" * 60)

    last_date = None
    for entry in prices:
        dt = datetime.datetime.fromisoformat(entry["startDate"].replace("Z", "+00:00")).astimezone()
        date_str = dt.strftime("%Y-%m-%d")
        time_str = dt.strftime("%H:%M")
        price = entry["price"]

        # New date divider
        if last_date != date_str:
            print(bold(f"\n=== {date_str} ==="))
            last_date = date_str

        # Bar
        bar_len = int((price - min_price) / range_price * max_bar_len)
        bar_char = price_color(price)
        bar = bar_char * bar_len if bar_len > 0 else bar_char

        # Tags
        tags = []
        if price == min_price:
            tags.append(green("← LOW"))
        elif price == max_price:
            tags.append(red("← HIGH"))
        if dt.hour == now.hour and dt.date() == now.date():
            tags.append(cyan("NOW"))
        tag_str = "  " + " ".join(tags) if tags else ""

        if dt.hour == now.hour and dt.date() == now.date():
            print(cyan(f"{time_str} - {price:<5.2f} {bar}{tag_str}"))
        else:
            print(f"{time_str} - {price:<5.2f} {bar}{tag_str}")

# Run the script
data = load_data()
build_chart(data)


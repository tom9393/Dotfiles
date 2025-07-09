import datetime
import requests
import json

lon = 24.44
lat = 60.14
city = "Espoo"
key = "6e7746185d83be590667c9e42c7cfb4e"

# For lat/long instead
#url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={key}&units=metric"
url = f"https://api.openweathermap.org/data/2.5/weather?q={city},FI&appid={key}&units=metric"

res = requests.get(url)
data = json.loads(res.text)

# Optional: Add some terminal color formatting
def color(text, code):
    return f"\033[{code}m{text}\033[0m"

def format_time(utc_ts, tz_offset):
    local_ts = utc_ts + tz_offset
    return datetime.datetime.fromtimestamp(local_ts, datetime.UTC)

# Assign variables
weather = data['weather'][0]
main = data['main']
wind = data['wind']
sys = data['sys']
tz_offset = data['timezone']

# Output
print(f"{color('📍 Location:', '1;34')} {data['name'].title()}, {sys['country'].upper()}")
print(f"{color('⛅ Weather:', '1;33')} {weather['description'].capitalize()} ({weather['main']})")
print(f"{color('🌡️ Temperature:', '1;31')} {main['temp']}°C (feels like {main['feels_like']}°C)")
print(f"{color('📉 Low / 📈 High:', '1;36')} {main['temp_min']}°C / {main['temp_max']}°C")
print(f"{color('💧 Humidity:', '1;35')} {main['humidity']}%")
print(f"{color('🔽 Pressure:', '0;37')} {main['pressure']} hPa")
print(f"{color('💨 Wind:', '1;32')} {wind['speed']} m/s @ {wind['deg']}° (gusts {wind.get('gust', 0)} m/s)")
print(f"{color('🌅 Sunrise:', '1;37')} {format_time(sys['sunrise'], tz_offset)}")
print(f"{color('🌇 Sunset:', '1;37')} {format_time(sys['sunset'], tz_offset)}")
print(f"{color('☁️ Cloud cover:', '0;37')} {data['clouds']['all']}%")
print(f"{color('🔎 Visibility:', '0;37')} {data['visibility']} m")

import re, pathlib

m = pathlib.Path("android/app/src/main/AndroidManifest.xml")
t = m.read_text(encoding="utf-8")
t = re.sub(r'android:label="[^"]*"', 'android:label="شهربازی رؤیایی"', t, count=1)
if "screenOrientation" not in t:
    t = t.replace("<activity", '<activity\n            android:screenOrientation="sensorLandscape"', 1)
m.write_text(t, encoding="utf-8")

for name in ("build.gradle.kts", "build.gradle"):
    g = pathlib.Path("android/app") / name
    if g.exists():
        s = g.read_text(encoding="utf-8")
        s = s.replace("minSdk = flutter.minSdkVersion", "minSdk = 24")
        s = s.replace("minSdkVersion flutter.minSdkVersion", "minSdkVersion 24")
        g.write_text(s, encoding="utf-8")
print("patched")

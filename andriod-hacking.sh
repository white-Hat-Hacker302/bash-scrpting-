#!/bin/bash

# Banner
echo " "
echo "-------------------------------------------------------"
echo "      Android Mobile Hacking Toolkit Setup Script      "
echo "-------------------------------------------------------"
echo "      Coded by Pakistani White Hat Hacker             "
echo "            Mr. Sabaz Ali Khan                       "
echo "-------------------------------------------------------"
echo " "

# Check if script is run with sudo (optional, depending on system requirements)
if [ "$EUID" -ne 0 ]; then
    echo "[!] This script may require root privileges for some installations. Please run with sudo if needed."
fi

# Update system packages
echo "[+] Updating system packages..."
apt-get update && apt-get upgrade -y || {
    echo "[!] Failed to update packages. Ensure you have apt installed or check your internet connection."
    exit 1
}

# Install required dependencies
echo "[+] Installing dependencies (git, openjdk, unzip, wget, adb)..."
apt-get install -y git openjdk-11-jre unzip wget android-tools-adb || {
    echo "[!] Failed to install dependencies. Check your package manager or permissions."
    exit 1
}

# Install apktool
echo "[+] Installing apktool..."
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O /usr/local/bin/apktool || {
    echo "[!] Failed to download apktool script."
    exit 1
}
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.3.jar -O /usr/local/bin/apktool.jar || {
    echo "[!] Failed to download apktool.jar."
    exit 1
}
chmod +x /usr/local/bin/apktool
chmod +x /usr/local/bin/apktool.jar
echo "[+] apktool installed successfully."

# Install dex2jar
echo "[+] Installing dex2jar..."
wget https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex2jar-2.4.zip -O dex2jar.zip || {
    echo "[!] Failed to download dex2jar."
    exit 1
}
unzip dex2jar.zip -d /opt/dex2jar
chmod +x /opt/dex2jar/*.sh
ln -sf /opt/dex2jar/d2j-dex2jar.sh /usr/local/bin/d2j-dex2jar
echo "[+] dex2jar installed successfully."

# Install JD-GUI (Java Decompiler)
echo "[+] Installing JD-GUI..."
wget https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar -O /opt/jd-gui.jar || {
    echo "[!] Failed to download JD-GUI."
    exit 1
}
echo "[+] JD-GUI installed successfully. Run with: java -jar /opt/jd-gui.jar"

# Check if adb is working
echo "[+] Checking Android Debug Bridge (adb)..."
adb version || {
    echo "[!] adb not found or not working. Ensure Android SDK is installed and adb is in your PATH."
    exit 1
}

# Optional: Install Frida for dynamic analysis (requires root on device for full functionality)
echo "[+] Installing Frida tools..."
apt-get install -y python3 python3-pip
pip3 install frida-tools || {
    echo "[!] Failed to install Frida tools."
    exit 1
}
echo "[+] Frida tools installed successfully."

# Final message
echo " "
echo "-------------------------------------------------------"
echo " Setup Complete! Android Hacking Toolkit is ready."
echo " Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan"
echo "-------------------------------------------------------"
echo "[+] Tools installed: apktool, dex2jar, JD-GUI, adb, Frida"
echo "[+] Usage examples:"
echo "    - Decompile APK: apktool d target.apk"
echo "    - Convert .dex to .jar: d2j-dex2jar classes.dex"
echo "    - View decompiled code: java -jar /opt/jd-gui.jar"
echo "    - Connect to device: adb devices"
echo "    - Frida: frida --help"
echo "[!] Ensure you have permission to analyze any APK or device."
echo "-------------------------------------------------------"

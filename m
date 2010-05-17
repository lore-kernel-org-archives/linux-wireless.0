Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56805.mail.re3.yahoo.com ([66.196.97.79]:29155 "HELO
	web56805.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755221Ab0EQTep convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 15:34:45 -0400
Message-ID: <526427.36015.qm@web56805.mail.re3.yahoo.com>
Date: Mon, 17 May 2010 12:34:44 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] fix minor typos and small additions
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/README
+++ b/README
@@ -59,7 +59,7 @@ helper script:
 
 Run that script to see more information.
 
-Building, and installing
+Building and installing
 ------------------------
 
 Build: build the latest linux wireless subsystem
@@ -104,14 +104,15 @@ Unload:
 Drivers
 -------
 
-This is the list of drivers this package provides. It adds
+This is the list of drivers the package provides. It adds
 all new drivers or drivers which keep being updated which you might
 be interested in.
 
 Driver
 adm8211
 ath5k
-ath9h
+ath9k
+ath9k_htc
 ar9170
 b43
 b43legacy
@@ -121,11 +122,13 @@ ipw2100
 ipw2200
 libertas_cs (Libertas)
 ub8xxx      (Libertas)
+orinoco
 p54pci
 p54usb
 rt2400pci (rt2x00)
 rt2500pci (rt2x00)
 rt2500usb (rt2x00)
+rt2800usb (rt2x00)
 rt61pci      (rt2x00)
 rt73usb      (rt2x00)
 rtl8180    (Realtek)
@@ -136,7 +139,7 @@ This package also provides more drivers 
 
 For a complete list see:
 
-http://wireless.kernel.org/en/users/Download
+http://linuxwireless.org/en/users/Drivers and http://wireless.kernel.org/en/users/Download
 
 Non-wireless drivers
 --------------------
@@ -144,7 +147,7 @@ Non-wireless drivers
 To support b43 ssb is also provided, and since ssb is also provided
 we provide b44 (the ethernet driver).
 
-The new rfkill drivers also provided and backported.
+The new rfkill drivers are also provided and backported.
 
 Bluetooth drivers:
 bluetooth
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -106,7 +106,7 @@ DRIVERS="$DRIVERS drivers/net/atlx"
 # Bluetooth drivers
 DRIVERS_BT="drivers/bluetooth"
 
-# Drivers that belong the the wireless directory
+# Drivers that belong to the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
 DRIVER_FILES="$DRIVER_FILES rndis_wlan.c"
 DRIVER_FILES="$DRIVER_FILES mac80211_hwsim.c"
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Copyright 2009        Luis R. Rodriguez <mcgrof@gmail.com>
 #
-# This this to select your compat-wireless driver and
+# Use this to select your compat-wireless driver and
 # reduce compilation time.
 
 DRIVERS_MAKEFILE="drivers/net/wireless/Makefile"



      

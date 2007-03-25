Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:48611 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbXCYAP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2007 20:15:57 -0400
Date: Sat, 24 Mar 2007 17:15:30 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Update my email address from jkmaline@cc.hut.fi to j@w1.fi
Message-ID: <20070325001529.GH8122@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After 13 years of use, it looks like my email address is finally going
to disappear. While this is likely to drop the amount of incoming spam
greatly ;-), it may also affect more appropriate messages, so let's
update my email address in various places. In addition, Host AP mailing
list is subscribers-only and linux-wireless can also be used for
discussing issues related to this driver which is now shown in
MAINTAINERS.

Signed-off-by: Jouni Malinen <j@w1.fi>


diff --git a/MAINTAINERS b/MAINTAINERS
index 9c1cfe5..3fb9c9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1537,8 +1537,9 @@ S:	Supported
  
 HOST AP DRIVER
 P:	Jouni Malinen
-M:	jkmaline@cc.hut.fi
-L:	hostap@shmoo.com
+M:	j@w1.fi
+L:	hostap@shmoo.com (subscribers-only)
+L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
 
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 094397b..9e917b8 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -3,7 +3,7 @@
  *
  * Michael MIC (IEEE 802.11i/TKIP) keyed digest
  *
- * Copyright (c) 2004 Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2004 Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -173,4 +173,4 @@ module_exit(michael_mic_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Michael MIC");
-MODULE_AUTHOR("Jouni Malinen <jkmaline@cc.hut.fi>");
+MODULE_AUTHOR("Jouni Malinen <j@w1.fi>");
diff --git a/drivers/net/wireless/adm8211/adm8211_hw.c b/drivers/net/wireless/adm8211/adm8211_hw.c
index a33d239..2ec950d 100644
--- a/drivers/net/wireless/adm8211/adm8211_hw.c
+++ b/drivers/net/wireless/adm8211/adm8211_hw.c
@@ -2,7 +2,7 @@
 /*
  * Linux device driver for ADMtek ADM8211 (IEEE 802.11b MAC/BBP)
  *
- * Copyright (c) 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2005, Michael Wu <flamingice@sourmilk.net>
  * Some parts copyright (c) 2003 by David Young <dyoung@pobox.com>
  * and used with permission.
@@ -43,7 +43,7 @@
 
 #define RELEASE_DATE "20060414"
 
-MODULE_AUTHOR("Jouni Malinen <jkmaline@cc.hut.fi>, Michael Wu <flamingice@sourmilk.net>");
+MODULE_AUTHOR("Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Driver for IEEE 802.11b wireless LAN cards based on ADMtek"
 		   " ADM8211");
 MODULE_SUPPORTED_DEVICE("ADM8211");
@@ -58,7 +58,7 @@ module_param(rx_ring_size, uint, 0);
 module_param(debug, int, 0);
 
 static const char *version = KERN_INFO "adm8211: " 
-"Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>; "
+"Copyright 2003, Jouni Malinen <j@w1.fi>; "
 "Copyright 2004-2005, Michael Wu <flamingice@sourmilk.net>\n";
 
 
diff --git a/drivers/net/wireless/adm8211/adm8211_ioctl.c b/drivers/net/wireless/adm8211/adm8211_ioctl.c
index 22850cc..0fdeed2 100644
--- a/drivers/net/wireless/adm8211/adm8211_ioctl.c
+++ b/drivers/net/wireless/adm8211/adm8211_ioctl.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for ADMtek ADM8211 (IEEE 802.11b wireless LAN card)
  *
- * Copyright (c) 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2005, Michael Wu <flamingice@sourmilk.net>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/adm8211/ieee80211_sta.c b/drivers/net/wireless/adm8211/ieee80211_sta.c
index 940f742..3b57915 100644
--- a/drivers/net/wireless/adm8211/ieee80211_sta.c
+++ b/drivers/net/wireless/adm8211/ieee80211_sta.c
@@ -1,7 +1,7 @@
 /*
  * IEEE 802.11 station / management functionality
  *
- * Copyright (c) 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2005, Michael Wu <flamingice@sourmilk.net>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index efb8cf3..9ec32fa 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -1,8 +1,8 @@
 /*
  * Intersil Prism2 driver with Host AP (software access point) support
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This file is to be included into hostap.c when S/W AP functionality is
  * compiled.
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 534da85..4b81c7d 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -22,7 +22,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static dev_info_t dev_info = "hostap_cs";
 
 MODULE_AUTHOR("Jouni Malinen");
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 3079378..d21b8a9 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3,8 +3,8 @@
  * Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index 9077e6e..71ec281 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -3,8 +3,8 @@
  * Intersil Prism2/2.5/3 - hostap.o module, common routines
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/hostap/hostap_pci.c b/drivers/net/wireless/hostap/hostap_pci.c
index c4f6020..db4899e 100644
--- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -20,7 +20,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_pci";
 
 
diff --git a/drivers/net/wireless/hostap/hostap_plx.c b/drivers/net/wireless/hostap/hostap_plx.c
index e235e06..f0fd5ec 100644
--- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -23,7 +23,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_plx";
 
 
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index ad6e4a4..61706c9 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -28,8 +28,8 @@
 
   Portions of this file are based on the Host AP project,
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-    <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+    <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   Portions of ipw2100_mod_firmware_load, ipw2100_do_mod_firmware_load, and
   ipw2100_fw_load are loosely based on drivers/sound/sound_firmware.c
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 447c52b..536c70e 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -186,7 +186,7 @@
  *	- Wireless Event capability in struct iw_range
  *	- Add support for relative TxPower (yick !)
  *
- * V17 to V18 (From Jouni Malinen <jkmaline@cc.hut.fi>)
+ * V17 to V18 (From Jouni Malinen <j@w1.fi>)
  * ----------
  *	- Add support for WPA/WPA2
  *	- Add extended encoding configuration (SIOCSIWENCODEEXT and
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index e02d85f..d56b292 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -6,8 +6,8 @@
  * LAN access point) driver for Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  *
  * Adaption to a generic IEEE 802.11 stack by James Ketrenos
  * <jketreno@linux.intel.com>
diff --git a/include/net/ieee80211_crypt.h b/include/net/ieee80211_crypt.h
index eb47641..b3d65e0 100644
--- a/include/net/ieee80211_crypt.h
+++ b/include/net/ieee80211_crypt.h
@@ -3,8 +3,8 @@
  * for Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  *
  * Adaption to a generic IEEE 802.11 stack by James Ketrenos
  * <jketreno@linux.intel.com>
diff --git a/net/ieee80211/ieee80211_crypt.c b/net/ieee80211/ieee80211_crypt.c
index 5ed0a98..df5592c 100644
--- a/net/ieee80211/ieee80211_crypt.c
+++ b/net/ieee80211/ieee80211_crypt.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypto routines
  *
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  * Portions Copyright (C) 2004, Intel Corporation <jketreno@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/ieee80211/ieee80211_crypt_ccmp.c
index 35aa342..7ec8314 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based CCMP encryption implementation for Host AP driver
  *
- * Copyright (c) 2003-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index fc1f99a..bd0988f 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based TKIP encryption implementation for Host AP driver
  *
- * Copyright (c) 2003-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index ec6d885..1213d70 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based WEP encryption implementation for Host AP driver
  *
- * Copyright (c) 2002-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2002-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index b1c6d1f..7630434 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -5,8 +5,8 @@
   Portions of this file are based on the WEP enablement code provided by the
   Host AP project hostap-drivers v0.1.3
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-  <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+  <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   This program is free software; you can redistribute it and/or modify it
   under the terms of version 2 of the GNU General Public License as
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 4084909..9d33546 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -3,8 +3,8 @@
  * for Intersil Prism2/2.5/3 - hostap.o module, common routines
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2005, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 40d7a55..cee5e13 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -5,8 +5,8 @@
   Portions of this file are based on the WEP enablement code provided by the
   Host AP project hostap-drivers v0.1.3
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-  <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+  <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   This program is free software; you can redistribute it and/or modify it
   under the terms of version 2 of the GNU General Public License as


-- 
Jouni Malinen                                            PGP id EFC895FA

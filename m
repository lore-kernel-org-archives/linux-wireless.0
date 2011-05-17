Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65512 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EQIHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 04:07:51 -0400
Received: by pvg12 with SMTP id 12so125059pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 01:07:50 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.11386.45309.344391@gargle.gargle.HOWL> (sfid-20110517_100758_161680_4126ED26)
Date: Tue, 17 May 2011 13:36:18 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Drag the driver to the year 2011
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The Times They Are a-Changin'.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c               |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    2 +-
 drivers/net/wireless/ath/ath9k/ani.h               |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |    2 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    2 +-
 drivers/net/wireless/ath/ath9k/calib.h             |    2 +-
 drivers/net/wireless/ath/ath9k/common.c            |    2 +-
 drivers/net/wireless/ath/ath9k/common.h            |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    2 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |    2 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h           |    2 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    2 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    2 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    2 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    2 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 65 files changed, 80 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 6195639..5b49cd0 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  * Copyright (c) 2009 Gabor Juhos <juhosg@openwrt.org>
  * Copyright (c) 2009 Imre Kaloz <kaloz@openwrt.org>
  *
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 5a1f4f5..bfb6481 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 0cd6783..dbab5b9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index 36f7d06..234617c 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 4bf9dab..441bb33 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index 69a94c7..6d2e2f3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index cb611b2..015d974 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index f44c84a..f344cc2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index 6203eed..7573257 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 7a332f1..077e8a6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index a57e963..2fe0a34 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 47780ef..453af6d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index f915a3d..e8ac70d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index f276cb9..f48051c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1e22035..729534c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index afb0b5e..ab21a49 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -1,3 +1,19 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 #ifndef AR9003_EEPROM_H
 #define AR9003_EEPROM_H
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index a55eddb..392bf0f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index be6adec..10d71f7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index 45cc7e8..c504493 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 356d2fd7..e4d6a87 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 25f3c2f..eee23ec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index c7505b4..443090d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2002-2010 Atheros Communications, Inc.
+ * Copyright (c) 2010-2011 Atheros Communications, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index fbdde29..611ea6c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 03b37d7..b070f40 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 637dbc5..329ebd8 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 23f15a7..41ce0b1 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009 Atheros Communications Inc.
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index a9efca8..234f776 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009 Atheros Communications Inc.
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 558b228..a1250c5 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 4420780..1bef41d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 74535e6..fa6bd2d 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009 Atheros Communications Inc.
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 5124f14..77ec288 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009 Atheros Communications Inc.
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 7afe332..c21269c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 5488a32..8ce6ad8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 8c18bed..e61404d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3e31613..de99c0d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 6f714dd..5b1e894 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index b87db47..7856f0d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index c031854..17f0a68 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 0349b3a..bc713fc 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 2e3a33a..260f1f3 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 0d6ff79..794f630 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e09b20f..5bc0220 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 0ded2c6..aa6a731 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index af57fe5..db2352e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8657d26..61e6d39 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index bee100e..7b77968 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 0ecc242..2d81c70 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index cee970f..1b90ed8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 91a5305..e1ffbb6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 8b8f044..2f3e072 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b75b5dc..72543ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7af2773..57435ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2010 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b172d15..45c585a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index bd6d2b9..c2091f1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index b60c130..8e848c4 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 17ebdf1..0236593 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 9c65459..b8cbfc7 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 9441bf8..8b38030 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4ccbf2d..1754221 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Video54 Technologies, Inc.
- * Copyright (c) 2004-2009 Atheros Communications, Inc.
+ * Copyright (c) 2004-2011 Atheros Communications, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 5d984b8..c3d8502 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004 Sam Leffler, Errno Consulting
  * Copyright (c) 2004 Video54 Technologies, Inc.
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4f52e04..07e35e5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 456f3ec..c18ee99 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index f9b1eb4..35422fc 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 6095eeb..fde6da6 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Atheros Communications Inc.
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 97dd1fa..3779b89 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
-- 
1.7.5.1


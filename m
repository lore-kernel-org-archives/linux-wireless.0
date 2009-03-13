Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54814 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMDlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:41:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:41:34 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.54515.843518.478641@gargle.gargle.HOWL> (sfid-20090313_044138_854375_D46C468E)
Date: Fri, 13 Mar 2009 09:07:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Update copyright in all the files
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How time flies.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ahb.c         |    2 +-
 drivers/net/wireless/ath9k/ani.c         |    2 +-
 drivers/net/wireless/ath9k/ani.h         |    2 +-
 drivers/net/wireless/ath9k/ath9k.h       |    2 +-
 drivers/net/wireless/ath9k/beacon.c      |    2 +-
 drivers/net/wireless/ath9k/calib.c       |    2 +-
 drivers/net/wireless/ath9k/calib.h       |    2 +-
 drivers/net/wireless/ath9k/debug.c       |    2 +-
 drivers/net/wireless/ath9k/debug.h       |    2 +-
 drivers/net/wireless/ath9k/eeprom.c      |    2 +-
 drivers/net/wireless/ath9k/eeprom.h      |    2 +-
 drivers/net/wireless/ath9k/hw.c          |    2 +-
 drivers/net/wireless/ath9k/hw.h          |    2 +-
 drivers/net/wireless/ath9k/initvals.h    |    2 +-
 drivers/net/wireless/ath9k/mac.c         |    2 +-
 drivers/net/wireless/ath9k/mac.h         |    2 +-
 drivers/net/wireless/ath9k/main.c        |    2 +-
 drivers/net/wireless/ath9k/pci.c         |    2 +-
 drivers/net/wireless/ath9k/phy.c         |    2 +-
 drivers/net/wireless/ath9k/phy.h         |    2 +-
 drivers/net/wireless/ath9k/rc.c          |    2 +-
 drivers/net/wireless/ath9k/rc.h          |    2 +-
 drivers/net/wireless/ath9k/recv.c        |    2 +-
 drivers/net/wireless/ath9k/reg.h         |    2 +-
 drivers/net/wireless/ath9k/regd.c        |    2 +-
 drivers/net/wireless/ath9k/regd.h        |    2 +-
 drivers/net/wireless/ath9k/regd_common.h |    2 +-
 drivers/net/wireless/ath9k/xmit.c        |    2 +-
 28 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index 00cc7bb..0e65c51 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  * Copyright (c) 2009 Gabor Juhos <juhosg@openwrt.org>
  * Copyright (c) 2009 Imre Kaloz <kaloz@openwrt.org>
  *
diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index a39eb76..6c5e887 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath9k/ani.h
index 7315761..08b4e7e 100644
--- a/drivers/net/wireless/ath9k/ani.h
+++ b/drivers/net/wireless/ath9k/ani.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index f6e70b1..2750fc7 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 3fd1b86..e5b0071 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index c9446fb..e2d62e9 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath9k/calib.h
index 32589e0..1c74bd5 100644
--- a/drivers/net/wireless/ath9k/calib.h
+++ b/drivers/net/wireless/ath9k/calib.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 82573ca..fdf9528 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/debug.h b/drivers/net/wireless/ath9k/debug.h
index 065268b..7b0e541 100644
--- a/drivers/net/wireless/ath9k/debug.h
+++ b/drivers/net/wireless/ath9k/debug.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index d7b9cf4..ffc36b0 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 8e5b880..25b68c8 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 7555894..e6ac8e5 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index dc681f0..0b594e0 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/initvals.h b/drivers/net/wireless/ath9k/initvals.h
index 1d60c37..e2f0a34 100644
--- a/drivers/net/wireless/ath9k/initvals.h
+++ b/drivers/net/wireless/ath9k/initvals.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index f757bc7..e0a6dee 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath9k/mac.h
index a75f65d..1176bce 100644
--- a/drivers/net/wireless/ath9k/mac.h
+++ b/drivers/net/wireless/ath9k/mac.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8db75f6..7d27eed 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 53572d9..6dbc585 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index e1494ba..8bcba90 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 1eac8c7..0f7f8e0 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index b32820e..1a3b63d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Video54 Technologies, Inc.
- * Copyright (c) 2004-2008 Atheros Communications, Inc.
+ * Copyright (c) 2004-2009 Atheros Communications, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index db9b0b9..199a3ce 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004 Sam Leffler, Errno Consulting
  * Copyright (c) 2004 Video54 Technologies, Inc.
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 0bba176..917bac7 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index d86e90e..5260524 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index b8f9b6d..4ca6251 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 8f885f3..9f5fbd4 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/regd_common.h b/drivers/net/wireless/ath9k/regd_common.h
index b41d000..4d0e298 100644
--- a/drivers/net/wireless/ath9k/regd_common.h
+++ b/drivers/net/wireless/ath9k/regd_common.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 0aae8f3..8968abe 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008 Atheros Communications Inc.
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
-- 
1.6.2


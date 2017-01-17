Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdAQXfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:35:13 -0500
From: Jes.Sorensen@gmail.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] rtl8xxxu: Update author/maintainer contact info
Date: Tue, 17 Jan 2017 18:18:56 -0500
Message-Id: <20170117231856.5075-6-Jes.Sorensen@gmail.com> (sfid-20170118_003526_425216_335C16B0)
In-Reply-To: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
References: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Update copyright year and email address.

Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
---
 MAINTAINERS                                            | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8df0e1..0b5c80e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10584,7 +10584,7 @@ F:	drivers/net/wireless/realtek/rtlwifi/
 F:	drivers/net/wireless/realtek/rtlwifi/rtl8192ce/
 
 RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
-M:	Jes Sorensen <Jes.Sorensen@redhat.com>
+M:	Jes Sorensen <Jes.Sorensen@gmail.com>
 L:	linux-wireless@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git rtl8xxxu-devel
 S:	Maintained
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index df551b2..95e3993 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index f9e2050..a41a296 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -1,7 +1,7 @@
 /*
  * RTL8XXXU mac80211 USB driver - 8188c/8188r/8192c specific subdriver
  *
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * Portions, notably calibration code:
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index a1178c5..80fee69 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1,7 +1,7 @@
 /*
  * RTL8XXXU mac80211 USB driver - 8192e specific subdriver
  *
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * Portions, notably calibration code:
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index aef3730..1746311 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -1,7 +1,7 @@
 /*
  * RTL8XXXU mac80211 USB driver - 8723a specific subdriver
  *
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * Portions, notably calibration code:
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 02b8ddd..c4b86a8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1,7 +1,7 @@
 /*
  * RTL8XXXU mac80211 USB driver - 8723b specific subdriver
  *
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * Portions, notably calibration code:
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 3585a04..e544dd1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1,7 +1,7 @@
 /*
  * RTL8XXXU mac80211 USB driver
  *
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * Portions, notably calibration code:
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
@@ -48,7 +48,7 @@ static bool rtl8xxxu_dma_aggregation;
 static int rtl8xxxu_dma_agg_timeout = -1;
 static int rtl8xxxu_dma_agg_pages = -1;
 
-MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@redhat.com>");
+MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@gmail.com>");
 MODULE_DESCRIPTION("RTL8XXXu USB mac80211 Wireless LAN Driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE("rtlwifi/rtl8723aufw_A.bin");
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 315ccfb..3d3e2e1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ * Copyright (c) 2014 - 2017 Jes Sorensen <Jes.Sorensen@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64805 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZH1UcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 16:32:16 -0400
Received: by fxm17 with SMTP id 17so1781355fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 13:32:18 -0700 (PDT)
Message-ID: <4A983ED1.9040100@gmail.com>
Date: Fri, 28 Aug 2009 22:32:17 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Add myself to module authors & to LP-PHY file copyright
 notices
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also mark the LP-PHY driver "802.11a/g" instead of "802.11g",
as LP-PHY is capable of both 2GHz and 5GHz operation.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/main.c         |    1 +
 drivers/net/wireless/b43/phy_lp.c       |    3 ++-
 drivers/net/wireless/b43/tables_lpphy.c |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5cc90a2..f2c5b2d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -58,6 +58,7 @@ MODULE_DESCRIPTION("Broadcom B43 wireless driver");
 MODULE_AUTHOR("Martin Langer");
 MODULE_AUTHOR("Stefano Brivio");
 MODULE_AUTHOR("Michael Buesch");
+MODULE_AUTHOR("Gábor Stefanik");
 MODULE_LICENSE("GPL");
 
 MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index fded6e5..5fff30a 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1,9 +1,10 @@
 /*
 
   Broadcom B43 wireless driver
-  IEEE 802.11g LP-PHY driver
+  IEEE 802.11a/g LP-PHY driver
 
   Copyright (c) 2008-2009 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2009 Gábor Stefanik <netrolller.3d@gmail.com>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 3464ac0..61027ee 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -1,9 +1,10 @@
 /*
 
   Broadcom B43 wireless driver
-  IEEE 802.11g LP-PHY and radio device data tables
+  IEEE 802.11a/g LP-PHY and radio device data tables
 
   Copyright (c) 2009 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2009 Gábor Stefanik <netrolller.3d@gmail.com>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
-- 
1.6.2.4




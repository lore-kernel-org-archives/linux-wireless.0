Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2AHCrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:18 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] rtl8192cu: Update copyright dates
Date: Sat,  7 Jan 2012 20:46:45 -0600
Message-Id: <1325990807-13575-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034728_300304_188E5394)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/reg.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h   |    2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
index d097efb..f916555 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
index c0016f3..6fd39ea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
index 7f966c6..d947e7d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 51b7aa1..048d686 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
index 32f85cb..f41a3aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
index 65fd044..75a2deb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.h b/drivers/net/wireless/rtlwifi/rtl8192cu/led.h
index decaee4..0f37227 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/led.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 060ed5f..d028f6f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index 626d88e..bf53652 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index e7ea2ba..8ac3bcc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
index ff81a61..42b0686 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h b/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
index 7f1be61..8b81465 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index e132cb3..780c0d9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
index 500a209..090fd33 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index e6d45eb..269a725 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
index 43b1177..a1310ab 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/table.c b/drivers/net/wireless/rtlwifi/rtl8192cu/table.c
index d57ef5e..966be51 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/table.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/table.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/table.h b/drivers/net/wireless/rtlwifi/rtl8192cu/table.h
index c3d5cd8..4b020e9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/table.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/table.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index e34344e..bde3589 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
index 53de5f6..332b06e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
-- 
1.7.7


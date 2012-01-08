Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2AHCrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:22 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:21 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] rtl8192se: Update copyright dates
Date: Sat,  7 Jan 2012 20:46:47 -0600
Message-Id: <1325990807-13575-9-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034727_727092_9AE9EAFB)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h   |    2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index c6c0448..d1b0a1e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index 4a5e3a9..fbabae1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
index 9051a55..e1b19a6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
index 2a9699f..595ecd22 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
index 74cc503..babe85d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index b03001b..625c9eb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
index 6160a9b..1886c26 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
index 1a6b0ca..ef4211b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.h b/drivers/net/wireless/rtlwifi/rtl8192se/led.h
index 8cce387..2182dbe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/led.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index e24dbb3..adfac56 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.h b/drivers/net/wireless/rtlwifi/rtl8192se/phy.h
index 37e504a..ac03877 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
index 11f125c..84d1181 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 8966b73..46be4cc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.h b/drivers/net/wireless/rtlwifi/rtl8192se/rf.h
index 3843baa..8a29eb9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 098c8a1..ca4b6fe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.h b/drivers/net/wireless/rtlwifi/rtl8192se/sw.h
index fc4eb28..2eb8886 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/table.c b/drivers/net/wireless/rtlwifi/rtl8192se/table.c
index 154185b..f1a73f7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/table.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/table.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/table.h b/drivers/net/wireless/rtlwifi/rtl8192se/table.h
index b4ed6d9..2feb73b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/table.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/table.h
@@ -1,5 +1,5 @@
 /******************************************************************************
- * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Realtek Corporation. All rights reserved.
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 5dbb326..e58b80f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
index 05862c5..011e7b0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
-- 
1.7.7


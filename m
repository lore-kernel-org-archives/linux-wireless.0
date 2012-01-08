Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2AHCrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:13 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:13 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] rtlwifi: Update copyright dates
Date: Sat,  7 Jan 2012 20:46:42 -0600
Message-Id: <1325990807-13575-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034722_770837_62A2401F)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
---
 drivers/net/wireless/rtlwifi/base.c  |    2 +-
 drivers/net/wireless/rtlwifi/base.h  |    2 +-
 drivers/net/wireless/rtlwifi/cam.c   |    2 +-
 drivers/net/wireless/rtlwifi/cam.h   |    2 +-
 drivers/net/wireless/rtlwifi/core.c  |    2 +-
 drivers/net/wireless/rtlwifi/core.h  |    2 +-
 drivers/net/wireless/rtlwifi/debug.c |    2 +-
 drivers/net/wireless/rtlwifi/debug.h |    2 +-
 drivers/net/wireless/rtlwifi/efuse.c |    2 +-
 drivers/net/wireless/rtlwifi/efuse.h |    2 +-
 drivers/net/wireless/rtlwifi/pci.c   |    2 +-
 drivers/net/wireless/rtlwifi/pci.h   |    2 +-
 drivers/net/wireless/rtlwifi/ps.c    |    2 +-
 drivers/net/wireless/rtlwifi/ps.h    |    2 +-
 drivers/net/wireless/rtlwifi/rc.c    |    2 +-
 drivers/net/wireless/rtlwifi/rc.h    |    2 +-
 drivers/net/wireless/rtlwifi/regd.c  |    2 +-
 drivers/net/wireless/rtlwifi/regd.h  |    2 +-
 drivers/net/wireless/rtlwifi/usb.c   |    2 +-
 drivers/net/wireless/rtlwifi/usb.h   |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h  |    2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 4f9676b..2bed01f 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index a7595e2..9ebfdf8 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index cbf5e3c..8fd820d 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/cam.h b/drivers/net/wireless/rtlwifi/cam.h
index c62da4e..35e0008 100644
--- a/drivers/net/wireless/rtlwifi/cam.h
+++ b/drivers/net/wireless/rtlwifi/cam.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index ab6a406..d6e37e6 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index f02824a..a45c389 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * Tmis program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
index 579a05e..0564655 100644
--- a/drivers/net/wireless/rtlwifi/debug.c
+++ b/drivers/net/wireless/rtlwifi/debug.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * Tmis program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/rtlwifi/debug.h
index b024c23..83d1d7b 100644
--- a/drivers/net/wireless/rtlwifi/debug.h
+++ b/drivers/net/wireless/rtlwifi/debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * Tmis program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index a079a31..b24cbe6 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * Tmis program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/efuse.h b/drivers/net/wireless/rtlwifi/efuse.h
index 164daba..2bdea9a 100644
--- a/drivers/net/wireless/rtlwifi/efuse.h
+++ b/drivers/net/wireless/rtlwifi/efuse.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index ed6f6a9..aafbe2d 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index ebe0b42..99d81ed 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index a36dc3d..b151266 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/rtlwifi/ps.h
index 84628e60..1357856 100644
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 4f560d6..c66f08a 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rc.h b/drivers/net/wireless/rtlwifi/rc.h
index 4afa2c2..4d61761 100644
--- a/drivers/net/wireless/rtlwifi/rc.h
+++ b/drivers/net/wireless/rtlwifi/rc.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index c263df2..c1608cd 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/regd.h b/drivers/net/wireless/rtlwifi/regd.h
index d231189..70ef2f4 100644
--- a/drivers/net/wireless/rtlwifi/regd.h
+++ b/drivers/net/wireless/rtlwifi/regd.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 4db06f6..78194e3 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2011  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/rtlwifi/usb.h
index d2a63fb..cdad7c2 100644
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2011  Realtek Corporation. All rights reserved.
+ * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 115969d..72770c6 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
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


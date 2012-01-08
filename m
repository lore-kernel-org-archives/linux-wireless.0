Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2AHCrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:17 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:16 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] rtl8192ce: Update copyright dates
Date: Sat,  7 Jan 2012 20:46:44 -0600
Message-Id: <1325990807-13575-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034723_348393_4F34A841)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h   |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 9fc804d..04c3aef 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
index 6730e68..27b3af8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
index 07dd955..26747fa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 971bd29..c5aced4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
index 07dbe3e..52a3aea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
index 09758f4..8283e9b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.h b/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
index 7dfccea..c576106 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 03ee82e..c64daf2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
index be2c92a..d5e3b70 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index ba5ff04..43806d9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
index 5ef9604..69d720d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
index 39ff036..6c8d56e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 425387a..2d72c95 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
index b7dc326..d2367a5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/table.c b/drivers/net/wireless/rtlwifi/rtl8192ce/table.c
index ba938b9..752f943 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/table.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/table.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/table.h b/drivers/net/wireless/rtlwifi/rtl8192ce/table.h
index 3a6e8b6..8b79161 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/table.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/table.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 41b54d5..d59f12c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009-2010  Realtek Corporation.
+ * Copyright(c) 2009-2012  Realtek Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index c8977a5..efb9ab2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
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


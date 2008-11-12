Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYKLXby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 18:31:54 -0500
Date: Wed, 12 Nov 2008 17:31:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH] rtl8187: Update file authorship in comments
Message-ID: <491b6768.iqQUkTGJLrREsFyl%Larry.Finger@lwfinger.net> (sfid-20081113_003158_731437_3AC57A82)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify the file comments to reflect the current maintainers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -7,6 +7,11 @@
  * Based on the r8187 driver, which is:
  * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
  *
+ * The driver was extended to the RTL8187B in 2008 by:
+ * 	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+ *	Hin-Tak Leung <htl10@users.sourceforge.net>
+ *	Larry Finger <Larry.Finger@lwfinger.net>
+ *
  * Magic delays and register offsets below are taken from the original
  * r8187 driver sources.  Thanks to Realtek for their support!
  *
@@ -27,6 +32,9 @@
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
+MODULE_AUTHOR("Herton Ronaldo Krzesinski <herton@mandriva.com.br>");
+MODULE_AUTHOR("Hin-Tak Leung <htl10@users.sourceforge.net>");
+MODULE_AUTHOR("Larry Finger <Larry.Finger@lwfinger.net>");
 MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
 MODULE_LICENSE("GPL");

 

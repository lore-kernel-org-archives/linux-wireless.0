Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab0FNUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:31 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235972wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/14] rt2x00: Update author rt2800lib
Date: Mon, 14 Jun 2010 22:13:15 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142212.27713.IvDoorn@gmail.com> <201006142212.55156.IvDoorn@gmail.com>
In-Reply-To: <201006142212.55156.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142213.16315.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

rt2800lib has been under development of the rt2x00 project,
so add it to the author string for the module information.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6d4df3e..a83477a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1,9 +1,9 @@
 /*
+	Copyright (C) 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 	Copyright (C) 2009 Gertjan van Wingerde <gwingerde@gmail.com>
 
 	Based on the original rt2800pci.c and rt2800usb.c.
-	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
 	  Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
 	  Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
 	  Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
@@ -41,10 +41,6 @@
 #include "rt2800lib.h"
 #include "rt2800.h"
 
-MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
-MODULE_DESCRIPTION("rt2800 library");
-MODULE_LICENSE("GPL");
-
 /*
  * Register access.
  * All access to the CSR registers will go through the methods
@@ -2761,3 +2757,9 @@ const struct ieee80211_ops rt2800_mac80211_ops = {
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 EXPORT_SYMBOL_GPL(rt2800_mac80211_ops);
+
+MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DESCRIPTION("Ralink RT2800 library");
+MODULE_LICENSE("GPL");
+
-- 
1.6.6.1


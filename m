Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4910 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161486AbXD2VwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 17:52:09 -0400
Date: Sat, 28 Apr 2007 20:28:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] libertas: fix for wireless Kconfig changes
Message-ID: <20070429002844.GA11225@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to change the libertas Kconfig entry to match changes made for
other wireless drivers.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index c4b3dc2..cb09e6b 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -267,7 +267,7 @@ config IPW2200_DEBUG
 
 config LIBERTAS_USB
 	tristate "Marvell Libertas 8388 802.11a/b/g cards"
-	depends on NET_RADIO && USB
+	depends on USB && WLAN_80211
 	select FW_LOADER
 	---help---
 	  A driver for Marvell Libertas 8388 USB devices.
-- 
John W. Linville
linville@tuxdriver.com

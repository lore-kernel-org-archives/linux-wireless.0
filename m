Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60803 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZG0X4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:56:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:56:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wireless: use menuconfig for WLAN_PRE80211 and WLAN_80211
Date: Mon, 27 Jul 2009 16:56:15 -0700
Message-ID: <1248738975-4404-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should make it very clear which are pre-802.11 or not

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ca7a8a3..dda7cc2 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -5,7 +5,7 @@
 menu "Wireless LAN"
 	depends on !S390
 
-config WLAN_PRE80211
+menuconfig WLAN_PRE80211
 	bool "Wireless LAN (pre-802.11)"
 	depends on NETDEVICES
 	---help---
@@ -101,7 +101,7 @@ config PCMCIA_NETWAVE
 	  called netwave_cs.  If unsure, say N.
 
 
-config WLAN_80211
+menuconfig WLAN_80211
 	bool "Wireless LAN (IEEE 802.11)"
 	depends on NETDEVICES
 	---help---
-- 
1.6.3.3


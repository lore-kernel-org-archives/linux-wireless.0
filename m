Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57478 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbaCZUD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:03:27 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so2115354eek.9
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:03:26 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 20/20] rtl818x: Update Kconfig for rtl8187se
Date: Wed, 26 Mar 2014 21:04:37 +0100
Message-Id: <1395864277-5220-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210331_139770_A7AB5504)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update description in Kconfig to state rtl8180 driver
now supports also rtl8187se cards

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
index 3033217..1ce1d55 100644
--- a/drivers/net/wireless/rtl818x/Kconfig
+++ b/drivers/net/wireless/rtl818x/Kconfig
@@ -2,11 +2,11 @@
 # RTL818X Wireless LAN device configuration
 #
 config RTL8180
-	tristate "Realtek 8180/8185 PCI support"
+	tristate "Realtek 8180/8185/8187SE PCI support"
 	depends on MAC80211 && PCI
 	select EEPROM_93CX6
 	---help---
-	  This is a driver for RTL8180 and RTL8185 based cards.
+	  This is a driver for RTL8180, RTL8185 and RTL8187SE based cards.
 	  These are PCI based chips found in cards such as:
 
 	  (RTL8185 802.11g)
-- 
1.8.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15701 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbXLYGlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 01:41:37 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8180: Update Kconfig
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Tue, 25 Dec 2007 01:42:29 -0500
Message-ID: <20071225064229.23919.18483.stgit@tetra.sourmilk.net> (sfid-20071225_064153_558362_35BF3C4A)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should let people know what this is.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/Kconfig |   53 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e4be4bb..f3b8122 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -554,9 +554,60 @@ config USB_ZD1201
 	  module will be called zd1201.
 
 config RTL8180
-	tristate "Realtek 8185 PCI support"
+	tristate "Realtek 8180/8185 PCI support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
 	select EEPROM_93CX6
+	---help---
+	  This is a driver for RTL8180 and RTL8185 based cards.
+	  These are PCI based chips found in cards such as:
+
+	  (RTL8185 802.11g)
+	  A-Link WL54PC
+
+	  (RTL8180 802.11b)
+	  Belkin F5D6020 v3
+	  Belkin F5D6020 v3
+	  Dlink DWL-610
+	  Dlink DWL-510
+	  Netgear MA521
+	  Level-One WPC-0101
+	  Acer Aspire 1357 LMi
+	  VCTnet PC-11B1
+	  Ovislink AirLive WL-1120PCM
+	  Mentor WL-PCI
+	  Linksys WPC11 v4
+	  TrendNET TEW-288PI
+	  D-Link DWL-520 Rev D
+	  Repotec RP-WP7126
+	  TP-Link TL-WN250/251
+	  Zonet ZEW1000
+	  Longshine LCS-8031-R
+	  HomeLine HLW-PCC200
+	  GigaFast WF721-AEX
+	  Planet WL-3553
+	  Encore ENLWI-PCI1-NT
+	  TrendNET TEW-266PC
+	  Gigabyte GN-WLMR101
+	  Siemens-fujitsu Amilo D1840W
+	  Edimax EW-7126
+	  PheeNet WL-11PCIR
+	  Tonze PC-2100T
+	  Planet WL-8303
+	  Dlink DWL-650 v M1
+	  Edimax EW-7106
+	  Q-Tec 770WC
+	  Topcom Skyr@cer 4011b
+	  Roper FreeLan 802.11b (edition 2004)
+	  Wistron Neweb Corp CB-200B
+	  Pentagram HorNET
+	  QTec 775WC
+	  TwinMOS Booming B Series
+	  Micronet SP906BB
+	  Sweex LC700010
+	  Surecom EP-9428
+	  Safecom SWLCR-1100
+
+	  Thanks to Realtek for their support!
 
 config RTL8187
 	tristate "Realtek 8187 USB support"



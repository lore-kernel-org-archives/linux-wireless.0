Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:26419 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYGHLiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 07:38:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2497849wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 04:38:03 -0700 (PDT)
Message-ID: <3ace41890807080438x7d55e67fkc65b0ee69b51d4c6@mail.gmail.com> (sfid-20080708_133807_380736_F32897B4)
Date: Tue, 8 Jul 2008 12:38:02 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@redhat.com,
	flamingice@sourmilk.net, andreamrl@tiscali.it
Subject: [PATCH 6/6] rtl8187: updating Kconfig to support RTL8187B
Cc: herton@mandriva.com.br, Larry.Finger@lwfinger.net, proski@gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187: updating Kconfig to support RTL8187B

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6d1e4de..5e0eda0 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -619,14 +619,20 @@ config RTL8180
 	  Thanks to Realtek for their support!

 config RTL8187
-	tristate "Realtek 8187 USB support"
+	tristate "Realtek 8187 and 8187B USB support"
 	depends on MAC80211 && USB && WLAN_80211 && EXPERIMENTAL
 	select EEPROM_93CX6
 	---help---
-	  This is a driver for RTL8187 based cards.
-	  These are USB based chips found in cards such as:
+	  This is a driver for RTL8187 and RTL8187B based cards.
+	  These are USB based chips found in devices such as:

 	  Netgear WG111v2
+	  Level 1 WNC-0301USB
+	  Micronet SP907GK V5
+	  Encore ENUWI-G2
+	  Trendnet TEW-424UB
+	  ASUS P5B Deluxe
+	  Toshiba Satellite Pro series of laptops

 	  Thanks to Realtek for their support!

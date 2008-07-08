Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n5.bullet.ukl.yahoo.com ([217.146.182.182]:40833 "HELO
	n5.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751548AbYGHGzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 02:55:16 -0400
Message-ID: <48730FD2.2070201@yahoo.co.uk> (sfid-20080708_085520_947540_89C2C6F1)
Date: Tue, 08 Jul 2008 07:57:22 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@redhat.com>, flamingice@sourmilk.net,
	Andrea Merello <andreamrl@tiscali.it>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 6/6] rtl8187: updating Kconfig to support RTL8187B
References: <4873088C.2090603@yahoo.co.uk>
In-Reply-To: <4873088C.2090603@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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



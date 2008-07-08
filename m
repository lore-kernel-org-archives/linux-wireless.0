Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:3924 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYGHQUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 12:20:23 -0400
Received: by qb-out-0506.google.com with SMTP id d8so5878690qbc.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 09:20:23 -0700 (PDT)
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 6/6] rtl8187: updating Kconfig to support RTL8187B
Date: Tue,  8 Jul 2008 17:18:13 +0100
Message-Id: <1215533893-8598-6-git-send-email-HinTak.Leung@gmail.com> (sfid-20080708_182027_756922_8CE53EA8)
In-Reply-To: <1215533893-8598-5-git-send-email-HinTak.Leung@gmail.com>
References: <1215533893-8598-1-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-2-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-3-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-4-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-5-git-send-email-HinTak.Leung@gmail.com>
From: Hin-Tak Leung <hintak.leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/Kconfig |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

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
 
-- 
1.5.5.1


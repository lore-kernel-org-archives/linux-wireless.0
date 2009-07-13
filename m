Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:37856 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZGMXF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 19:05:59 -0400
Received: by ewy26 with SMTP id 26so2913156ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 16:05:58 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH] rtl8187: updating Kconfig with info of branded devices
Date: Tue, 14 Jul 2009 00:05:56 +0100
Message-Id: <1247526356-13632-1-git-send-email-HinTak.Leung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding more detailed info about Asus motherboards and Ralink devices.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 7d5902d..ca7a8a3 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -428,10 +428,12 @@ config RTL8187
 	  Micronet SP907GK V5
 	  Encore ENUWI-G2
 	  Trendnet TEW-424UB
-	  ASUS P5B Deluxe
+	  ASUS P5B Deluxe/P5K Premium motherboards
 	  Toshiba Satellite Pro series of laptops
 	  Asus Wireless Link
 	  Linksys WUSB54GC-EU v2
+	    (v1 = rt73usb; v3 is rt2070-based,
+	     use staging/rt3070 or try rt2800usb)
 
 	  Thanks to Realtek for their support!
 
-- 
1.6.2.5


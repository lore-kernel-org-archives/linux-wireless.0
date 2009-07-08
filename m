Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53035 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZGHUEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 16:04:24 -0400
Message-ID: <4A54FB81.30302@gmail.com>
Date: Wed, 08 Jul 2009 22:03:13 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Linux wireless <linux-wireless@vger.kernel.org>,
	Przemyslaw Kulczycki <azrael@autocom.pl>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: fix supported cards for rtl8187
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different revisions of WUSB54GC-EU use different chipsets -
v2 uses rtl8187, but v3 uses Ralink RT3070.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Przemyslaw Kulczycki <azrael@autocom.pl>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Linux wireless <linux-wireless@vger.kernel.org>
---
 drivers/net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 5bc00db..7d5902d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -431,7 +431,7 @@ config RTL8187
 	  ASUS P5B Deluxe
 	  Toshiba Satellite Pro series of laptops
 	  Asus Wireless Link
-	  Linksys WUSB54GC-EU
+	  Linksys WUSB54GC-EU v2
 
 	  Thanks to Realtek for their support!
 
-- 
1.6.3.3



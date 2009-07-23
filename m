Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30277 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZGWKC2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:02:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:02:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13617.254069.744184@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:32:25 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] ath9k: Trivial fix in Kconfig
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update filename for debug information.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 2d79610..0f4a6d8 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -18,6 +18,6 @@ config ATH9K_DEBUG
 	  Say Y, if you need ath9k to display debug messages.
 	  Pass the debug mask as a module parameter:
 
-	  modprobe ath9k debug=0x00002000
+	  modprobe ath9k debug=0x00000200
 
-	  Look in ath9k/core.h for possible debug masks
+	  Look in ath9k/debug.h for possible debug masks
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52115 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbbCITjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:39:14 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: force FW v1.4.0
Date: Mon,  9 Mar 2015 20:38:38 +0100
Message-Id: <1425929918-860-1-git-send-email-linux@rempel-privat.de> (sfid-20150309_203919_115567_562DB197)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we have offically FW v1.4. Force users to update it and prevent reporting of old bugs.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 51496e7..0248b67 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -18,7 +18,7 @@
 #define HTC_USB_H
 
 #define MAJOR_VERSION_REQ 1
-#define MINOR_VERSION_REQ 3
+#define MINOR_VERSION_REQ 4
 
 #define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
 
-- 
1.9.1


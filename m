Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56481 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaBBJzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 04:55:35 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0McDl1-1VqzLO209f-00JckT for
 <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 10:55:33 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>, stable@vger.kernel.org
Subject: [PATCH] ar5523: fix usb id for Gigaset.
Date: Sun,  2 Feb 2014 10:55:18 +0100
Message-Id: <1391334918-17416-1-git-send-email-linux@rempel-privat.de> (sfid-20140202_105539_756339_FBC89C34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raw id and FW id should be switched.

Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 8aa20df..507d9a9 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1764,7 +1764,7 @@ static struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UG(0x07d1, 0x3a07),	/* D-Link / WUA-2340 rev A1 */
 	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
 	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
-	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
+	AR5523_DEVICE_UG(0x129b, 0x160b),	/* Gigaset / USB stick 108
 						   (CyberTAN Technology) */
 	AR5523_DEVICE_UG(0x16ab, 0x7801),	/* Globalsun / AR5523_1 */
 	AR5523_DEVICE_UX(0x16ab, 0x7811),	/* Globalsun / AR5523_2 */
-- 
1.9.rc1


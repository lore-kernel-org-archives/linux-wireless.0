Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59707 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaGKACa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:30 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so5254688wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/14] wl18xx: change the number of WLAN addrs per chip
Date: Fri, 11 Jul 2014 03:01:37 +0300
Message-Id: <1405036899-27396-13-git-send-email-eliad@wizery.com> (sfid-20140711_022951_980024_2E87B1C6)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Each 18xx chip contains only 2 real MAC addresses
usable for WLAN, forcing us to use the LAA bit
approach to obtain a third MAC address.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/wl18xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index eb7cfe8..6a2b880 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -38,7 +38,7 @@
 #define WL18XX_NUM_TX_DESCRIPTORS 32
 #define WL18XX_NUM_RX_DESCRIPTORS 32
 
-#define WL18XX_NUM_MAC_ADDRESSES 3
+#define WL18XX_NUM_MAC_ADDRESSES 2
 
 #define WL18XX_RX_BA_MAX_SESSIONS 13
 
-- 
1.8.5.1.109.g3d252a9


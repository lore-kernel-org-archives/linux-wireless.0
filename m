Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56798 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaBQKAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 05:00:33 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so15160865pbc.32
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 02:00:29 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, acme@ghostprotocols.net,
	sachin.kamat@linaro.org
Subject: [PATCH 1/1] net: wireless: wl3501_cs: Remove duplicate include
Date: Mon, 17 Feb 2014 15:25:01 +0530
Message-Id: <1392630901-16232-1-git-send-email-sachin.kamat@linaro.org> (sfid-20140217_110040_072682_B04AE80B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux/etherdevice.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/net/wireless/wl3501_cs.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index d24d4a958c67..66bca677c4fa 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -43,7 +43,6 @@
 #include <linux/string.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
-#include <linux/etherdevice.h>
 
 #include <net/iw_handler.h>
 
-- 
1.7.9.5


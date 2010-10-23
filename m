Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58666 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0JWRwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 13:52:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: chunkeey@googlemail.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] carl9170: fix typos
Date: Sat, 23 Oct 2010 19:51:32 +0200
Message-Id: <1287856292-27905-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    2 +-
 drivers/net/wireless/ath/carl9170/main.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 6cf0c9e..b69d319 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -48,7 +48,7 @@
 #include <linux/usb.h>
 #ifdef CONFIG_CARL9170_LEDS
 #include <linux/leds.h>
-#endif /* CONFIG_CARL170_LEDS */
+#endif /* CONFIG_CARL9170_LEDS */
 #ifdef CONFIG_CARL9170_WPC
 #include <linux/input.h>
 #endif /* CONFIG_CARL9170_WPC */
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 3cc99f3..eaa1a08 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1828,7 +1828,7 @@ int carl9170_register(struct ar9170 *ar)
 	err = carl9170_led_register(ar);
 	if (err)
 		goto err_unreg;
-#endif /* CONFIG_CAR9L170_LEDS */
+#endif /* CONFIG_CARL9170_LEDS */
 
 #ifdef CONFIG_CARL9170_WPC
 	err = carl9170_register_wps_button(ar);
-- 
1.7.0.4


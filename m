Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53469 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab0BMRLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 12:11:21 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/3] rtl8187: fix typo in ifdef comment
Date: Sat, 13 Feb 2010 18:10:53 +0100
Message-Id: <1266081054-4910-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1266081054-4910-1-git-send-email-hauke@hauke-m.de>
References: <1266081054-4910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/rtl818x/rtl8187_leds.c |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index f82aa8b..4637337 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -241,5 +241,5 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 	cancel_delayed_work_sync(&priv->led_off);
 	cancel_delayed_work_sync(&priv->led_on);
 }
-#endif /* def CONFIG_RTL8187_LED */
+#endif /* def CONFIG_RTL8187_LEDS */
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.h b/drivers/net/wireless/rtl818x/rtl8187_leds.h
index efe8041..d743c96 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.h
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.h
@@ -54,6 +54,6 @@ struct rtl8187_led {
 void rtl8187_leds_init(struct ieee80211_hw *dev, u16 code);
 void rtl8187_leds_exit(struct ieee80211_hw *dev);
 
-#endif /* def CONFIG_RTL8187_LED */
+#endif /* def CONFIG_RTL8187_LEDS */
 
 #endif /* RTL8187_LED_H */
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53445 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab0BMRLG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 12:11:06 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH 1/3] b43legacy: fix typo in ifdef comment
Date: Sat, 13 Feb 2010 18:10:52 +0100
Message-Id: <1266081054-4910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43legacy/leds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/leds.h b/drivers/net/wireless/b43legacy/leds.h
index 82167a9..9ff6750 100644
--- a/drivers/net/wireless/b43legacy/leds.h
+++ b/drivers/net/wireless/b43legacy/leds.h
@@ -45,7 +45,7 @@ enum b43legacy_led_behaviour {
 void b43legacy_leds_init(struct b43legacy_wldev *dev);
 void b43legacy_leds_exit(struct b43legacy_wldev *dev);
 
-#else /* CONFIG_B43EGACY_LEDS */
+#else /* CONFIG_B43LEGACY_LEDS */
 /* LED support disabled */
 
 struct b43legacy_led {
-- 
1.6.3.3


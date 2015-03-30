Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:32954 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbC3N1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:27:42 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	kvalo@codeaurora.org, davem@davemloft.net, linville@tuxdriver.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] wireless:wl1251: Fix typo in MODULE_DESCRIPTION in wl1251/main.c
Date: Mon, 30 Mar 2015 22:27:47 +0900
Message-Id: <1427722067-8706-1-git-send-email-standby24x7@gmail.com> (sfid-20150330_152746_374464_A9C2EB69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix a spelling typo in MODULE_DESCRIPTION in
wl1251/main.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index d1e9a13..5d54d16 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1608,7 +1608,7 @@ int wl1251_free_hw(struct wl1251 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1251_free_hw);
 
-MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
+MODULE_DESCRIPTION("TI wl1251 Wireless LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
 MODULE_FIRMWARE(WL1251_FW_NAME);
-- 
2.3.4.274.g92e625d


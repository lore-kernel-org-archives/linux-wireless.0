Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47589 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZDNUUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 16:20:37 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: remove module_ stubs
Date: Tue, 14 Apr 2009 22:19:29 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904142219.29935.chunkeey@web.de> (sfid-20090414_234555_570539_0591CF58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig pointed out that these stubs are unnecessary.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
The only reason why I post it, is because it makes the "split up" patch a bit smaller ;)
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index b6ebd48..ad2503a 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2670,15 +2670,3 @@ void p54_free_common(struct ieee80211_hw *dev)
 #endif /* CONFIG_P54_LEDS */
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
-
-static int __init p54_init(void)
-{
-	return 0;
-}
-
-static void __exit p54_exit(void)
-{
-}
-
-module_init(p54_init);
-module_exit(p54_exit);

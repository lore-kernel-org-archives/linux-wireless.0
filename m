Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vervifontaine.sonycom.com ([80.88.33.193]:32837 "EHLO
	pophost.sonytel.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753947Ab0BAQml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 11:42:41 -0500
From: Hamish Guthrie <hamish.guthrie@sonycom.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	cbe-oss-dev@ozlabs.org, Hamish Guthrie <hamish.guthrie@sonycom.com>
Subject: [PATCH] ps3_gelic_wireless: Remove superfluous debug info
Date: Mon,  1 Feb 2010 17:42:38 +0100
Message-Id: <1265042558-12904-1-git-send-email-hamish.guthrie@sonycom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/ps3_gelic_wireless.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index d520e9e..2663b2f 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1449,8 +1449,7 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
 	void *buf = NULL;
 	size_t len;
 
-	pr_debug("%s: <- always=%d essid_len=%d\n", __func__,
-		 always_scan, essid_len);
+	pr_debug("%s: <- always=%d\n", __func__, always_scan);
 	if (mutex_lock_interruptible(&wl->scan_lock))
 		return -ERESTARTSYS;
 
-- 
1.6.2.4


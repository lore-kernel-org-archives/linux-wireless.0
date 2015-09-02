Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbbIBX4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 19:56:44 -0400
Message-ID: <1441238202.13198.5.camel@infradead.org> (sfid-20150903_015647_038887_8FE56C81)
Subject: [PATCH] net/wireless/wl18xx: Add missing MODULE_FIRMWARE
From: Geoff Levand <geoff@infradead.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Dev@lists.96boards.org
Date: Wed, 02 Sep 2015 16:56:42 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the output of 'modinfo --field firmware'.

Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/wireless/ti/wl18xx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 49aca2c..3bbf624 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -2062,3 +2062,4 @@ MODULE_PARM_DESC(num_rx_desc_param,
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
+MODULE_FIRMWARE(WL18XX_CONF_FILE_NAME);
-- 
2.1.0




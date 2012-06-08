Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57738 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760880Ab2FHGbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:09 -0400
Received: by lbbgh12 with SMTP id gh12so1666759lbb.39
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:06 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/5] wl18xx: allow FW-log by default for PG2.0
Date: Fri,  8 Jun 2012 09:30:51 +0300
Message-Id: <1339137055-30095-2-git-send-email-coelho@ti.com> (sfid-20120608_083115_329318_BC0454BF)
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This is supported by new FW versions (.88+).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9cdf24f..c26015b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -600,7 +600,6 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		/* wl18xx uses the same firmware for PLT */
 		wl->plt_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
-			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
 
-- 
1.7.10


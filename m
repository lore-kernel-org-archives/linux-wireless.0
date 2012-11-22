Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54629 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2KVTDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:03:07 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3317571eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:03:06 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/13] wl18xx: make driver operational again
Date: Thu, 22 Nov 2012 14:05:28 +0200
Message-Id: <1353585928-28666-14-git-send-email-eliad@wizery.com> (sfid-20121122_200328_034911_33163711)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we have done updating the driver to the new fw
api, so make the driver operational again.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 420da4ae..271e595 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1414,10 +1414,6 @@ static int wl18xx_setup(struct wl1271 *wl)
 	struct wl18xx_priv *priv = wl->priv;
 	int ret;
 
-	wl1271_error("driver is in transitional commit (due to fw api"
-		     "change) and can't be booted!");
-	return -EINVAL;
-
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
-- 
1.7.6.401.g6a319


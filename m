Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8950 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbKCHSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 02:18:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/5] staging: wilc1000: send_config_pkt: remove unnecessary blank line
Date: Tue, 3 Nov 2015 16:21:01 +0900
Message-ID: <1446535262-19817-4-git-send-email-glen.lee@atmel.com> (sfid-20151103_082138_097257_5E9C1FEC)
In-Reply-To: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
References: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove unnecessary blank line which is reported by checkpatch.pl

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1842f8f..3ddbe23 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -612,7 +612,6 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 					wids[counter].id,
 					wids[counter].val,
 					wids[counter].size);
-
 		}
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-- 
1.9.1


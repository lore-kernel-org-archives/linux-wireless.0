Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26806 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbbKEFfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:35:38 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 22/38] staging: wilc1000: remove do-nothing if condition case.
Date: Thu, 5 Nov 2015 14:36:23 +0900
Message-ID: <1446701799-24870-22-git-send-email-glen.lee@atmel.com> (sfid-20151105_063754_571976_D77943FB)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes do-nothing if condition case.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index aecb89d..94efb4a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -326,9 +326,6 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 		} else {
 			wilc->mac_status = status;
 		}
-
-		if (wilc->mac_status == WILC_MAC_STATUS_CONNECT) {
-		}
 	} else if (flag == WILC_MAC_INDICATE_SCAN) {
 		PRINT_D(GENERIC_DBG, "Scanning ...\n");
 	}
-- 
1.9.1


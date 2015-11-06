Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36943 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:24 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 29/73] staging: wilc1000: remove do-nothing else condition case.
Date: Fri, 6 Nov 2015 11:12:50 +0900
Message-ID: <1446776014-28094-29-git-send-email-glen.lee@atmel.com> (sfid-20151106_033759_724610_A9AA4115)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes do-nothing else condition case.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ce9f45c..b07d229 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -256,8 +256,6 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 		pending_acks_info[pending_base + pending_acks].session_index = session_index;
 		txqe->tcp_PendingAck_index = pending_base + pending_acks;
 		pending_acks++;
-	} else {
-
 	}
 	return 0;
 }
@@ -1630,7 +1628,6 @@ u32 wilc_get_chipid(u8 update)
 			} else {
 				tempchipid = 0x1002b2;
 			}
-		} else {
 		}
 
 		chipid = tempchipid;
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:49 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/73] staging: wilc1000: rename Init_TCP_tracking function
Date: Fri, 6 Nov 2015 11:12:44 +0900
Message-ID: <1446776014-28094-23-git-send-email-glen.lee@atmel.com> (sfid-20151106_033801_872854_763AB624)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Init_TCP_tracking function to init_tcp_tracking
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index df20d4d..df0f5ce 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -222,7 +222,7 @@ u32 pending_base;
 u32 tcp_session;
 u32 pending_acks;
 
-static inline int Init_TCP_tracking(void)
+static inline int init_tcp_tracking(void)
 {
 	return 0;
 }
@@ -1697,7 +1697,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 		goto _fail_;
 	}
 #ifdef	TCP_ACK_FILTER
-	Init_TCP_tracking();
+	init_tcp_tracking();
 #endif
 
 	return 1;
-- 
1.9.1


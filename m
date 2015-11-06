Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36397 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031277AbbKFCKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:10:43 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/73] staging: wilc1000: fixes that open brace { should be on the previous line
Date: Fri, 6 Nov 2015 11:12:24 +0900
Message-ID: <1446776014-28094-3-git-send-email-glen.lee@atmel.com> (sfid-20151106_031045_678135_96A7C2E3)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the error reported by checkpatch.pl
for that open brace { should be on the previous line.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 947c9f9..c94cb13 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1186,8 +1186,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		return;
 	}
 
-	netdev_for_each_mc_addr(ha, dev)
-	{
+	netdev_for_each_mc_addr(ha, dev) {
 		memcpy(multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
 			multicast_mac_addr_list[i][0],
-- 
1.9.1


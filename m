Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14039 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbKZFBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 00:01:02 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: remove unneeded extern variable
Date: Thu, 26 Nov 2015 14:04:03 +0900
Message-ID: <1448514243-14181-5-git-send-email-glen.lee@atmel.com> (sfid-20151126_060106_415887_D2916583)
In-Reply-To: <1448514243-14181-1-git-send-email-glen.lee@atmel.com>
References: <1448514243-14181-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnedded extern variable WILC_WFI_devs[] which is not used.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 68a159f..b9961f0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -227,7 +227,6 @@ struct WILC_WFI_mon_priv {
 
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
-extern struct net_device *WILC_WFI_devs[];
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
 void wilc_rx_complete(struct wilc *wilc);
-- 
1.9.1


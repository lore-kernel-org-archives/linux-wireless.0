Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9721 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBFWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:22:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/10] staging: wilc1000: wilc_wfi_netdevice.h: remove unused variables
Date: Fri, 2 Oct 2015 14:22:05 +0900
Message-ID: <1443763332-7330-3-git-send-email-tony.cho@atmel.com> (sfid-20151002_072250_093661_2E3A098C)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes unused variable already_claim and hWILCWFIDrv_2.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0403bc7..e553b0c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -125,7 +125,6 @@ struct wilc_priv {
 	struct net_device *dev;
 	struct napi_struct napi;
 	tstrWILC_WFIDrv *hWILCWFIDrv;
-	WILC_WFIDrvHandle hWILCWFIDrv_2;
 	tstrHostIFpmkidAttr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_default;
@@ -190,7 +189,6 @@ typedef struct {
 
 	struct net_device *real_ndev;
 #ifdef WILC_SDIO
-	int already_claim;
 	struct sdio_func *wilc_sdio_func;
 #else
 	struct spi_device *wilc_spidev;
-- 
1.9.1


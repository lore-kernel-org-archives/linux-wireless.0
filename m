Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13228 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbJLH7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 29/41] staging: wilc1000: host_infterface.h: remove unused enum tenuWILC_StaFlag
Date: Mon, 12 Oct 2015 16:56:03 +0900
Message-ID: <1444636575-2486-29-git-send-email-tony.cho@atmel.com> (sfid-20151012_095946_438288_0FDA1596)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused enum tenuWILC_StaFlag from the
host_interface.h.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a88fd82..c6dbb6e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -322,26 +322,6 @@ struct host_if_drv {
 	bool IFC_UP;
 };
 
-/*!
- *  @enum               tenuWILC_StaFlag
- *  @brief			Used to decode the station flag set and mask in tstrWILC_AddStaParam
- *  @details
- *  @todo
- *  @sa			tstrWILC_AddStaParam, enum nl80211_sta_flags
- *  @author		Enumeraion's creator
- *  @date			12 July 2012
- *  @version		1.0 Description
- */
-
-typedef enum {
-	WILC_STA_FLAG_INVALID = 0,
-	WILC_STA_FLAG_AUTHORIZED,                       /*!<  station is authorized (802.1X)*/
-	WILC_STA_FLAG_SHORT_PREAMBLE,   /*!< station is capable of receiving frames	with short barker preamble*/
-	WILC_STA_FLAG_WME,                              /*!< station is WME/QoS capable*/
-	WILC_STA_FLAG_MFP,                                      /*!< station uses management frame protection*/
-	WILC_STA_FLAG_AUTHENTICATED             /*!< station is authenticated*/
-} tenuWILC_StaFlag;
-
 struct add_sta_param {
 	u8 au8BSSID[ETH_ALEN];
 	u16 u16AssocID;
-- 
1.9.1


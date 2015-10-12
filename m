Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12940 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbbJLH66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 22/41] staging: wilc1000: remove unused struct WILC_WFIDrvHandle
Date: Mon, 12 Oct 2015 16:55:56 +0900
Message-ID: <1444636575-2486-22-git-send-email-tony.cho@atmel.com> (sfid-20151012_095927_201019_FC692C66)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused the struct WILC_WFIDrvHandle with related
commnets.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index cfe2ced..20fd876 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -192,11 +192,6 @@ typedef void (*wilc_connect_result)(tenuConnDisconnEvent,
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);  /*Remain on channel expiration callback function*/
 typedef void (*wilc_remain_on_chan_ready)(void *); /*Remain on channel callback function*/
 
-/* typedef u32 WILC_WFIDrvHandle; */
-typedef struct {
-	s32 s32Dummy;
-} *WILC_WFIDrvHandle;
-
 /*!
  *  @struct             rcvd_net_info
  *  @brief		Structure to hold Received Asynchronous Network info
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32647 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbbJHBuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/14] staging: wilc1000: remove unused struct WILC_WFIDrvHandle
Date: Thu, 8 Oct 2015 10:49:13 +0900
Message-ID: <1444268961-7551-6-git-send-email-tony.cho@atmel.com> (sfid-20151008_035016_502367_9DA21DB6)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
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
index 401a7f6..1b3dbc5 100644
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


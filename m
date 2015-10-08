Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32683 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbbJHBuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/14] staging: wilc1000: remove unused struct cfg_param_t
Date: Thu, 8 Oct 2015 10:49:14 +0900
Message-ID: <1444268961-7551-7-git-send-email-tony.cho@atmel.com> (sfid-20151008_035024_492138_690C39D7)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused the struct cfg_param_t.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1b3dbc5..b4cc164 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -57,12 +57,6 @@
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
 
-typedef struct {
-	u16 cfg_wid;
-	enum WID_TYPE cfg_type;
-	s8     *pu8Para;
-} cfg_param_t;
-
 typedef struct _tstrStatistics {
 	u8 u8LinkSpeed;
 	s8 s8RSSI;
-- 
1.9.1


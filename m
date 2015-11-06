Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37763 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031120AbbKFCSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 61/73] staging: wilc1000: remove unused typedef wilc_wlan_cfg_func_t
Date: Fri, 6 Nov 2015 11:20:00 +0900
Message-ID: <1446776412-30670-12-git-send-email-glen.lee@atmel.com> (sfid-20151106_031813_169378_E593B825)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused typedef wilc_wlan_cfg_func_t of wilc_wlan.h.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index d15c848..6c784fd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -272,10 +272,6 @@ struct wilc_cfg_frame {
 };
 
 typedef struct {
-	int (*wlan_tx)(u8 *, u32, wilc_tx_complete_func_t);
-} wilc_wlan_cfg_func_t;
-
-typedef struct {
 	int type;
 	u32 seq_no;
 } wilc_cfg_rsp_t;
-- 
1.9.1


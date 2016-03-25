Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49881 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbcCYMU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:29 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/11] staging: wilc1000: removes unused debug flags
Date: Fri, 25 Mar 2016 21:16:52 +0900
Message-ID: <1458908216-12100-7-git-send-email-leo.kim@atmel.com> (sfid-20160325_132032_204593_4D81AB32)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused debug flags.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 83cf84d..119b313 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -15,18 +15,6 @@
 
 /********************************************
  *
- *      Debug Flags
- *
- ********************************************/
-
-#define N_INIT			0x00000001
-#define N_ERR			0x00000002
-#define N_TXQ			0x00000004
-#define N_INTR			0x00000008
-#define N_RXQ			0x00000010
-
-/********************************************
- *
  *      Host Interface Defines
  *
  ********************************************/
-- 
1.9.1


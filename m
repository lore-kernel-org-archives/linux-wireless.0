Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13571 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbbI3JpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:45:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/32] staging: wilc1000: remove PLL_WORKAROUND
Date: Wed, 30 Sep 2015 18:44:18 +0900
Message-ID: <1443606289-25407-1-git-send-email-tony.cho@atmel.com> (sfid-20150930_114535_760133_0231D67D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary definition, PLL_WORKAROUND from the
Makefile. There is no use throughout the driver.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index e965df9..d226ebe 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -9,7 +9,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
 
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
-		-DPLL_WORKAROUND -DAGING_ALG \
+		-DAGING_ALG \
 		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
-- 
1.9.1


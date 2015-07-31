Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44485 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbGaHlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:41:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/28] staging: wilc1000: change type of variable in tstrHostIfSetDrvHandler
Date: Fri, 31 Jul 2015 16:38:27 +0900
Message-ID: <1438328316-30197-20-git-send-email-tony.cho@atmel.com> (sfid-20150731_094107_563780_7FCF02E1)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes u32Address of u32 type with WILC_WFIDrvHandle type in
the structure tstrHostIfSetDrvHandler because u32Address is used to hold
driver handler.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2ced05f..fffbcca 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -269,7 +269,7 @@ typedef struct {
 } tstrWILC_UsrConnReq;
 
 typedef struct {
-	u32 u32Address;
+	WILC_WFIDrvHandle u32Address;
 } tstrHostIfSetDrvHandler;
 
 typedef struct {
-- 
1.9.1


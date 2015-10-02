Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9701 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBFWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:22:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/10] staging: wilc1000: coreconfigurator.c: remove unused struct
Date: Fri, 2 Oct 2015 14:22:04 +0900
Message-ID: <1443763332-7330-2-git-send-email-tony.cho@atmel.com> (sfid-20151002_072246_369583_F86AA04C)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused structure, tstrconfigPktInfo from the
coreconfigurator.c file.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 63fde5b..65a130d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -110,14 +110,6 @@ enum info_element_id {
 	INFOELEM_ID_FORCE_32BIT  = 0xFFFFFFFF
 };
 
-
-typedef struct {
-	char *pcRespBuffer;
-	s32 s32MaxRespBuffLen;
-	s32 s32BytesRead;
-	bool bRespRequired;
-} tstrConfigPktInfo;
-
 /* This function extracts the beacon period field from the beacon or probe   */
 /* response frame.                                                           */
 static inline u16 get_beacon_period(u8 *data)
-- 
1.9.1


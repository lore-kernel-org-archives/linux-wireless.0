Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33880 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbIMK7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 06:59:39 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	Aparna Karuthodi <kdasaparna@gmail.com>
Subject: [PATCH] staging: wilc1000: Added a new line
Date: Sun, 13 Sep 2015 16:31:33 +0530
Message-Id: <1442142093-30207-1-git-send-email-kdasaparna@gmail.com> (sfid-20150913_130005_283809_80086ADB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added a new line after declaration to remove a coding style warning
detected by checkpatch. The warning is given below
WARNING: Missing a blank line after declarations

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ed6ac45..0c964c6 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -2101,6 +2101,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
 {
 	s32 counter = 0, ret = 0;
+
 	if (gpstrWlanOps == NULL) {
 		PRINT_D(CORECONFIG_DBG, "Net Dev is still not initialized\n");
 		return 1;
-- 
1.7.9.5


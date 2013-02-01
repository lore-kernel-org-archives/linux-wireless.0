Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49309 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3BAHrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 02:47:05 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1604673eaa.16
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2013 23:47:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: cc: fix (and rename) define of NAND flash type
Date: Fri,  1 Feb 2013 08:46:56 +0100
Message-Id: <1359704816-2824-1-git-send-email-zajec5@gmail.com> (sfid-20130201_084713_110433_B56571C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma_driver_chipcommon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 9a0e3fa..6a299f4 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -27,7 +27,7 @@
 #define   BCMA_CC_FLASHT_NONE		0x00000000	/* No flash */
 #define   BCMA_CC_FLASHT_STSER		0x00000100	/* ST serial flash */
 #define   BCMA_CC_FLASHT_ATSER		0x00000200	/* Atmel serial flash */
-#define   BCMA_CC_FLASHT_NFLASH		0x00000200	/* NAND flash */
+#define   BCMA_CC_FLASHT_NAND		0x00000300	/* NAND flash */
 #define	  BCMA_CC_FLASHT_PARA		0x00000700	/* Parallel flash */
 #define  BCMA_CC_CAP_PLLT		0x00038000	/* PLL Type */
 #define   BCMA_PLLTYPE_NONE		0x00000000
-- 
1.7.10.4


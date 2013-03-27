Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37148 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab3C0QXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] bcma: export some gpio functions
Date: Wed, 27 Mar 2013 17:23:12 +0100
Message-Id: <1364401392-30360-5-git-send-email-hauke@hauke-m.de> (sfid-20130327_172353_963550_0F9F13BF)
In-Reply-To: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
References: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions will be used by brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 88db0cb..036c674 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -214,6 +214,7 @@ u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value)
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_out);
 
 u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
@@ -226,6 +227,7 @@ u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value)
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_outen);
 
 /*
  * If the bit is set to 0, chipcommon controlls this GPIO,
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34234 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbbLPNZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:25:09 -0500
From: Jiading Gai <jiading.gai.github@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Jiading Gai <jiading.gai.github@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: rtl8723a_hal_init: fixed 4 spelling errors.
Date: Wed, 16 Dec 2015 08:24:58 -0500
Message-Id: <1450272298-5095-1-git-send-email-jiading.gai.github@gmail.com> (sfid-20151216_142541_812407_F6DF369C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed four spelling errors.

Signed-off-by: Jiading Gai <jiading.gai.github@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index ecf54ee..e3dc889 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -1044,7 +1044,7 @@ void rtl8723a_InitAntenna_Selection(struct rtw_adapter *padapter)
 	u8 val;
 
 	val = rtl8723au_read8(padapter, REG_LEDCFG2);
-	/*  Let 8051 take control antenna settting */
+	/*  Let 8051 take control antenna setting */
 	val |= BIT(7);		/*  DPDT_SEL_EN, 0x4C[23] */
 	rtl8723au_write8(padapter, REG_LEDCFG2, val);
 }
@@ -1054,7 +1054,7 @@ void rtl8723a_CheckAntenna_Selection(struct rtw_adapter *padapter)
 	u8 val;
 
 	val = rtl8723au_read8(padapter, REG_LEDCFG2);
-	/*  Let 8051 take control antenna settting */
+	/*  Let 8051 take control antenna setting */
 	if (!(val & BIT(7))) {
 		val |= BIT(7);	/*  DPDT_SEL_EN, 0x4C[23] */
 		rtl8723au_write8(padapter, REG_LEDCFG2, val);
@@ -1066,7 +1066,7 @@ void rtl8723a_DeinitAntenna_Selection(struct rtw_adapter *padapter)
 	u8 val;
 
 	val = rtl8723au_read8(padapter, REG_LEDCFG2);
-	/*  Let 8051 take control antenna settting */
+	/*  Let 8051 take control antenna setting */
 	val &= ~BIT(7);		/*  DPDT_SEL_EN, clear 0x4C[23] */
 	rtl8723au_write8(padapter, REG_LEDCFG2, val);
 }
@@ -1297,7 +1297,7 @@ static void _ResetDigitalProcedure1_92C(struct rtw_adapter *padapter,
 		/*  If we want to SS mode, we can not reset 8051. */
 		if ((val8 & BIT(1)) && padapter->bFWReady) {
 			/* IF fw in RAM code, do reset */
-			/*  2010/08/25 MH Accordign to RD alfred's
+			/*  2010/08/25 MH According to RD alfred's
 			    suggestion, we need to disable other */
 			/*  HRCV INT to influence 8051 reset. */
 			rtl8723au_write8(padapter, REG_FWIMR, 0x20);
-- 
1.9.1


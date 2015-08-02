Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc2s31.hotmail.com ([65.55.111.106]:51065 "EHLO
	BLU004-OMC2S31.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbbHBFGH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 01:06:07 -0400
Message-ID: <BLU437-SMTP188F540F98A449B816EBADB9880@phx.gbl> (sfid-20150802_070627_331614_4D71E053)
Date: Sun, 2 Aug 2015 13:00:58 +0800
From: Ting-Chih Hsiao <s894330@hotmail.com>
To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: fix coding style warnings reported by
 checkpatch.pl.
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 8c86ae927a38693f587826f51fca5d374e756768 Mon Sep 17 00:00:00 2001
From: Ting-Chih Hsiao <s894330@hotmail.com>
Date: Sun, 2 Aug 2015 12:32:19 +0800

Fix a coding style warnings reported by checkpatch.pl.

Signed-off-by: Ting-Chih Hsiao <s894330@hotmail.com>
---
 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
index 342dec3..a63c6cb 100644
--- a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
+++ b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
@@ -21,7 +21,7 @@ odm_ConfigRFReg_8723A(
 	struct dm_odm_t *pDM_Odm,
 	u32					Addr,
 	u32					Data,
-  enum RF_RADIO_PATH     RF_PATH,
+	enum RF_RADIO_PATH     RF_PATH,
 	u32				    RegAddr
 	)
 {
-- 
1.9.1


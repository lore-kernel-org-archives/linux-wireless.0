Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc2s37.hotmail.com ([65.55.111.112]:59672 "EHLO
	BLU004-OMC2S37.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbbHCD6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 23:58:15 -0400
Message-ID: <BLU437-SMTP740B6DF13FC4BBDF43D824B9770@phx.gbl> (sfid-20150803_055827_147207_88040EE3)
From: Ting-Chih Hsiao <s894330@hotmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: fix up coding style warnings reported by checkpatch.pl.
Date: Mon, 3 Aug 2015 11:57:34 +0800
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove spaces at the start of a line
align enum variable with other parameters

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


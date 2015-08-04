Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc2s38.hotmail.com ([65.55.111.113]:55980 "EHLO
	BLU004-OMC2S38.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbbHDDVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 23:21:43 -0400
Message-ID: <BLU436-SMTP5616BB15727645C88DFE5EB9760@phx.gbl> (sfid-20150804_052146_215104_7B13B26D)
From: Ting-Chih Hsiao <s894330@hotmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	linux-wireless@vger.kernel.org
CC: devel@driverdev.osuosl.org
Subject: [PATCH] staging: rtl8723au: fix up coding style warnings reported by checkpatch.pl.
Date: Tue, 4 Aug 2015 11:21:10 +0800
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


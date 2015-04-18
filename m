Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36066 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbDRQfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2015 12:35:25 -0400
Date: Sat, 18 Apr 2015 09:35:19 -0700
From: Edward Lipinsky <ellipinsky@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] Staging: rtl8723au: hal: Remove trailing whitespace in odm.c
Message-ID: <20150418163519.GA48462@gmail.com> (sfid-20150418_183540_577666_6AE871C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl error:

ERROR: trailing whitespace

Signed-off-by: Edward Lipinsky <ellipinsky@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index ec543cf..6bdaa3e 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -388,7 +388,7 @@ void odm_CommonInfoSelfInit23a(struct dm_odm_t *pDM_Odm)
 		pDM_Odm->bCckHighPower = true;
 	else
 		pDM_Odm->bCckHighPower = false;
-		
+
 	pDM_Odm->RFPathRxEnable =
 		rtl8723au_read32(pDM_Odm->Adapter, rOFDM0_TRxPathEnable) & 0x0F;
 
-- 
1.7.9.5


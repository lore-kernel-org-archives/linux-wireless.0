Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0113.outbound.protection.outlook.com ([157.55.234.113]:62237
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932085AbbFTMqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2015 08:46:20 -0400
From: "Joglekar, Tejas (T.)" <tjogleka@visteon.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"rickard_strandqvist@spectrumdigital.se"
	<rickard_strandqvist@spectrumdigital.se>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging:rtl8723au:odm.c:Removing trailing whitespaces
Date: Sat, 20 Jun 2015 12:46:16 +0000
Message-ID: <20150620124603.GA3311@Tejas-asus> (sfid-20150620_144636_453255_CF81BC3A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joglekar Tejas <tjogleka@visteon.com>

This patch removes the trailing whitespace error given
by checkpatch.pl

Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
---
 drivers/staging/rtl8723au/hal/odm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index f354f5e..6b9dbef 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -985,7 +985,7 @@ void ODM_RF_Saving23a(struct dm_odm_t *pDM_Odm, u8 bForceInNormal)
 			val32 = rtl8723au_read32(adapter, 0x874);
 			val32 |= pDM_PSTable->Reg874;
 			rtl8723au_write32(adapter, 0x874, val32);
-		
+
 			val32 = rtl8723au_read32(adapter, 0xc70);
 			val32 |= pDM_PSTable->RegC70;
 			rtl8723au_write32(adapter, 0xc70, val32);
-- 
1.9.1
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

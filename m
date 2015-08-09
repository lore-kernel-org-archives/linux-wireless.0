Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33294 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbbHIQJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 12:09:07 -0400
From: Swee Hua Law <sweehua81@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: aybuke.147@gmail.com, sweehua81@gmail.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Add space after ,
Date: Mon, 10 Aug 2015 00:08:50 +0800
Message-Id: <1439136530-4415-1-git-send-email-sweehua81@gmail.com> (sfid-20150809_180912_564957_19DE55C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add space after , to fix coding style issue

Signed-off-by: Swee Hua Law <sweehua81@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_sreset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_sreset.c b/drivers/staging/rtl8723au/core/rtw_sreset.c
index 29a29d9..48b7723 100644
--- a/drivers/staging/rtl8723au/core/rtw_sreset.c
+++ b/drivers/staging/rtl8723au/core/rtw_sreset.c
@@ -71,7 +71,7 @@ static void sreset_restore_security_station(struct rtw_adapter *padapter)
 			/* pairwise key */
 			rtw_setstakey_cmd23a(padapter, (unsigned char *)psta, true);
 			/* group key */
-			rtw_set_key23a(padapter,&padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
+			rtw_set_key23a(padapter, &padapter->securitypriv, padapter->securitypriv.dot118021XGrpKeyid, 0);
 		}
 	}
 }
-- 
2.1.4


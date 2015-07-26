Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0135.outbound.protection.outlook.com ([157.56.112.135]:47719
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752871AbbGZIOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 04:14:52 -0400
From: "Joglekar, Tejas (T.)" <tjogleka@visteon.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging:rtl8723au:core:rtw_sreset.c:Fix for space related
 error
Date: Sun, 26 Jul 2015 07:40:51 +0000
Message-ID: <20150726074009.GA14066@tejas-asus.domain.name> (sfid-20150726_101528_372359_1E984A7A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joglekar Tejas <tjogleka@visteon.com>

This patch fixes the error given by checkpatch.pl

Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
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
1.9.1

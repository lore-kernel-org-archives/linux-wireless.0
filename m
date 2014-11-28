Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47896 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaK1MQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 07:16:16 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	ruchandani.tina@gmail.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:rtl8723au:core: Fixed checkpatch error
Date: Fri, 28 Nov 2014 17:46:14 +0530
Message-Id: <1417176974-18604-1-git-send-email-andnlnbn18@gmail.com> (sfid-20141128_131632_445488_93F647D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed the checkpatch error:
ERROR: spaces required around that '>'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 44eae8e..9f1cdd4 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -960,7 +960,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 		/*  check traffic for  powersaving. */
 			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
 			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
+			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -1154,7 +1154,7 @@ static void rtw_chk_hi_queue_hdl(struct rtw_adapter *padapter)
 
 			cnt++;
 
-			if (cnt>10)
+			if (cnt > 10)
 				break;
 
 			val = rtl8723a_chk_hi_queue_empty(padapter);
-- 
1.7.9.5


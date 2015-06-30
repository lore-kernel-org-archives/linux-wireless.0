Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38457 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbbF3Ifj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:35:39 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 1/6] staging: wilc1000: modify build error
Date: Tue, 30 Jun 2015 17:34:33 +0900
Message-ID: <1435653278-5168-1-git-send-email-dean.lee@atmel.com> (sfid-20150630_103551_091347_948892E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this function needs more arguments.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 92064db..a8974c2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -675,7 +675,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
-				      pstrDisconnectNotifInfo->ie_len, GFP_KERNEL);
+				      pstrDisconnectNotifInfo->ie_len, true, GFP_KERNEL);
 
 	}
 
-- 
2.4.4


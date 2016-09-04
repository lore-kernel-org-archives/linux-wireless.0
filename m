Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:50446 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbcIDT1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:27:47 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: Matthias Beyer <mail@beyermatthias.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers: staging: rtl8723au: core: Fix checkpatch.pl errors
Date: Sun,  4 Sep 2016 21:26:22 +0200
Message-Id: <20160904192626.17197-2-mail@beyermatthias.de> (sfid-20160904_212807_162380_CA407D40)
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the ERRORs which are reported from the checkpatch.pl
script for this file.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index a786fc4..8b8b6a9 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1397,7 +1397,7 @@ void rtw23a_join_to_handler (unsigned long data)
 				do_join_r = rtw_do_join(adapter);
 				if (do_join_r != _SUCCESS) {
 					DBG_8723A("%s roaming do_join return "
-						  "%d\n", __func__ , do_join_r);
+						  "%d\n", __func__, do_join_r);
 					continue;
 				}
 				break;
@@ -1546,7 +1546,7 @@ static int rtw_check_join_candidate(struct mlme_priv *pmlmepriv,
 	}
 
 	if (!*candidate ||
-	    (*candidate)->network.Rssi<competitor->network.Rssi) {
+	    (*candidate)->network.Rssi < competitor->network.Rssi) {
 		*candidate = competitor;
 		updated = true;
 	}
@@ -1894,7 +1894,7 @@ static int SecIsInPMKIDList(struct rtw_adapter *Adapter, u8 *bssid)
 
 	do {
 		if (psecuritypriv->PMKIDList[i].bUsed &&
-                    ether_addr_equal(psecuritypriv->PMKIDList[i].Bssid, bssid)) {
+		    ether_addr_equal(psecuritypriv->PMKIDList[i].Bssid, bssid)) {
 			break;
 		} else {
 			i++;
@@ -2139,7 +2139,7 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
 			out_len = *pout_len;
 			pframe = rtw_set_ie23a(out_ie + out_len,
 					       WLAN_EID_HT_OPERATION,
-					       p[1], p + 2 , pout_len);
+					       p[1], p + 2, pout_len);
 		}
 	}
 
-- 
2.9.3

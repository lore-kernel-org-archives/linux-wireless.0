Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:50874 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754389AbcIDT3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 15:29:25 -0400
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
Subject: [PATCH 4/5] drivers: staging: rtl8723au: core: Fix "space prohibited" warning
Date: Sun,  4 Sep 2016 21:26:25 +0200
Message-Id: <20160904192626.17197-5-mail@beyermatthias.de> (sfid-20160904_212943_101638_DA806DBF)
In-Reply-To: <20160904192626.17197-1-mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the "space prohibited between function name and open
parenthesis '('" warning from checkpatch.pl

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Signed-off-by: Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 196447b..1e01d62 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -900,15 +900,15 @@ rtw_joinbss_update_stainfo(struct rtw_adapter *padapter,
 				padapter->securitypriv.dot11PrivacyAlgrthm;
 
 			memset(&psta->dot118021x_UncstKey, 0,
-			       sizeof (union Keytype));
+			       sizeof(union Keytype));
 
 			memset(&psta->dot11tkiprxmickey, 0,
-			       sizeof (union Keytype));
+			       sizeof(union Keytype));
 			memset(&psta->dot11tkiptxmickey, 0,
-			       sizeof (union Keytype));
+			       sizeof(union Keytype));
 
-			memset(&psta->dot11txpn, 0, sizeof (union pn48));
-			memset(&psta->dot11rxpn, 0, sizeof (union pn48));
+			memset(&psta->dot11txpn, 0, sizeof(union pn48));
+			memset(&psta->dot11rxpn, 0, sizeof(union pn48));
 		}
 
 		/*	Commented by Albert 2012/07/21 */
-- 
2.9.3

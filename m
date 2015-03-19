Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:41552 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbCSEju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 00:39:50 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, joe@perches.com,
	Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v3 04/15] staging: rtl8723au: Fix the indentation of two lines
Date: Thu, 19 Mar 2015 00:39:07 -0400
Message-Id: <1426739958-18949-5-git-send-email-m.v.b@runbox.com> (sfid-20150319_054253_648974_7CBAD79E)
In-Reply-To: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
References: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct the indentation of two lines in rtw_tkip_encrypt23a function in
rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 17234e0bf1..df1787f20e 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -679,8 +679,8 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 					arcfour_encrypt(&mycontext, payload, payload, length);
 					arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
-				pframe += pxmitpriv->frag_len;
-				pframe  = PTR_ALIGN(pframe, 4);
+					pframe += pxmitpriv->frag_len;
+					pframe  = PTR_ALIGN(pframe, 4);
 				}
 			}
 
-- 
2.1.4


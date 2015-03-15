Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44487 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbbCOAPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:19 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 04/16] staging: rtl8723au: Fix the indentation of two lines
Date: Sat, 14 Mar 2015 20:10:29 -0400
Message-Id: <1426378241-32469-5-git-send-email-m.v.b@runbox.com> (sfid-20150315_011543_128554_2517D91F)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct the indentation of two lines in rtw_tkip_encrypt23a function in
rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index d04a1cf6d7..5bc3514629 100644
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


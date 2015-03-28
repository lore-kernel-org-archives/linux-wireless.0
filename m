Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:57424 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbbC1Mxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:53:54 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	joe@perches.com, Larry.Finger@lwfinger.net, mail@beyermatthias.de,
	m.v.b@runbox.com
Subject: [PATCH v4 04/15] staging: rtl8723au: Fix the indentation of two lines
Date: Sat, 28 Mar 2015 08:52:37 -0400
Message-Id: <1427547168-12078-5-git-send-email-m.v.b@runbox.com> (sfid-20150328_135543_217988_D2FC4B31)
In-Reply-To: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
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


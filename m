Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36416 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbbCMDhF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:05 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 04/16] staging: rtl8723au: Fix the indentation of two lines
Date: Thu, 12 Mar 2015 23:15:20 -0400
Message-Id: <1426216532-24058-5-git-send-email-m.v.b@runbox.com> (sfid-20150313_044030_825723_3BF85FBF)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct the indentation of two lines in rtw_tkip_encrypt23a function in
rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 8f98b215d0..a4a42d6a6d 100644
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


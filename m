Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56109 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYUi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:28 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so6938958wgg.34
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6656: s_vFillTxKey fix indentation of memcpy
Date: Sun, 25 May 2014 21:36:28 +0100
Message-Id: <1401050189-3249-7-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223832_784093_529CE665)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 742559d..f11c2d3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -204,7 +204,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 						pTransmitKey->uKeyLength);
 			if (pTransmitKey->uKeyLength == WLAN_WEP40_KEYLEN) {
 				memcpy(pbyBuf+8, (u8 *)&rev_iv_counter, 3);
-			memcpy(pbyBuf+11, pTransmitKey->abyKey,
+				memcpy(pbyBuf+11, pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 			}
 
-- 
1.9.1


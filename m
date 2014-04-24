Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39123 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494AbaDXQst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 12:48:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] staging: rtl8192e: A word in printk is split into 2 lines
Date: Fri, 25 Apr 2014 01:48:40 +0900
Message-Id: <1398358121-26805-1-git-send-email-standby24x7@gmail.com> (sfid-20140424_184929_539880_90F819EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A word in printk is split into two lines.
Change it into one line.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/rtl8192e/rtl819x_BAProc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_BAProc.c b/drivers/staging/rtl8192e/rtl819x_BAProc.c
index adc6cc7..4d5b0de 100644
--- a/drivers/staging/rtl8192e/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_BAProc.c
@@ -230,8 +230,8 @@ static void rtllib_send_DELBA(struct rtllib_device *ieee, u8 *dst,
 	if (skb)
 		softmac_mgmt_xmit(skb, ieee);
 	else
-		RTLLIB_DEBUG(RTLLIB_DL_ERR, "alloc skb error in func"
-			     "tion %s()\n", __func__);
+		RTLLIB_DEBUG(RTLLIB_DL_ERR, "alloc skb error in function"
+			     " %s()\n", __func__);
 	return ;
 }
 
-- 
2.0.0.rc0.26.g779792a


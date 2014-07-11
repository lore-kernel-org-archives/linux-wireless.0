Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47199 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaGKAJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:32 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so312883wes.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/13] staging: vt6656: rxtx remove static declarations
Date: Fri, 11 Jul 2014 01:08:29 +0100
Message-Id: <1405037311-3666-11-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020938_310658_6622BBF3)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all functions are in visibility order.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index bd96627..733c86e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -82,21 +82,6 @@ static const u16 vnt_fb_opt1[2][5] = {
 #define DATADUR_A_F0    12
 #define DATADUR_A_F1    13
 
-static struct vnt_usb_send_context *vnt_get_free_context(struct vnt_private *);
-
-static unsigned int vnt_get_rsvtime(struct vnt_private *pDevice, u8 byPktType,
-	u32 cbFrameLength, u16 wRate, int bNeedAck);
-
-static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
-	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
-
-static __le16 vnt_get_duration_le(struct vnt_private *pDevice,
-	u8 byPktType, int bNeedAck);
-
-static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv,
-	u8 dur_type, u32 frame_length, u8 pkt_type, u16 rate,
-	int need_ack);
-
 static struct vnt_usb_send_context
 	*vnt_get_free_context(struct vnt_private *priv)
 {
-- 
1.9.1


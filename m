Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59643 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaGMJnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:37 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so2848760wgh.33
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/13] staging: vt6656: remove unused variables bCmdClear and bNeedRadioOFF
Date: Sun, 13 Jul 2014 10:42:44 +0100
Message-Id: <1405244573-10978-4-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114351_502164_61800A98)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 --
 drivers/staging/vt6656/wcmd.c   | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a6eeebc..a1ed376 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -411,8 +411,6 @@ struct vnt_private {
 	u32 uCmdEnqueueIdx;
 	u32 cbFreeCmdQueue;
 	int bCmdRunning;
-	int bCmdClear;
-	int bNeedRadioOFF;
 
 	unsigned long key_entry_inuse;
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index c2da8cc..fa7c7b6 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -211,5 +211,4 @@ void vResetCommandTimer(struct vnt_private *priv)
 	priv->uCmdEnqueueIdx = 0;
 	priv->command_state = WLAN_CMD_IDLE;
 	priv->bCmdRunning = false;
-	priv->bCmdClear = false;
 }
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37074 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476Ab1ELOQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:16:01 -0400
Received: by mail-ew0-f48.google.com with SMTP id 22so486844ewy.7
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] wl12xx: remove unused flag WL1271_FLAG_IDLE_REQUESTED
Date: Thu, 12 May 2011 17:15:40 +0300
Message-Id: <1305209740-30287-8-git-send-email-coelho@ti.com> (sfid-20110512_161607_874986_10342A24)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag is not used anymore, remove it from the list.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 10f0767..ab0c2f1 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -351,7 +351,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSM_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
 	WL1271_FLAG_IDLE,
-	WL1271_FLAG_IDLE_REQUESTED,
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-- 
1.7.1


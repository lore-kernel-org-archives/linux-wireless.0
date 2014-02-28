Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45065 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCAAAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 19:00:07 -0500
Received: by mail-we0-f174.google.com with SMTP id t60so1137101wes.33
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 16:00:06 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/9] staging: vt6656: dead code removetypedef struct tagSQuietControl
Date: Fri, 28 Feb 2014 23:58:38 +0000
Message-Id: <1393631919-16182-8-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010016_095234_945FA3DD)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 1aad3d3..a9784ff 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -276,16 +276,6 @@ typedef struct tagSPMKIDCandidateEvent {
     PMKID_CANDIDATE CandidateList[MAX_PMKIDLIST];
 } SPMKIDCandidateEvent, *PSPMKIDCandidateEvent;
 
-/*++ 802.11h related */
-#define MAX_QUIET_COUNT     8
-
-typedef struct tagSQuietControl {
-    bool        bEnable;
-    u32       dwStartTime;
-    u8        byPeriod;
-    u16        wDuration;
-} SQuietControl, *PSQuietControl;
-
 /* The receive duplicate detection cache entry */
 typedef struct tagSCacheEntry{
     u16        wFmSequence;
-- 
1.9.0


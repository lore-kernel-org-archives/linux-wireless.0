Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37770 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LSQMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:12:02 -0500
Received: by yhr47 with SMTP id 47so4110383yhr.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 08:12:01 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] ath9k: classify DFS debug header further
Date: Mon, 19 Dec 2011 08:11:54 -0800
Message-Id: <1324311114-4566-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111219_171206_942643_13CE2CD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

DFS_DEBUG_H is very generic, instead use something more specific
to ath9k such as ATH9K_DFS_DEBUG_H.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/dfs_debug.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
index 6e1e2a7..4911724 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
@@ -16,8 +16,8 @@
  */
 
 
-#ifndef DFS_DEBUG_H
-#define DFS_DEBUG_H
+#ifndef ATH9K_DFS_DEBUG_H
+#define ATH9K_DFS_DEBUG_H
 
 #include "hw.h"
 
@@ -54,4 +54,4 @@ static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
 
 #endif /* CONFIG_ATH9K_DFS_DEBUGFS */
 
-#endif /* DFS_DEBUG_H */
+#endif /* ATH9K_DFS_DEBUG_H */
-- 
1.7.4.15.g7811d


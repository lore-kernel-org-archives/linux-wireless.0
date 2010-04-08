Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab0DHUIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:08:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: fix typo for LDPC capability
Date: Thu,  8 Apr 2010 16:08:46 -0400
Message-Id: <1270757326-19429-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 740ff6c..6bc9b07 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -176,7 +176,7 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 	if (htc->ht_supported) {
 		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.4x\n", htc->cap);
 
-		PRINT_HT_CAP((htc->cap & BIT(0)), "RX LDCP");
+		PRINT_HT_CAP((htc->cap & BIT(0)), "RX LDPC");
 		PRINT_HT_CAP((htc->cap & BIT(1)), "HT20/HT40");
 		PRINT_HT_CAP(!(htc->cap & BIT(1)), "HT20");
 
-- 
1.6.3.3


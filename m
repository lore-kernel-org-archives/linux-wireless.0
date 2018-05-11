Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40605 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbeEKNZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 09:25:46 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] cfg80211: fix spelling mistake: "uknown" -> "unknown"
Date: Fri, 11 May 2018 14:25:42 +0100
Message-Id: <20180511132542.16304-1-colin.king@canonical.com> (sfid-20180511_152555_891647_155849EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in pr_debug message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 72eb7c6b6e7f..e55099b1785d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3400,7 +3400,7 @@ bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region)
 	case NL80211_DFS_JP:
 		return true;
 	default:
-		pr_debug("Ignoring uknown DFS master region: %d\n", dfs_region);
+		pr_debug("Ignoring unknown DFS master region: %d\n", dfs_region);
 		return false;
 	}
 }
-- 
2.17.0

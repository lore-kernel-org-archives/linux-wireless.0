Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:55572 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbJDIrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 04:47:15 -0400
From: Geliang Tang <geliangtang@163.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix a comment typo
Date: Sun,  4 Oct 2015 16:46:55 +0800
Message-Id: <53a87c6aae6bae712c079bf17ed27d0f1b381016.1443948331.git.geliangtang@163.com> (sfid-20151004_104744_400197_12FA568F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just fix a typo in the code comment.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 30cbafb..b7ac45f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2374,7 +2374,7 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
  * CFG802.11 operation handler for scan request.
  *
  * This function issues a scan request to the firmware based upon
- * the user specified scan configuration. On successfull completion,
+ * the user specified scan configuration. On successful completion,
  * it also informs the results.
  */
 static int
-- 
2.5.0



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:41781 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbbD1Cvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 22:51:32 -0400
Date: Tue, 28 Apr 2015 04:45:09 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: trivial spelling fix (initial)
Message-ID: <20150428044509.23fc3646@mir> (sfid-20150428_045135_632717_F3434D5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduced in 29af20194aedd2f1c26205bb70a395d394845708, "iw: add a
delay option to net-detect".

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 wowlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/wowlan.c b/wowlan.c
index 3a87665..203014b 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -397,7 +397,7 @@ static int print_wowlan_handler(struct nl_msg *msg, void *arg)
 			       nla_get_u32(nd[NL80211_ATTR_SCHED_SCAN_INTERVAL]));
 
 		if (nd[NL80211_ATTR_SCHED_SCAN_DELAY])
-			printf("\tintial scan delay: %u secs\n",
+			printf("\tinitial scan delay: %u secs\n",
 			       nla_get_u32(nd[NL80211_ATTR_SCHED_SCAN_DELAY]));
 
 		if (nd[NL80211_ATTR_SCHED_SCAN_MATCH]) {
-- 
2.1.4


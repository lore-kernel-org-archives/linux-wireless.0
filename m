Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41661 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbZAHBoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:44:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:44:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] cfg80211: fix typo on message after intersection
Date: Wed, 7 Jan 2009 17:43:35 -0800
Message-ID: <1231379017-28363-5-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024412_056976_1F136B69)
In-Reply-To: <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 10a3b11..3d56a1d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1205,7 +1205,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 					"domain intersected: \n");
 		} else
 				printk(KERN_INFO "cfg80211: Current regulatory "
-					"intersected: \n");
+					"domain intersected: \n");
 	} else if (is_world_regdom(rd->alpha2))
 		printk(KERN_INFO "cfg80211: World regulatory "
 			"domain updated:\n");
-- 
1.6.1.rc3.51.g5832d


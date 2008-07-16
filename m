Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbYGPBoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:10 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:09 -0700 (PDT)
Subject: [PATCH 05/12] mac80211: wme.h remove unused QOS_CONTROL_LEN
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:07 -0700
Message-Id: <1216172648.6610.52.camel@brick> (sfid-20080716_034413_363062_CED75F64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux/ieee80211.h now has IEEE80211_QOS_CTL_LEN for this purpose.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wme.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 1aca609..9bc2283 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -14,8 +14,6 @@
 #include <linux/netdevice.h>
 #include "ieee80211_i.h"
 
-#define QOS_CONTROL_LEN 2
-
 #define QOS_CONTROL_ACK_POLICY_NORMAL 0
 #define QOS_CONTROL_ACK_POLICY_NOACK 1
 
-- 
1.5.6.3.499.geae9



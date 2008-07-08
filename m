Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:59192 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYGHUr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 16:47:28 -0400
Received: by yx-out-2324.google.com with SMTP id 8so687168yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 13:47:25 -0700 (PDT)
Subject: [PATCH 1/6] mac80211: wme.h remove unused QOS_CONTROL_LEN
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:47:22 -0700
Message-Id: <1215550042.476.39.camel@brick> (sfid-20080708_224731_854652_21E4B70F)
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
1.5.6.1.322.ge904b



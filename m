Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57169 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbcBZJui (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 04:50:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Fengguang Wu <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: treat as part of mac80211 for MAINTAINERS
Date: Fri, 26 Feb 2016 10:50:34 +0100
Message-Id: <1456480234-5888-1-git-send-email-johannes@sipsolutions.net> (sfid-20160226_105111_134334_24175657)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since I maintain this driver as part of mac80211, add it to
the file list for mac80211; this helps submitters send it to
me instead of Kalle and also makes the build robot apply the
patches for it on the right tree for build attempts.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ded96408efe6..25bdfe6a3c0e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6664,6 +6664,7 @@ S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
 F:	net/mac80211/
+F:	drivers/net/wireless/mac80211_hwsim.[ch]
 
 MACVLAN DRIVER
 M:	Patrick McHardy <kaber@trash.net>
-- 
2.7.0


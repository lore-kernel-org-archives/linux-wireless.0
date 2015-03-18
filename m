Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45320 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754355AbbCRIrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 04:47:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: samueltan@chromium.org, linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2015 10:47:02 +0200
Message-Id: <1426668422-32594-1-git-send-email-luca@coelho.fi> (sfid-20150318_094721_111556_52DB1334)
Subject: [PATCH] nl80211: small clarification of the sched_scan delay attribute
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Just clarify that the delay is only before the first cycle.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ae16ba9..241220c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1754,8 +1754,9 @@ enum nl80211_commands {
  *	should be contained in the result as the sum of the respective counters
  *	over all channels.
  *
- * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
- *	WoWLAN net-detect scan) is started, u32 in seconds.
+ * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before the first cycle of a
+ *	scheduled scan (or a WoWLAN net-detect scan) is started, u32
+ *	in seconds.
 
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0HRL1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 07:27:54 -0400
Subject: [PATCH] mac80211: fix docbook
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 13:27:51 +0200
Message-ID: <1282130871.3664.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix a small problem in the documentation for
ieee80211_request_smps.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-18 13:26:33.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-18 13:26:43.000000000 +0200
@@ -2546,7 +2546,7 @@ void ieee80211_chswitch_done(struct ieee
 /**
  * ieee80211_request_smps - request SM PS transition
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- * @mode: new SM PS mode
+ * @smps_mode: new SM PS mode
  *
  * This allows the driver to request an SM PS transition in managed
  * mode. This is useful when the driver has more information than



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0LAIol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:41 -0500
Message-Id: <20101201084347.920469200@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:29 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] mac80211: publish docs for _ni functions
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Put them along with their "regular" versions for
now, we should write more docs in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:17.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:17.000000000 +0100
@@ -335,8 +335,10 @@
 !Finclude/net/mac80211.h mac80211_rx_flags
 !Finclude/net/mac80211.h ieee80211_tx_info
 !Finclude/net/mac80211.h ieee80211_rx
+!Finclude/net/mac80211.h ieee80211_rx_ni
 !Finclude/net/mac80211.h ieee80211_rx_irqsafe
 !Finclude/net/mac80211.h ieee80211_tx_status
+!Finclude/net/mac80211.h ieee80211_tx_status_ni
 !Finclude/net/mac80211.h ieee80211_tx_status_irqsafe
 !Finclude/net/mac80211.h ieee80211_rts_get
 !Finclude/net/mac80211.h ieee80211_rts_duration



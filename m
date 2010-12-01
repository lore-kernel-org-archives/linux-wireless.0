Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0LAIom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:42 -0500
Message-Id: <20101201084348.134800081@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] mac80211: publish some misc docs
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There isn't a clear TX documentation yet, so
put these into the misc section for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:17.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:18.000000000 +0100
@@ -333,7 +333,11 @@
           <title>functions/definitions</title>
 !Finclude/net/mac80211.h ieee80211_rx_status
 !Finclude/net/mac80211.h mac80211_rx_flags
+!Finclude/net/mac80211.h mac80211_tx_control_flags
+!Finclude/net/mac80211.h mac80211_rate_control_flags
+!Finclude/net/mac80211.h ieee80211_tx_rate
 !Finclude/net/mac80211.h ieee80211_tx_info
+!Finclude/net/mac80211.h ieee80211_tx_info_clear_status
 !Finclude/net/mac80211.h ieee80211_rx
 !Finclude/net/mac80211.h ieee80211_rx_ni
 !Finclude/net/mac80211.h ieee80211_rx_irqsafe
@@ -349,6 +353,7 @@
 !Finclude/net/mac80211.h ieee80211_stop_queue
 !Finclude/net/mac80211.h ieee80211_wake_queues
 !Finclude/net/mac80211.h ieee80211_stop_queues
+!Finclude/net/mac80211.h ieee80211_queue_stopped
         </sect1>
       </chapter>
 
@@ -384,6 +389,9 @@
 !Finclude/net/mac80211.h set_key_cmd
 !Finclude/net/mac80211.h ieee80211_key_conf
 !Finclude/net/mac80211.h ieee80211_key_flags
+!Finclude/net/mac80211.h ieee80211_tkip_key_type
+!Finclude/net/mac80211.h ieee80211_get_tkip_key
+!Finclude/net/mac80211.h ieee80211_key_removed
       </chapter>
 
       <chapter id="powersave">



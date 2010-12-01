Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0LAIop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:45 -0500
Message-Id: <20101201084348.974338441@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/9] mac80211: document station handling
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add some existing documentation about station
handling to a new chapter about advanced APIs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:19.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:20.000000000 +0100
@@ -439,6 +439,16 @@
 !Finclude/net/mac80211.h ieee80211_iterate_active_interfaces_atomic
       </chapter>
 
+      <chapter id="station-handling">
+        <title>Station handling</title>
+        <para>TODO</para>
+!Finclude/net/mac80211.h ieee80211_sta
+!Finclude/net/mac80211.h sta_notify_cmd
+!Finclude/net/mac80211.h ieee80211_find_sta
+!Finclude/net/mac80211.h ieee80211_find_sta_by_ifaddr
+!Finclude/net/mac80211.h ieee80211_sta_block_awake
+      </chapter>
+
       <chapter id="hardware-scan-offload">
         <title>Hardware scan offload</title>
         <para>TBD</para>



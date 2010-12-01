Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab0LAIok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:40 -0500
Message-Id: <20101201084347.735712081@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:28 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] mac80211: document workqueue
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Create a new chapter for the mac80211 workqueue
that contains the documentation written for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:16.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:17.000000000 +0100
@@ -355,6 +355,13 @@
 !Pinclude/net/mac80211.h Frame filtering
 !Finclude/net/mac80211.h ieee80211_filter_flags
       </chapter>
+
+      <chapter id="workqueue">
+        <title>The mac80211 workqueue</title>
+!Pinclude/net/mac80211.h mac80211 workqueue
+!Finclude/net/mac80211.h ieee80211_queue_work
+!Finclude/net/mac80211.h ieee80211_queue_delayed_work
+      </chapter>
     </part>
 
     <part id="advanced">



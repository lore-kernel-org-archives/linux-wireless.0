Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0LAIon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:43 -0500
Message-Id: <20101201084348.347508361@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:31 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] mac80211: publish some rate control docs
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add an API chapter to the rate control part of
the mac80211 book and populate it with some
existing documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:18.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:18.000000000 +0100
@@ -453,9 +453,16 @@
          interface and how it relates to mac80211 and drivers.
         </para>
       </partintro>
-      <chapter id="dummy">
-        <title>dummy chapter</title>
+      <chapter id="ratecontrol-api">
+        <title>Rate Control API</title>
         <para>TBD</para>
+!Finclude/net/mac80211.h ieee80211_start_tx_ba_session
+!Finclude/net/mac80211.h ieee80211_start_tx_ba_cb_irqsafe
+!Finclude/net/mac80211.h ieee80211_stop_tx_ba_session
+!Finclude/net/mac80211.h ieee80211_stop_tx_ba_cb_irqsafe
+!Finclude/net/mac80211.h rate_control_changed
+!Finclude/net/mac80211.h ieee80211_tx_rate_control
+!Finclude/net/mac80211.h rate_control_send_low
       </chapter>
     </part>
 



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0LAIoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:44 -0500
Message-Id: <20101201084348.543929481@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:32 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] mac80211: document aggregation
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Include the aggregation documentation in the
docbook, split up by public and internal docs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:18.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:19.000000000 +0100
@@ -442,6 +442,21 @@
         <para>TBD</para>
 !Finclude/net/mac80211.h ieee80211_scan_completed
       </chapter>
+
+      <chapter id="aggregation">
+        <title>Aggregation</title>
+        <sect1>
+          <title>TX A-MPDU aggregation</title>
+!Pnet/mac80211/agg-tx.c TX A-MPDU aggregation
+!Cnet/mac80211/agg-tx.c
+        </sect1>
+        <sect1>
+          <title>RX A-MPDU aggregation</title>
+!Pnet/mac80211/agg-rx.c RX A-MPDU aggregation
+!Cnet/mac80211/agg-rx.c
+        </sect1>
+!Finclude/net/mac80211.h ieee80211_ampdu_mlme_action
+      </chapter>
     </part>
 
     <part id="rate-control">
@@ -510,6 +525,13 @@
         </sect1>
       </chapter>
 
+      <chapter id="aggregation-internals">
+        <title>Aggregation</title>
+!Fnet/mac80211/sta_info.h sta_ampdu_mlme
+!Fnet/mac80211/sta_info.h tid_ampdu_tx
+!Fnet/mac80211/sta_info.h tid_ampdu_rx
+      </chapter>
+
       <chapter id="synchronisation">
         <title>Synchronisation</title>
         <para>TBD</para>



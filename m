Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0LAIoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:46 -0500
Message-Id: <20101201084349.185273961@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] mac80211: publish SMPS docs
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Create a new chapter about SMPS in the
driver API part of the mac80211 book and
populate it with the existing docs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:20.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:21.000000000 +0100
@@ -469,6 +469,13 @@
         </sect1>
 !Finclude/net/mac80211.h ieee80211_ampdu_mlme_action
       </chapter>
+
+      <chapter id="smps">
+        <title>Spatial Multiplexing Powersave (SMPS)</title>
+!Pinclude/net/mac80211.h Spatial multiplexing power save
+!Finclude/net/mac80211.h ieee80211_request_smps
+!Finclude/net/mac80211.h ieee80211_smps_mode
+      </chapter>
     </part>
 
     <part id="rate-control">



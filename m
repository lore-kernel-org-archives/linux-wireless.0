Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0LAIoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:44:39 -0500
Message-Id: <20101201084347.554113321@sipsolutions.net>
Date: Wed, 01 Dec 2010 09:43:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] cfg80211: include CQM packet loss docs
References: <20101201084326.410001080@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just include them in the list of functions,
there aren't any more detailed docs (yet).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:14.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-12-01 09:43:16.000000000 +0100
@@ -146,6 +146,7 @@
 !Finclude/net/cfg80211.h cfg80211_rx_mgmt
 !Finclude/net/cfg80211.h cfg80211_mgmt_tx_status
 !Finclude/net/cfg80211.h cfg80211_cqm_rssi_notify
+!Finclude/net/cfg80211.h cfg80211_cqm_pktloss_notify
 !Finclude/net/cfg80211.h cfg80211_michael_mic_failure
       </chapter>
       <chapter>



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbXKIICV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:21 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/14] mac80211: adding MAC80211_HT config variable
Date: Fri,  9 Nov 2007 10:01:53 +0200
Message-Id: <11945953311871-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_081156_596147_99F9C0F2)
In-Reply-To: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MAC80211_HT and MAC80211_HT_DEBUG config variables
to separate HT features

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

Index: wl2_6_24_HT/net/mac80211/Kconfig
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/Kconfig
+++ wl2_6_24_HT/net/mac80211/Kconfig
@@ -32,6 +32,13 @@ config MAC80211_LEDS
 	This option enables a few LED triggers for different
 	packet receive/transmit events.
 
+config MAC80211_HT
+	bool "Enable 802.11n HT Features"
+	depends on MAC80211
+	---help---
+	This option enables 802.11n High Throughput features
+	such as MIMO, AMPDU and AMSDU aggregation
+
 config MAC80211_DEBUGFS
 	bool "Export mac80211 internals in DebugFS"
 	depends on MAC80211 && DEBUG_FS
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

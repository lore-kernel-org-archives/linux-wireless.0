Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760196AbXKNPbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:31:08 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/15] mac80211: adding MAC80211_HT config variable
Date: Wed, 14 Nov 2007 17:29:37 +0200
Message-Id: <11950542003748-git-send-email-ron.rindjunsky@intel.com> (sfid-20071114_153149_921487_1BD42BB4)
In-Reply-To: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MAC80211_HT and MAC80211_HT_DEBUG config variables
to separate HT features

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 32c8c08..3c3c8bf 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -51,6 +51,16 @@ config MAC80211_DEBUG
 	  If you are not trying to debug or develop the ieee80211
 	  subsystem, you most likely want to say N here.
 
+config MAC80211_HT_DEBUG
+       bool "Enable HT debugging output"
+       depends on MAC80211_DEBUG
+       ---help---
+       This option enables 802.11n High Throughput features
+       debug tracing output.
+
+       If you are not trying to debug of develop the ieee80211
+       subsystem, you most likely want to say N here.
+
 config MAC80211_VERBOSE_DEBUG
 	bool "Verbose debugging output"
 	depends on MAC80211_DEBUG
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

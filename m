Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXKZOVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:42 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/15] mac80211: adding MAC80211_HT_DEBUG config variable
Date: Mon, 26 Nov 2007 16:14:28 +0200
Message-Id: <11960864902505-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142153_160029_7F201B5C)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MAC80211_HT_DEBUG config variable
to separate HT debug features

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index ce176e6..09711b0 100644
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

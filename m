Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42950 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYFROxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 10:53:52 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: add MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option
Date: Wed, 18 Jun 2008 17:53:43 +0300
Message-Id: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com> (sfid-20080618_165356_927508_5E54ADF8)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yi Zhu <yi.zhu@intel.com>

The patch introduces MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option to
suppress Spectrum Management 802.11h related debug logs.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 590e00b..979fcec 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -177,3 +177,10 @@ config MAC80211_VERBOSE_MPL_DEBUG
 	---help---
 	  Say Y here to print out verbose mesh peer link
 	  debug messages.
+
+config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+	bool "Verbose Spectrum Management (IEEE 802.11h)debugging"
+	depends on MAC80211_DEBUG
+	---help---
+	  Say Y here to print out verbose Spectrum Management (IEEE 802.11h)
+	  debug messages.
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


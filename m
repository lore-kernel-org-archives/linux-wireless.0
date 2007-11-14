Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42705 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbXKNPgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:36:05 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 08/15] iwlwifi: 802.11n remove unnecessary config dependency
Date: Wed, 14 Nov 2007 17:29:44 +0200
Message-Id: <11950542014096-git-send-email-ron.rindjunsky@intel.com> (sfid-20071114_153613_214870_43840D63)
In-Reply-To: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes MAC80211_HT config dependency as it has been
eliminated in mac80211

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index c12120d..ae2d314 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -53,7 +53,7 @@ config IWL4965_SENSITIVITY
 config IWL4965_HT
 	bool "Enable 802.11n HT features in iwl4965 driver"
 	depends on EXPERIMENTAL
-	depends on IWL4965 && MAC80211_HT
+	depends on IWL4965
 	default n
 	---help---
 	  This option enables IEEE 802.11n High Throughput features
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

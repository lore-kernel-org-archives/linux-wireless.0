Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab0AVWXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/17] iwlwifi: is no longer experimental
Date: Fri, 22 Jan 2010 14:22:52 -0800
Message-Id: <1264198978-5915-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

It really hasn't been for a long time, not sure
why this stuck around.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b16b06c..e44e572 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,6 +1,6 @@
 config IWLWIFI
 	tristate "Intel Wireless Wifi"
-	depends on PCI && MAC80211 && EXPERIMENTAL
+	depends on PCI && MAC80211
 	select FW_LOADER
 
 config IWLWIFI_SPECTRUM_MEASUREMENT
-- 
1.6.3.3


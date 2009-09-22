Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZIVXix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 19:38:53 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org
Cc: yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] iwmc3200wifi: select IWMC3200TOP in Kconfig
Date: Wed, 23 Sep 2009 02:38:43 +0300
Message-Id: <1253662724-16497-3-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwmc3200wifi requires iwmc3200top  for its operation

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index c62da43..69faaf1 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -3,6 +3,7 @@ config IWM
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
 	depends on CFG80211
 	select FW_LOADER
+	select IWMC3200TOP
 	help
 	  The Intel Wireless Multicomm 3200 hardware is a combo
 	  card with GPS, Bluetooth, WiMax and 802.11 radios. It
-- 
1.6.0.6

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


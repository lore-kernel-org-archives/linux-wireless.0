Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51720 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3FIQ7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 12:59:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] b43: activate N-PHY and HT-PHY support by default
Date: Sun,  9 Jun 2013 18:59:43 +0200
Message-Id: <1370797183-5510-2-git-send-email-hauke@hauke-m.de> (sfid-20130609_185956_821202_447E6A6C)
In-Reply-To: <1370797183-5510-1-git-send-email-hauke@hauke-m.de>
References: <1370797183-5510-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

N-PHY and HT-PHY support is more or less stable and should be activated
by default.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 078e6f3..83cfaf5 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -111,6 +111,7 @@ config B43_PIO
 config B43_PHY_N
 	bool "Support for 802.11n (N-PHY) devices"
 	depends on B43
+	default y
 	---help---
 	  Support for the N-PHY.
 
@@ -132,6 +133,7 @@ config B43_PHY_LP
 config B43_PHY_HT
 	bool "Support for HT-PHY (high throughput) devices"
 	depends on B43 && B43_BCMA
+	default y
 	---help---
 	  Support for the HT-PHY.
 
-- 
1.7.10.4


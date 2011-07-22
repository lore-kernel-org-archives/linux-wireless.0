Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45925 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab1GVFnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 30/31] ath6kl: remove dependency to wireless extensions
Date: Fri, 22 Jul 2011 08:42:03 +0300
Message-ID: <1311313324-6766-32-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074350_824998_B7D1E27A)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl Kconfig still had dependencies to wext, remove those as they are
not needed anymore.

Now ath6kl should not have any wext code left. Time to have a beer and
celebrate this.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index fc9f69c..3d5f8be 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -2,8 +2,6 @@ config ATH6KL
 	tristate "Atheros ath6kl support"
 	depends on MMC
 	depends on CFG80211
-	select WIRELESS_EXT
-	select WEXT_PRIV
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6003 chipset running over SDIO. If you choose to
-- 
1.7.1


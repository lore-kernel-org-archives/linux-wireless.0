Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:4207 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932154AbZFOT6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:58:17 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 10/11 v2][w-t] iwmc3200wifi: remove select LIB80211 from Kconfig
Date: Mon, 15 Jun 2009 21:59:55 +0200
Message-Id: <0a6dc6dcf80f7c911f3b720e36afd6df293c81f1.1245091931.git.samuel@sortiz.org>
In-Reply-To: <152420b3b2ccbe623cb80cd3cc37d4ced05e470b.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
 <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
 <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
 <445a117dd08007f653105f41f36f9bbf2ed1e4c6.1245091931.git.samuel@sortiz.org>
 <3e375906194bc0105dd43d39260e2a826bf5b557.1245091931.git.samuel@sortiz.org>
 <ef2fab83a02bac39c9547326d419f51789659161.1245091931.git.samuel@sortiz.org>
 <152420b3b2ccbe623cb80cd3cc37d4ced05e470b.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

iwmc3200wifi currently doesn't link with lib80211. So remove
the Kconfig selection.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index 651c0f6..1eccb6d 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -3,7 +3,6 @@ config IWM
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
 	depends on CFG80211
 	select WIRELESS_EXT
-	select LIB80211
 	select FW_LOADER
 
 config IWM_DEBUG
-- 
1.6.3.1


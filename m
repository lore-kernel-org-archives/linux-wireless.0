Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:64620 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761609AbZFOPjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:39:04 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 11/12][w-t] iwmc3200wifi: remove select LIB80211 from Kconfig
Date: Mon, 15 Jun 2009 17:39:27 +0200
Message-Id: <24a1d38ec78a5a86d953e25c07ba4461d4552289.1245076752.git.samuel@sortiz.org>
In-Reply-To: <d23bf33585e775f6432e246ecb232e29cf0b49ed.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
 <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
 <99a6f971c65b2fb751206cff9e428eb60037629b.1245076752.git.samuel@sortiz.org>
 <f3d3b8fac2046f9c26773232c585b4c688b8df03.1245076752.git.samuel@sortiz.org>
 <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
 <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
 <d0765f00e18e0501dc41d8507f05eb03ec940cdc.1245076752.git.samuel@sortiz.org>
 <d23bf33585e775f6432e246ecb232e29cf0b49ed.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
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


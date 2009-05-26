Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZEZDSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 23:18:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Date: Tue, 26 May 2009 11:10:47 +0800
Message-Id: <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

Firmware names can not be longer than 30 characters, and
iwmc3200wifi-lmac-calib-sdio.bin is too long.
Renaming it to iwmc3200wifi-calib-sdio.bin.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index edc0a00..b54da67 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -395,7 +395,7 @@ static struct iwm_if_ops if_sdio_ops = {
 	.debugfs_init = if_sdio_debugfs_init,
 	.debugfs_exit = if_sdio_debugfs_exit,
 	.umac_name = "iwmc3200wifi-umac-sdio.bin",
-	.calib_lmac_name = "iwmc3200wifi-lmac-calib-sdio.bin",
+	.calib_lmac_name = "iwmc3200wifi-calib-sdio.bin",
 	.lmac_name = "iwmc3200wifi-lmac-sdio.bin",
 };
 
-- 
1.6.0.4


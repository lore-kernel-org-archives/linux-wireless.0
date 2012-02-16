Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62922 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2BPGVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:21:15 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20284.41031.366468.457178@gargle.gargle.HOWL> (sfid-20120216_072119_220525_83A88FAE)
Date: Thu, 16 Feb 2012 11:50:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 1/9] ath9k: Remove unnecessary variable initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 68d972b..dc45cf9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1677,10 +1677,5 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
 
-	sc->debug.regidx = 0;
-	memset(&sc->debug.bb_mac_samp, 0, sizeof(sc->debug.bb_mac_samp));
-	sc->debug.sampidx = 0;
-	sc->debug.tsidx = 0;
-	sc->debug.rsidx = 0;
 	return 0;
 }
-- 
1.7.9.1


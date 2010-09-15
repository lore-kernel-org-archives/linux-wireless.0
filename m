Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0IOOWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 10:22:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 07:22:17 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Fix sparse warning: symbol 'ath_ant_div_conf_fast_divbias' was not declared
Date: Wed, 15 Sep 2010 07:22:08 -0700
Message-ID: <1284560528-8934-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6fb3b45..aa9a14d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1338,7 +1338,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 	}
 }
 
-void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
+static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
 {
 	/* Adjust the fast_div_bias based on main and alt lna conf */
 	switch ((ant_conf->main_lna_conf << 4) | ant_conf->alt_lna_conf) {
-- 
1.7.0.4


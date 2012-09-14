Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14345 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2INHpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 03:45:08 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20562.57419.845210.413904@gargle.gargle.HOWL> (sfid-20120914_094512_883651_89AAB22B)
Date: Fri, 14 Sep 2012 13:14:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 3/8] ath9k: Remove a couple of unused variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 96b8331..df0a594 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -596,8 +596,6 @@ struct ath_ant_comb {
 	int main_conf;
 	enum ath9k_ant_div_comb_lna_conf first_quick_scan_conf;
 	enum ath9k_ant_div_comb_lna_conf second_quick_scan_conf;
-	int first_bias;
-	int second_bias;
 	bool first_ratio;
 	bool second_ratio;
 	unsigned long scan_start_time;
-- 
1.7.12


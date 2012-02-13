Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20944 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2BMGUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 01:20:24 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20280.43934.3990.442268@gargle.gargle.HOWL> (sfid-20120213_072029_938732_0847BD5B)
Date: Mon, 13 Feb 2012 11:50:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/7] ath9k: Remove redundant max_streams assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 53a005d..a625c9a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -258,8 +258,6 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	if (AR_SREV_9330(ah) || AR_SREV_9485(ah))
 		max_streams = 1;
-	else if (AR_SREV_9462(ah))
-		max_streams = 2;
 	else if (AR_SREV_9300_20_OR_LATER(ah))
 		max_streams = 3;
 	else
-- 
1.7.9


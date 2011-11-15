Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1KOGGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:06:24 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 18/18] ath9k: fix a typo
Date: Tue, 15 Nov 2011 11:36:14 +0530
Message-ID: <1321337174-13025-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070631_274527_89FC7456)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 4efa489..a41f764 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -21,7 +21,7 @@ enum ath_bt_mode {
 	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
 	ATH_BT_COEX_MODE_UNSLOTTED,     /* untimed/unslotted mode */
 	ATH_BT_COEX_MODE_SLOTTED,       /* slotted mode */
-	ATH_BT_COEX_MODE_DISALBED,      /* coexistence disabled */
+	ATH_BT_COEX_MODE_DISABLED,      /* coexistence disabled */
 };
 
 struct ath_btcoex_config {
-- 
1.7.0.4


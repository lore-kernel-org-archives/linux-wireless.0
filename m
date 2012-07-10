Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62670 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2GJJ0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:26:44 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>
Subject: [PATCH v4 08/10] ath: Add Wake-on-Wireless debug mask
Date: Tue, 10 Jul 2012 14:56:34 +0530
Message-ID: <1341912394-12363-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_112646_873402_32CD351F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

to help the developers and users to debug/know
whats happening with WoW

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 420d69b..6169fbd 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -216,6 +216,7 @@ void ath_printk(const char *level, const struct ath_common *common,
  *	used exclusively for WLAN-BT coexistence starting from
  *	AR9462.
  * @ATH_DBG_DFS: radar datection
+ * @ATH_DBG_WOW: Wake on Wireless
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -243,6 +244,7 @@ enum ATH_DEBUG {
 	ATH_DBG_BSTUCK		= 0x00008000,
 	ATH_DBG_MCI		= 0x00010000,
 	ATH_DBG_DFS		= 0x00020000,
+	ATH_DBG_WOW		= 0x00040000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46692 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeD1WbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Apr 2018 18:31:11 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: ipw2100: fix spelling mistake: "decsribed" -> "described"
Date: Sat, 28 Apr 2018 23:31:08 +0100
Message-Id: <20180428223108.20458-1-colin.king@canonical.com> (sfid-20180429_003133_988425_18922493)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in comment and in the ord_data text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 236b52423506..7c4f550a1475 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3732,7 +3732,7 @@ IPW2100_ORD(STAT_TX_HOST_REQUESTS, "requested Host Tx's (MSDU)"),
 	    IPW2100_ORD(ASSOCIATED_AP_PTR,
 				"0 if not associated, else pointer to AP table entry"),
 	    IPW2100_ORD(AVAILABLE_AP_CNT,
-				"AP's decsribed in the AP table"),
+				"AP's described in the AP table"),
 	    IPW2100_ORD(AP_LIST_PTR, "Ptr to list of available APs"),
 	    IPW2100_ORD(STAT_AP_ASSNS, "associations"),
 	    IPW2100_ORD(STAT_ASSN_FAIL, "association failures"),
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.h b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
index 193947865efd..ce3e35f6b60f 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
@@ -1009,7 +1009,7 @@ typedef enum _ORDINAL_TABLE_1 {	// NS - means Not Supported by FW
 	IPW_ORD_STAT_PERCENT_RETRIES,	// current calculation of % missed tx retries
 	IPW_ORD_ASSOCIATED_AP_PTR,	// If associated, this is ptr to the associated
 	// AP table entry. set to 0 if not associated
-	IPW_ORD_AVAILABLE_AP_CNT,	// # of AP's decsribed in the AP table
+	IPW_ORD_AVAILABLE_AP_CNT,	// # of AP's described in the AP table
 	IPW_ORD_AP_LIST_PTR,	// Ptr to list of available APs
 	IPW_ORD_STAT_AP_ASSNS,	// # of associations
 	IPW_ORD_STAT_ASSN_FAIL,	// # of association failures
-- 
2.17.0

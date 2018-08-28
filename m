Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3195 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeH1SqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 14:46:19 -0400
Date: Tue, 28 Aug 2018 22:53:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Govind Singh <govinds@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [RFC PATCH] ath10k: ath10k_htc_pktlog_svc_supported() can be static
Message-ID: <20180828145327.GA104938@lkp-ib04.lkp.intel.com> (sfid-20180828_165420_402020_FAC480EB)
References: <20180828043642.14890-3-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180828043642.14890-3-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes: c4ce46304e1f ("ath10k: Enable pktlog for WCN3990 target")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 htc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 1727823..4e70ff2 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -872,7 +872,7 @@ static int ath10k_htc_pktlog_connect(struct ath10k *ar)
 	return 0;
 }
 
-bool ath10k_htc_pktlog_svc_supported(struct ath10k *ar)
+static bool ath10k_htc_pktlog_svc_supported(struct ath10k *ar)
 {
 	u8 ul_pipe_id;
 	u8 dl_pipe_id;

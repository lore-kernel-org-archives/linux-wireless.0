Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34077 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbD2Xv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:51:58 -0400
Received: by iget9 with SMTP id t9so950311ige.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:51:57 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 01/11] ath9k: Add a new debug flag for FFT spectral scan
Date: Wed, 29 Apr 2015 23:51:12 +0000
Message-Id: <1430351482-59418-2-git-send-email-mickflemm@gmail.com> (sfid-20150430_015202_454313_FC3DF06B)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FFT spectral scan is a functionality that makes sense to have its own
debug flag.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 7e94810..65ef483 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -251,6 +251,7 @@ void ath_printk(const char *level, const struct ath_common *common,
  * @ATH_DBG_DFS: radar datection
  * @ATH_DBG_WOW: Wake on Wireless
  * @ATH_DBG_DYNACK: dynack handling
+ * @ATH_DBG_SPECTRAL_SCAN: FFT spectral scan
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -280,6 +281,7 @@ enum ATH_DEBUG {
 	ATH_DBG_WOW		= 0x00020000,
 	ATH_DBG_CHAN_CTX	= 0x00040000,
 	ATH_DBG_DYNACK		= 0x00080000,
+	ATH_DBG_SPECTRAL_SCAN	= 0x00100000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
-- 
2.3.5


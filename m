Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48183 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaBMJ4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 04:56:55 -0500
Subject: [PATCH 1/3] ath10k: fix alignment in ath10k_dbg()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Feb 2014 11:56:52 +0200
Message-ID: <20140213095652.13999.63855.stgit@potku.adurom.net> (sfid-20140213_105708_035669_64C24EAF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

checkpatch warning:

drivers/net/wireless/ath/ath10k/debug.h:95: CHECK: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 1773c36..a582499 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -92,7 +92,7 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
 
 #ifdef CONFIG_ATH10K_DEBUG
 __printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
-				      const char *fmt, ...);
+			       const char *fmt, ...);
 void ath10k_dbg_dump(enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);


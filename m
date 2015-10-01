Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48903 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbbJAKvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 06:51:24 -0400
Subject: [PATCH 6/6] ath10k: split an unnecessary long line
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2015 13:51:21 +0300
Message-ID: <20151001105121.8770.73290.stgit@potku.adurom.net> (sfid-20151001_125127_008298_BF5037A8)
In-Reply-To: <20151001105001.8770.96252.stgit@potku.adurom.net>
References: <20151001105001.8770.96252.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from checkpatch:

drivers/net/wireless/ath/ath10k/mac.c:1113: line over 90 characters

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ab0864feb514..75573ece6373 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1110,7 +1110,8 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 
 			ret = ath10k_monitor_stop(ar);
 			if (ret)
-				ath10k_warn(ar, "failed to stop disallowed monitor: %d\n", ret);
+				ath10k_warn(ar, "failed to stop disallowed monitor: %d\n",
+					    ret);
 				/* not serious */
 		}
 


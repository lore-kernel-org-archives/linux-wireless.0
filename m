Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:54826 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJAKut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 06:50:49 -0400
Subject: [PATCH 1/6] ath10k: fix checkpatch warning about logical continuations
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2015 13:50:45 +0300
Message-ID: <20151001105045.8770.44227.stgit@potku.adurom.net> (sfid-20151001_125051_655492_6793C19E)
In-Reply-To: <20151001105001.8770.96252.stgit@potku.adurom.net>
References: <20151001105001.8770.96252.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

checkpatch found:

drivers/net/wireless/ath/ath9k/core.c:490: Logical continuations should be on the previous line

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 879625adc63a..87ad2e998a94 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -486,8 +486,8 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
 
 	if (!(skip_otp || test_bit(ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
-				   ar->fw_features))
-	    && result != 0) {
+				   ar->fw_features)) &&
+	    result != 0) {
 		ath10k_err(ar, "otp calibration failed: %d", result);
 		return -EINVAL;
 	}


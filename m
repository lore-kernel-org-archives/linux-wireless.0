Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbeBIAVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 19:21:51 -0500
From: ryanhsu@codeaurora.org
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: ryanhsu@codeaurora.org
Subject: [PATCH] ath10k: update the IRAM banks number for QCA9377
Date: Thu,  8 Feb 2018 16:20:31 -0800
Message-Id: <1518135631-29796-1-git-send-email-ryanhsu@codeaurora.org> (sfid-20180209_012155_361180_FB85A55A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@codeaurora.org>

QCA9377 firmware update the IRAM banks from 4 to 9.

Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 355db6a..0c1029c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2216,7 +2216,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 		}
 		break;
 	case QCA9377_1_0_DEVICE_ID:
-		return 4;
+		return 9;
 	}
 
 	ath10k_warn(ar, "unknown number of banks, assuming 1\n");
-- 
1.9.1

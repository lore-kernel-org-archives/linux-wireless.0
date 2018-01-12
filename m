Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53245 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754392AbeALJOz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 04:14:55 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath10k: fix spelling mistake: "addrress" -> "address"
Date: Fri, 12 Jan 2018 09:14:50 +0000
Message-Id: <20180112091450.8285-1-colin.king@canonical.com> (sfid-20180112_101525_753626_CF1D3A9F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in warning message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8abaccc25227..f6a23f2d0335 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1484,7 +1484,7 @@ static int ath10k_pci_dump_memory_section(struct ath10k *ar,
 	cur_section = &mem_region->section_table.sections[0];
 
 	if (mem_region->start > cur_section->start) {
-		ath10k_warn(ar, "incorrect memdump region 0x%x with section start addrress 0x%x.\n",
+		ath10k_warn(ar, "incorrect memdump region 0x%x with section start address 0x%x.\n",
 			    mem_region->start, cur_section->start);
 		return 0;
 	}
-- 
2.15.1

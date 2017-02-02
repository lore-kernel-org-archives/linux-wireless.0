Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48715 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdBBKsq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 05:48:46 -0500
Subject: [PATCH 3/3] ath10k: few whitespace fixes
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 2 Feb 2017 12:48:08 +0200
Message-ID: <148603248800.7275.3176753002583396340.stgit@potku.adurom.net> (sfid-20170202_114852_975548_17A53237)
In-Reply-To: <148603246555.7275.3348416808167032391.stgit@potku.adurom.net>
References: <148603246555.7275.3348416808167032391.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

drivers/net/wireless/ath/ath10k/pci.c:1593: Statements should start on a tabstop
drivers/net/wireless/ath/ath10k/ce.c:962: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |    6 +++---
 drivers/net/wireless/ath/ath10k/pci.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index da466ab2d823..4045657e0a6e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -959,9 +959,9 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
 	 */
 	dest_ring->base_addr_owner_space_unaligned =
 		dma_zalloc_coherent(ar->dev,
-				   (nentries * sizeof(struct ce_desc) +
-				    CE_DESC_RING_ALIGN),
-				   &base_addr, GFP_KERNEL);
+				    (nentries * sizeof(struct ce_desc) +
+				     CE_DESC_RING_ALIGN),
+				    &base_addr, GFP_KERNEL);
 	if (!dest_ring->base_addr_owner_space_unaligned) {
 		kfree(dest_ring);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d2aa9e5ec05d..5e84199d68e1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1590,7 +1590,7 @@ void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 		/* TODO: Find appropriate register configuration for QCA99X0
 		 *  to mask irq/MSI.
 		 */
-		 break;
+		break;
 	}
 }
 

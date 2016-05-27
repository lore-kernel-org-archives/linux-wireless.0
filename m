Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44120 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbcE0Oqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 10:46:48 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/5] ath10k: update module description
Date: Fri, 27 May 2016 20:15:57 +0530
Message-ID: <20160527144559.4053-3-rmanohar@qti.qualcomm.com> (sfid-20160527_164651_707100_32E00ECC)
In-Reply-To: <20160527144559.4053-1-rmanohar@qti.qualcomm.com>
References: <20160527144559.4053-1-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update module description to advertise all supported QCA 802.11ac devices.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 drivers/net/wireless/ath/ath10k/pci.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a003980d8972..21b8c8c2a08e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2182,5 +2182,5 @@ void ath10k_core_destroy(struct ath10k *ar)
 EXPORT_SYMBOL(ath10k_core_destroy);
 
 MODULE_AUTHOR("Qualcomm Atheros");
-MODULE_DESCRIPTION("Core module for QCA988X PCIe devices.");
+MODULE_DESCRIPTION("Core module for Qualcomm Atheros 802.11ac wireless LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8e8e1eb4dd0a..7b101a93e619 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3195,7 +3195,7 @@ static void __exit ath10k_pci_exit(void)
 module_exit(ath10k_pci_exit);
 
 MODULE_AUTHOR("Qualcomm Atheros");
-MODULE_DESCRIPTION("Driver support for Atheros QCA988X PCIe devices");
+MODULE_DESCRIPTION("Driver support for Qualcomm Atheros 802.11ac WLAN PCIe/AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* QCA988x 2.0 firmware files */
-- 
2.8.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1ENI3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 04:29:15 -0400
Received: by bwz15 with SMTP id 15so2637305bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 01:29:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add PCI ID of the card found in Thinkpad X120e
Date: Sat, 14 May 2011 10:29:10 +0200
Message-Id: <1305361750-25062-1-git-send-email-zajec5@gmail.com> (sfid-20110514_102920_101656_071E93EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 99dd36e..ffd8797 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -171,6 +171,7 @@ static void bcma_host_pci_remove(struct pci_dev *dev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
-- 
1.7.1


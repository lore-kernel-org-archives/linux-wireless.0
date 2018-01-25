Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45315 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbeAYLOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 06:14:22 -0500
From: Tobias Schramm <tobleminer@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Cc: Tobias Schramm <tobleminer@gmail.com>
Subject: [PATCH v3 1/2] pci: Add vendor id of Ubiquiti Networks
Date: Thu, 25 Jan 2018 12:13:39 +0100
Message-Id: <20180125111340.17553-2-tobleminer@gmail.com> (sfid-20180125_121433_905249_C7FD449D)
In-Reply-To: <20180125111340.17553-1-tobleminer@gmail.com>
References: <20180125111340.17553-1-tobleminer@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Tobias Schramm <tobleminer@gmail.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ab20dc5db423..35871adfdc86 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -149,6 +149,8 @@
 #define PCI_VENDOR_ID_DYNALINK		0x0675
 #define PCI_DEVICE_ID_DYNALINK_IS64PH	0x1702
 
+#define PCI_VENDOR_ID_UBIQUITI		0x0777
+
 #define PCI_VENDOR_ID_BERKOM			0x0871
 #define PCI_DEVICE_ID_BERKOM_A1T		0xffa1
 #define PCI_DEVICE_ID_BERKOM_T_CONCEPT		0xffa2
-- 
2.16.0

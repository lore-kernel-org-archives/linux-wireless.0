Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33062 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeISRUa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:20:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id v90-v6so5475216wrc.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 04:42:58 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: add mt7650 PCI ID
Date: Wed, 19 Sep 2018 13:42:44 +0200
Message-Id: <6015cdd8ec0bda955107f235487cb8a75fd4e04c.1537356982.git.lorenzo.bianconi@redhat.com> (sfid-20180919_134301_846532_9D7AAFF2)
In-Reply-To: <cover.1537356982.git.lorenzo.bianconi@redhat.com>
References: <cover.1537356982.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt7650 PCI id found on ASUS rt-51ac to pci_device_id table

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
This patch is based on top of Felix's pull request:
https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-09-19
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index eb383f96ec9a..c5e47bc70202 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -65,6 +65,7 @@ mt76x0e_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id mt76x0e_device_table[] = {
 	{ PCI_DEVICE(0x14c3, 0x7630) },
+	{ PCI_DEVICE(0x14c3, 0x7650) },
 	{ },
 };
 
-- 
2.17.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52923 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758200AbcILN0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:26:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8CDPgf3028631
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:26:08 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25chpmpamn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:26:08 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: firmware name correction for usb8997 chipset
Date: Mon, 12 Sep 2016 18:55:28 +0530
Message-ID: <1473686728-8101-3-git-send-email-akarwar@marvell.com> (sfid-20160912_152613_466695_558E6794)
In-Reply-To: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
References: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Similar to pcie8997 chipset, first firmware submitted for usb8997
chipset will be usbusb8997_combo_v4.bin. This patch corrects the
name used in driver.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index 1b49c52..30e8eb8 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -46,7 +46,7 @@
 #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
 #define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
-#define USB8997_DEFAULT_FW_NAME	"mrvl/usb8997_uapsta.bin"
+#define USB8997_DEFAULT_FW_NAME	"mrvl/usbusb8997_combo_v4.bin"
 
 #define FW_DNLD_TX_BUF_SIZE	620
 #define FW_DNLD_RX_BUF_SIZE	2048
-- 
1.9.1

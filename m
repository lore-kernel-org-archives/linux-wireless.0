Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55887 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZHXVeU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 17:34:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwmc3200: add more SDIO device ids
Date: Tue, 25 Aug 2009 00:34:19 +0300
Message-Id: <1251149659-32212-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add WiFi BGN SKU and WiMAX 2.4GHz SKU device ids

Cc:inaky.perez-gonzalez@intel.com
Cc:cindy.h.kao@intel.com
Cc:yi.zhu@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/mmc/sdio_ids.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 2dbfb5a..addd456 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -28,6 +28,8 @@
 #define SDIO_DEVICE_ID_INTEL_IWMC3200TOP	0x1404
 #define SDIO_DEVICE_ID_INTEL_IWMC3200GPS	0x1405
 #define SDIO_DEVICE_ID_INTEL_IWMC3200BT		0x1406
+#define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX_24	0x1407
+#define SDIO_DEVICE_ID_INTEL_IWMC3200WIFI_BGN	0x1408
 
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
-- 
1.6.0.6

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


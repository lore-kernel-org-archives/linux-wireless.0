Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53617 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZKGV7h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 16:59:37 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 21:59:38 +0000
Message-ID: <1257631178.15927.459.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 49/75] iwmc3200wifi: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwmc3200wifi/sdio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index cf86294..a7ec7ea 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -399,6 +399,9 @@ static struct iwm_if_ops if_sdio_ops = {
 	.calib_lmac_name = "iwmc3200wifi-calib-sdio.bin",
 	.lmac_name = "iwmc3200wifi-lmac-sdio.bin",
 };
+MODULE_FIRMWARE("iwmc3200wifi-umac-sdio.bin");
+MODULE_FIRMWARE("iwmc3200wifi-calib-sdio.bin");
+MODULE_FIRMWARE("iwmc3200wifi-lmac-sdio.bin");
 
 static int iwm_sdio_probe(struct sdio_func *func,
 			  const struct sdio_device_id *id)
-- 
1.6.5.2




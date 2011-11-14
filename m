Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45046 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1KNRbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:19 -0500
Subject: [PATCH 07/10] ath6kl: add ar6004 firmwares to sdio module
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:31:15 +0200
Message-ID: <20111114173115.29925.67131.stgit@localhost6.localdomain6> (sfid-20111114_183126_430415_968E8551)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding ar6004 SDIO support I forgot to add corresponding
MODULE_FIRMWARE() definitions to sdio.c.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 1dab96a..c2010bf 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1339,3 +1339,9 @@ MODULE_FIRMWARE(AR6003_HW_2_1_1_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_1_1_PATCH_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38021 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933715AbeEIH5q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 03:57:46 -0400
Received: by mail-lf0-f68.google.com with SMTP id z142-v6so6339498lff.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 00:57:46 -0700 (PDT)
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths
Date: Wed,  9 May 2018 09:56:33 +0200
Message-Id: <20180509075633.3030-1-marcus.folkesson@gmail.com> (sfid-20180509_095750_368146_667A2D39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index b8bdabe73073..23467e9fefeb 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -85,11 +85,11 @@ enum qca9377_chip_id_rev {
 	QCA9377_HW_1_1_CHIP_ID_REV = 0x1,
 };
 
-#define QCA6174_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
+#define QCA6174_HW_2_1_FW_DIR		ATH10K_FW_DIR "/QCA6174/hw2.1"
 #define QCA6174_HW_2_1_BOARD_DATA_FILE	"board.bin"
 #define QCA6174_HW_2_1_PATCH_LOAD_ADDR	0x1234
 
-#define QCA6174_HW_3_0_FW_DIR		"ath10k/QCA6174/hw3.0"
+#define QCA6174_HW_3_0_FW_DIR		ATH10K_FW_DIR "/QCA6174/hw3.0"
 #define QCA6174_HW_3_0_BOARD_DATA_FILE	"board.bin"
 #define QCA6174_HW_3_0_PATCH_LOAD_ADDR	0x1234
 
-- 
2.16.2

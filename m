Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57165 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752788AbeDRLrz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:47:55 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rt2x00: fix spelling mistake in various macros, UKNOWN -> UNKNOWN
Date: Wed, 18 Apr 2018 12:47:50 +0100
Message-Id: <20180418114750.1978-1-colin.king@canonical.com> (sfid-20180418_134812_332277_FF5A678A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Rename several macros that contain mispellings of UNKNOWN

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 6a8c93fb6a43..8eccfbb5d6f8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -1193,10 +1193,10 @@
 #define TX_PWR_CFG_3_MCS13		FIELD32(0x000000f0)
 #define TX_PWR_CFG_3_MCS14		FIELD32(0x00000f00)
 #define TX_PWR_CFG_3_MCS15		FIELD32(0x0000f000)
-#define TX_PWR_CFG_3_UKNOWN1		FIELD32(0x000f0000)
-#define TX_PWR_CFG_3_UKNOWN2		FIELD32(0x00f00000)
-#define TX_PWR_CFG_3_UKNOWN3		FIELD32(0x0f000000)
-#define TX_PWR_CFG_3_UKNOWN4		FIELD32(0xf0000000)
+#define TX_PWR_CFG_3_UNKNOWN1		FIELD32(0x000f0000)
+#define TX_PWR_CFG_3_UNKNOWN2		FIELD32(0x00f00000)
+#define TX_PWR_CFG_3_UNKNOWN3		FIELD32(0x0f000000)
+#define TX_PWR_CFG_3_UNKNOWN4		FIELD32(0xf0000000)
 /* bits for 3T devices */
 #define TX_PWR_CFG_3_MCS12_CH0		FIELD32(0x0000000f)
 #define TX_PWR_CFG_3_MCS12_CH1		FIELD32(0x000000f0)
@@ -1216,10 +1216,10 @@
  * TX_PWR_CFG_4:
  */
 #define TX_PWR_CFG_4			0x1324
-#define TX_PWR_CFG_4_UKNOWN5		FIELD32(0x0000000f)
-#define TX_PWR_CFG_4_UKNOWN6		FIELD32(0x000000f0)
-#define TX_PWR_CFG_4_UKNOWN7		FIELD32(0x00000f00)
-#define TX_PWR_CFG_4_UKNOWN8		FIELD32(0x0000f000)
+#define TX_PWR_CFG_4_UNKNOWN5		FIELD32(0x0000000f)
+#define TX_PWR_CFG_4_UNKNOWN6		FIELD32(0x000000f0)
+#define TX_PWR_CFG_4_UNKNOWN7		FIELD32(0x00000f00)
+#define TX_PWR_CFG_4_UNKNOWN8		FIELD32(0x0000f000)
 /* bits for 3T devices */
 #define TX_PWR_CFG_4_STBC4_CH0		FIELD32(0x0000000f)
 #define TX_PWR_CFG_4_STBC4_CH1		FIELD32(0x000000f0)
-- 
2.17.0

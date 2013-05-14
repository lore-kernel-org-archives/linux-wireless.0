Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42284 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642Ab3ENBSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:18:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 15/17] mwifiex: remove unnecessary macros in sdio.h
Date: Mon, 13 May 2013 18:14:59 -0700
Message-ID: <1368494101-23651-16-git-send-email-bzhao@marvell.com> (sfid-20130514_031816_341108_20511A8C)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

They are not used in the code.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.h | 51 -------------------------------------
 1 file changed, 51 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index e4016d2..339608b 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -66,14 +66,8 @@
 
 /* Host Control Registers : Configuration */
 #define CONFIGURATION_REG		0x00
-/* Host Control Registers : Host without Command 53 finish host*/
-#define HOST_TO_CARD_EVENT       (0x1U << 3)
-/* Host Control Registers : Host without Command 53 finish host */
-#define HOST_WO_CMD53_FINISH_HOST	(0x1U << 2)
 /* Host Control Registers : Host power up */
 #define HOST_POWER_UP			(0x1U << 1)
-/* Host Control Registers : Host power down */
-#define HOST_POWER_DOWN			(0x1U << 0)
 
 /* Host Control Registers : Host interrupt mask */
 #define HOST_INT_MASK_REG		0x02
@@ -93,60 +87,15 @@
 
 /* Host Control Registers : Host interrupt RSR */
 #define HOST_INT_RSR_REG		0x01
-/* Host Control Registers : Upload host interrupt RSR */
-#define UP_LD_HOST_INT_RSR		(0x1U)
 
 /* Host Control Registers : Host interrupt status */
 #define HOST_INT_STATUS_REG		0x28
-/* Host Control Registers : Upload CRC error */
-#define UP_LD_CRC_ERR			(0x1U << 2)
-/* Host Control Registers : Upload restart */
-#define UP_LD_RESTART                   (0x1U << 1)
-/* Host Control Registers : Download restart */
-#define DN_LD_RESTART                   (0x1U << 0)
 
 /* Card Control Registers : Card I/O ready */
 #define CARD_IO_READY                   (0x1U << 3)
-/* Card Control Registers : CIS card ready */
-#define CIS_CARD_RDY                    (0x1U << 2)
-/* Card Control Registers : Upload card ready */
-#define UP_LD_CARD_RDY                  (0x1U << 1)
 /* Card Control Registers : Download card ready */
 #define DN_LD_CARD_RDY                  (0x1U << 0)
 
-/* Card Control Registers : Host interrupt mask register */
-#define HOST_INTERRUPT_MASK_REG         0x34
-/* Card Control Registers : Host power interrupt mask */
-#define HOST_POWER_INT_MASK             (0x1U << 3)
-/* Card Control Registers : Abort card interrupt mask */
-#define ABORT_CARD_INT_MASK             (0x1U << 2)
-/* Card Control Registers : Upload card interrupt mask */
-#define UP_LD_CARD_INT_MASK             (0x1U << 1)
-/* Card Control Registers : Download card interrupt mask */
-#define DN_LD_CARD_INT_MASK             (0x1U << 0)
-
-/* Card Control Registers : Card interrupt status register */
-#define CARD_INTERRUPT_STATUS_REG       0x38
-/* Card Control Registers : Power up interrupt */
-#define POWER_UP_INT                    (0x1U << 4)
-/* Card Control Registers : Power down interrupt */
-#define POWER_DOWN_INT                  (0x1U << 3)
-
-/* Card Control Registers : Card interrupt RSR register */
-#define CARD_INTERRUPT_RSR_REG          0x3c
-/* Card Control Registers : Power up RSR */
-#define POWER_UP_RSR                    (0x1U << 4)
-/* Card Control Registers : Power down RSR */
-#define POWER_DOWN_RSR                  (0x1U << 3)
-
-/* Host F1 card ready */
-#define HOST_F1_CARD_RDY		0x0020
-
-/* Rx length register */
-#define CARD_RX_LEN_REG			0x62
-/* Rx unit register */
-#define CARD_RX_UNIT_REG		0x63
-
 /* Max retry number of CMD53 write */
 #define MAX_WRITE_IOMEM_RETRY		2
 
-- 
1.8.2.3


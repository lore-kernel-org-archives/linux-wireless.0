Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:53231 "HELO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753023Ab2DMCIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 22:08:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, <stable@vger.kernel.org>,
	#@marvell.com, 3.2.y@marvell.com, 3.3.y@marvell.com
Subject: [PATCH 3.4] mwifiex: update pcie8766 scratch register addresses
Date: Thu, 12 Apr 2012 19:00:35 -0700
Message-Id: <1334282435-29657-1-git-send-email-bzhao@marvell.com> (sfid-20120413_040852_111175_4C81528A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scratch register addresses have been changed for newer chips.
Since the old chip was never shipped and it will not be supported
any more, just update register addresses to support the new chips.

Cc: <stable@vger.kernel.org> # 3.2.y, 3.3.y
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 445ff21..2f218f9 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -48,15 +48,15 @@
 #define PCIE_HOST_INT_STATUS_MASK			0xC3C
 #define PCIE_SCRATCH_2_REG				0xC40
 #define PCIE_SCRATCH_3_REG				0xC44
-#define PCIE_SCRATCH_4_REG				0xCC0
-#define PCIE_SCRATCH_5_REG				0xCC4
-#define PCIE_SCRATCH_6_REG				0xCC8
-#define PCIE_SCRATCH_7_REG				0xCCC
-#define PCIE_SCRATCH_8_REG				0xCD0
-#define PCIE_SCRATCH_9_REG				0xCD4
-#define PCIE_SCRATCH_10_REG				0xCD8
-#define PCIE_SCRATCH_11_REG				0xCDC
-#define PCIE_SCRATCH_12_REG				0xCE0
+#define PCIE_SCRATCH_4_REG				0xCD0
+#define PCIE_SCRATCH_5_REG				0xCD4
+#define PCIE_SCRATCH_6_REG				0xCD8
+#define PCIE_SCRATCH_7_REG				0xCDC
+#define PCIE_SCRATCH_8_REG				0xCE0
+#define PCIE_SCRATCH_9_REG				0xCE4
+#define PCIE_SCRATCH_10_REG				0xCE8
+#define PCIE_SCRATCH_11_REG				0xCEC
+#define PCIE_SCRATCH_12_REG				0xCF0
 
 #define CPU_INTR_DNLD_RDY				BIT(0)
 #define CPU_INTR_DOOR_BELL				BIT(1)
-- 
1.7.0.2


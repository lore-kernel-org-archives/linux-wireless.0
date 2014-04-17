Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40083 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaDQSrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 14:47:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: increase tx/rx AMPDU window sizes for STA 11ac mode
Date: Thu, 17 Apr 2014 11:47:02 -0700
Message-ID: <1397760423-11455-4-git-send-email-bzhao@marvell.com> (sfid-20140417_204802_583130_D3BF21FF)
In-Reply-To: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This will help to aggregate more packets which yields better
throughput results for 11ac chipsets.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index b8e15ee..38da6ff 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -46,8 +46,8 @@
 #define MWIFIEX_STA_AMPDU_DEF_RXWINSIZE        64
 #define MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE        32
 #define MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE        16
-#define MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE   32
-#define MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE   48
+#define MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE   64
+#define MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE   64
 #define MWIFIEX_11AC_UAP_AMPDU_DEF_TXWINSIZE   48
 #define MWIFIEX_11AC_UAP_AMPDU_DEF_RXWINSIZE   32
 
-- 
1.8.2.3


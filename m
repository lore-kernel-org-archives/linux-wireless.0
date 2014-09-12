Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7794 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbaILJLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:37 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 16/16] mwifiex: modify TX/RX window sizes for AP interface
Date: Fri, 12 Sep 2014 20:09:00 +0530
Message-ID: <1410532740-3173-17-git-send-email-patila@marvell.com> (sfid-20140912_111148_781128_9E31DB32)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch sets uAP BA window sizes to 64.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 0e03fe3..e0d00a7 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -48,8 +48,8 @@
 #define MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE        16
 #define MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE   64
 #define MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE   64
-#define MWIFIEX_11AC_UAP_AMPDU_DEF_TXWINSIZE   48
-#define MWIFIEX_11AC_UAP_AMPDU_DEF_RXWINSIZE   32
+#define MWIFIEX_11AC_UAP_AMPDU_DEF_TXWINSIZE   64
+#define MWIFIEX_11AC_UAP_AMPDU_DEF_RXWINSIZE   64
 
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
 
-- 
1.8.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33858 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab3BPFpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 00:45:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: coding style cleanup in bss parameter update
Date: Fri, 15 Feb 2013 21:44:29 -0800
Message-Id: <1360993470-4828-2-git-send-email-bzhao@marvell.com> (sfid-20130216_064543_525115_47B7B2D0)
In-Reply-To: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
References: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

They all can make one line.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 949234f..e275aec 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1485,20 +1485,15 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
 	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
 	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
-	priv->curr_bss_params.bss_descriptor.ht_cap_offset =
-		0;
+	priv->curr_bss_params.bss_descriptor.ht_cap_offset = 0;
 	priv->curr_bss_params.bss_descriptor.bcn_ht_oper = NULL;
-	priv->curr_bss_params.bss_descriptor.ht_info_offset =
-		0;
-	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 =
-		NULL;
-	priv->curr_bss_params.bss_descriptor.
-		bss_co_2040_offset = 0;
+	priv->curr_bss_params.bss_descriptor.ht_info_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 = NULL;
+	priv->curr_bss_params.bss_descriptor.bss_co_2040_offset = 0;
 	priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
 	priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
 	priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
-	priv->curr_bss_params.bss_descriptor.beacon_buf_size =
-		0;
+	priv->curr_bss_params.bss_descriptor.beacon_buf_size = 0;
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
-- 
1.7.0.2


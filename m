Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbcBILQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 06:16:02 -0500
Date: Tue, 9 Feb 2016 14:15:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: fix an indenting mistake
Message-ID: <20160209111536.GC23998@mwanda> (sfid-20160209_121610_576802_26EA5977)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We recently added an indent level here but missed this line.  It needs
another tab.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index cc07214..efb19e2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2452,7 +2452,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 			for (i = 0; i < 4; i++) {
 				mwifiex_read_reg_byte(adapter, reg, &read_reg);
 				memory_size |= (read_reg << (i * 8));
-			reg++;
+				reg++;
 			}
 		} else {
 			memory_size = MWIFIEX_FW_DUMP_MAX_MEMSIZE;

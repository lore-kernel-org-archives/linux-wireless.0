Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:33981 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755268AbcK3TYQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 14:24:16 -0500
Date: Wed, 30 Nov 2016 22:21:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Karthik D A <karthida@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: clean up some messy indenting
Message-ID: <20161130192156.GD28180@mwanda> (sfid-20161130_202500_788727_13632E2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These lines were indented one tab extra.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index f5dffdf..fdc6cc2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1937,8 +1937,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "0x%x command not supported by firmware\n",
 			    cmd_no);
-			return -EOPNOTSUPP;
-		}
+		return -EOPNOTSUPP;
+	}
 
 	/* Prepare command */
 	switch (cmd_no) {

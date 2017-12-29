Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52791 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755389AbdL2Ibk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:40 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/11] rtlwifi: fix parenthesis alignment
Date: Fri, 29 Dec 2017 16:31:04 +0800
Message-ID: <20171229083112.31540-4-pkshih@realtek.com> (sfid-20171229_093321_014668_AF28ECD8)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This is merged by Ping-Ke Shih from commit 688a0206cfb8 ("staging:
rtlwifi: fix parenthesis alignment"), and original commit log is
reserved below.

Checkpatch emits multiple warnings of type

CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis

Fix parenthesis alignment in line with checkpatch suggestion.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 3cb88825473e..ac606d678ee3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1775,7 +1775,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				break;
 			case PWR_CMD_WRITE:
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_WRITE\n");
+					 "%s(): PWR_CMD_WRITE\n", __func__);
 				offset = GET_PWR_CFG_OFFSET(cfg_cmd);
 
 				/*Read the value from system register*/
-- 
2.14.1

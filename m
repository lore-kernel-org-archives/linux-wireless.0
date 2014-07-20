Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:46999 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbaGTOVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:21:43 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/30] rtlwifi: rtl8723be: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:17 +0200
Message-Id: <1405865801-18806-10-git-send-email-fabf@skynet.be> (sfid-20140720_162201_801892_3A5E37C0)
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
index e4a507a..4573310 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
@@ -124,7 +124,6 @@ bool rtlbe_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 					 "rtlbe_hal_pwrseqcmdparsing(): "
 					 "PWR_CMD_END\n");
 				return true;
-				break;
 			default:
 				RT_ASSERT(false,
 					  "rtlbe_hal_pwrseqcmdparsing(): "
-- 
1.9.1

